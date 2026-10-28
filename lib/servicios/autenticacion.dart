import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modelos/conversion.dart';
import '../modelos/usuario.dart';
import 'errores.dart';
import 'repositorio.dart';

class ServicioAutenticacion {
  ServicioAutenticacion({FirebaseAuth? auth, Repositorio? repositorio})
    : _auth = auth ?? FirebaseAuth.instance,
      repositorio = repositorio ?? Repositorio();

  final FirebaseAuth _auth;
  final Repositorio repositorio;

  static const dominioCuentas = 'neuroreadhyo.firebaseapp.com';
  static const _servidor = GetOptions(source: Source.server);
  static const _esperaLote = Duration(seconds: 15);

  Stream<String?> get cuenta => _auth.authStateChanges().map((u) => u?.uid);

  String? get uid => _auth.currentUser?.uid;

  static String _codificar(String texto) =>
      texto.replaceAll('%', '%25').replaceAll('/', '%2F');

  static String claveUsuario(String nombreUsuario) =>
      'u_${_codificar(nombreUsuario.trim().toLowerCase())}';

  static String claveCorreo(String correo) =>
      'c_${_codificar(correo.trim().toLowerCase())}';

  static String _correoInterno() {
    const letras = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final azar = Random.secure();
    final codigo = String.fromCharCodes([
      for (var i = 0; i < 24; i++)
        letras.codeUnitAt(azar.nextInt(letras.length)),
    ]);
    return '$codigo@$dominioCuentas';
  }

  Future<String?> _duenoDe(String clave) async {
    final doc = await repositorio.acceso(clave).get(_servidor);
    return doc.exists ? (doc.data()?['id_usuario'] as String?) : null;
  }

  Map<String, Object?> _acceso(User usuario) => {
    'id_usuario': usuario.uid,
    'acc_cuenta': usuario.email,
  };

  Future<Usuario> iniciarSesion(String login, String clave) async {
    final texto = login.trim();
    if (texto.isEmpty || clave.isEmpty) {
      throw const ErrorAcceso(Mensajes.credenciales);
    }
    try {
      final llave = texto.contains('@')
          ? claveCorreo(texto)
          : claveUsuario(texto);
      final doc = await repositorio.acceso(llave).get(_servidor);
      final cuenta = doc.exists ? (doc.data()?['acc_cuenta'] as String?) : null;
      if (cuenta == null) {
        throw const ErrorAcceso(Mensajes.credenciales);
      }
      final credencial = await _auth.signInWithEmailAndPassword(
        email: cuenta,
        password: clave,
      );
      final uid = credencial.user!.uid;
      final perfil = await repositorio.usuario(uid).get(_servidor);
      if (!perfil.exists || perfil.data()!['usu_estado'] != 'activo') {
        await _auth.signOut();
        throw const ErrorAcceso(Mensajes.credenciales);
      }
      return Usuario.desdeMapa(uid, perfil.data()!);
    } catch (error) {
      throw traducirError(error);
    }
  }

  Future<Usuario> registrar({
    required String nombreUsuario,
    required String nombre,
    required String apellido,
    required String grado,
    required String correo,
    required String clave,
  }) async {
    final llaveUsuario = claveUsuario(nombreUsuario);
    final llaveCorreo = claveCorreo(correo);
    try {
      if (await _duenoDe(llaveUsuario) != null) {
        throw const ErrorAcceso(Mensajes.usuarioExiste);
      }
      if (await _duenoDe(llaveCorreo) != null) {
        throw const ErrorAcceso(Mensajes.correoExiste);
      }
    } catch (error) {
      throw traducirError(error);
    }
    final User cuenta;
    try {
      cuenta = (await _auth.createUserWithEmailAndPassword(
        email: _correoInterno(),
        password: clave,
      )).user!;
    } catch (error) {
      throw traducirError(error);
    }
    final ahora = DateTime.now();
    final usuario = Usuario(
      id: cuenta.uid,
      nombreUsuario: nombreUsuario.trim(),
      nombre: nombre.trim(),
      apellido: apellido.trim(),
      grado: grado.trim(),
      correo: correo.trim().toLowerCase(),
      nivel: null,
      evaluacionInicial: false,
      estado: 'activo',
      creado: ahora,
      actualizado: ahora,
    );
    final lote = repositorio.lote()
      ..set(repositorio.acceso(llaveUsuario), _acceso(cuenta))
      ..set(repositorio.acceso(llaveCorreo), _acceso(cuenta))
      ..set(repositorio.usuario(cuenta.uid), usuario.aMapa());
    try {
      await lote.commit().timeout(_esperaLote, onTimeout: () {});
    } catch (error) {
      try {
        await cuenta.delete();
      } catch (_) {
        await _auth.signOut();
      }
      if (error is FirebaseException && error.code == 'permission-denied') {
        throw const ErrorAcceso(Mensajes.usuarioOCorreoExiste);
      }
      throw traducirError(error);
    }
    return usuario;
  }

  Future<void> actualizarPerfil(
    Usuario actual, {
    required String nombreUsuario,
    required String nombre,
    required String apellido,
    required String grado,
    required String correo,
  }) async {
    final cuenta = _auth.currentUser;
    if (cuenta == null || cuenta.uid != actual.id) {
      throw const ErrorAcceso(Mensajes.usuarioNoExiste);
    }
    final lote = repositorio.lote();
    final cambios = [
      (
        claveUsuario(actual.nombreUsuario),
        claveUsuario(nombreUsuario),
        Mensajes.usuarioExiste,
      ),
      (claveCorreo(actual.correo), claveCorreo(correo), Mensajes.correoExiste),
    ];
    var cambiaLlave = false;
    try {
      for (final (vieja, nueva, mensaje) in cambios) {
        if (vieja == nueva) {
          continue;
        }
        final dueno = await _duenoDe(nueva);
        if (dueno != null && dueno != cuenta.uid) {
          throw ErrorAcceso(mensaje);
        }
        if (await _duenoDe(vieja) == cuenta.uid) {
          lote.delete(repositorio.acceso(vieja));
        }
        lote.set(repositorio.acceso(nueva), _acceso(cuenta));
        cambiaLlave = true;
      }
    } catch (error) {
      throw traducirError(error);
    }
    lote.update(repositorio.usuario(actual.id), {
      'usu_nombreUs': nombreUsuario.trim(),
      'usu_nombre': nombre.trim(),
      'usu_apellido': apellido.trim(),
      'usu_grado': grado.trim(),
      'usu_correo': correo.trim().toLowerCase(),
      'usu_actualizado': marcaDe(DateTime.now()),
    });
    if (!cambiaLlave) {
      unawaited(lote.commit().catchError((_) {}));
      return;
    }
    try {
      await lote.commit().timeout(_esperaLote, onTimeout: () {});
    } catch (error) {
      if (error is FirebaseException && error.code == 'permission-denied') {
        throw const ErrorAcceso(Mensajes.usuarioOCorreoExiste);
      }
      throw traducirError(error);
    }
  }

  Future<User> _reautenticar(String clave, String mensaje) async {
    final cuenta = _auth.currentUser;
    if (cuenta == null || cuenta.email == null) {
      throw const ErrorAcceso(Mensajes.usuarioNoExiste);
    }
    try {
      await cuenta.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: cuenta.email!, password: clave),
      );
      return cuenta;
    } catch (error) {
      throw traducirError(error, credenciales: mensaje);
    }
  }

  Future<bool> verificarContrasena(String clave) async {
    try {
      await _reautenticar(clave, Mensajes.claveActual);
      return true;
    } on ErrorAcceso catch (error) {
      if (error.mensaje == Mensajes.claveActual) {
        return false;
      }
      rethrow;
    }
  }

  Future<void> cambiarContrasena(String actual, String nueva) async {
    final cuenta = await _reautenticar(actual, Mensajes.claveActual);
    try {
      await cuenta.updatePassword(nueva);
    } catch (error) {
      throw traducirError(error);
    }
  }

  Future<void> eliminarCuenta(String clave) async {
    final cuenta = await _reautenticar(clave, Mensajes.claveIncorrecta);
    final uid = cuenta.uid;
    try {
      final perfil = await repositorio.usuario(uid).get(_servidor);
      final documentos = await repositorio.documentosDelUsuario(uid);
      for (var i = 0; i < documentos.length; i += 400) {
        final lote = repositorio.lote();
        for (final referencia in documentos.skip(i).take(400)) {
          lote.delete(referencia);
        }
        await lote.commit();
      }
      final lote = repositorio.lote();
      if (perfil.exists) {
        final datos = perfil.data()!;
        for (final llave in [
          claveUsuario(datos['usu_nombreUs'] as String? ?? ''),
          claveCorreo(datos['usu_correo'] as String? ?? ''),
        ]) {
          if (await _duenoDe(llave) == uid) {
            lote.delete(repositorio.acceso(llave));
          }
        }
        lote.delete(repositorio.usuario(uid));
      }
      await lote.commit();
      await cuenta.delete();
    } catch (error) {
      throw traducirError(error);
    }
  }

  Future<void> cerrarSesion() => _auth.signOut();
}
