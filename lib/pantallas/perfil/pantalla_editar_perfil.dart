import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/validacion_registro.dart';
import '../../servicios/errores.dart';
import '../../tema/colores.dart';
import '../../widgets/campos.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/selector_grado.dart';
import '../../widgets/textos.dart';

class PantallaEditarPerfil extends StatefulWidget {
  const PantallaEditarPerfil({super.key});

  @override
  State<PantallaEditarPerfil> createState() => _PantallaEditarPerfilState();
}

class _PantallaEditarPerfilState extends State<PantallaEditarPerfil> {
  final _usuario = TextEditingController();
  final _nombre = TextEditingController();
  final _apellido = TextEditingController();
  final _correo = TextEditingController();
  final _actual = TextEditingController();
  final _nueva = TextEditingController();
  final _nueva2 = TextEditingController();
  final _claveError = GlobalKey();
  String? _grado;
  String _error = '';
  bool _ocupado = false;

  @override
  void initState() {
    super.initState();
    final usuario = context.read<EstadoUsuario>().usuario;
    if (usuario != null) {
      _usuario.text = usuario.nombreUsuario;
      _nombre.text = usuario.nombre;
      _apellido.text = usuario.apellido;
      _correo.text = usuario.correo;
      _grado = usuario.grado.isEmpty ? null : usuario.grado;
    }
  }

  @override
  void dispose() {
    for (final controlador in [
      _usuario,
      _nombre,
      _apellido,
      _correo,
      _actual,
      _nueva,
      _nueva2,
    ]) {
      controlador.dispose();
    }
    super.dispose();
  }

  void _mostrarError(String mensaje) {
    setState(() => _error = mensaje);
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      final contexto = _claveError.currentContext;
      if (contexto != null && contexto.mounted) {
        Scrollable.ensureVisible(
          contexto,
          alignment: 0.5,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _guardar() async {
    final estado = context.read<EstadoUsuario>();
    final usuarioActual = estado.usuario;
    if (_ocupado || usuarioActual == null) {
      return;
    }
    final usuario = _usuario.text.trim();
    final nombre = limpiarNombre(_nombre.text);
    final apellido = limpiarNombre(_apellido.text);
    final correo = _correo.text.trim();
    final actual = _actual.text;
    final nueva = _nueva.text;
    final nueva2 = _nueva2.text;
    final cambiaClave =
        actual.isNotEmpty || nueva.isNotEmpty || nueva2.isNotEmpty;
    var error = validarDatos(
      usuario: usuario,
      nombre: nombre,
      apellido: apellido,
      grado: _grado,
      correo: correo,
    );
    if (error == null && cambiaClave) {
      error = actual.isEmpty || nueva.isEmpty || nueva2.isEmpty
          ? 'Para cambiar la contraseña completa los tres campos.'
          : validarClaveNueva(nueva, nueva2);
    }
    if (error != null) {
      _mostrarError(error);
      return;
    }
    setState(() => _ocupado = true);
    final autenticacion = estado.autenticacion;
    try {
      if (cambiaClave && !await autenticacion.verificarContrasena(actual)) {
        throw const ErrorAcceso(Mensajes.claveActual);
      }
      await autenticacion.actualizarPerfil(
        usuarioActual,
        nombreUsuario: usuario,
        nombre: nombre,
        apellido: apellido,
        grado: _grado!,
        correo: correo,
      );
      if (cambiaClave) {
        await autenticacion.cambiarContrasena(actual, nueva);
      }
      if (mounted) {
        context.read<Navegacion>()
          ..mensajePerfil = 'Cambios guardados'
          ..irAPestana(Pestanas.perfil);
      }
    } on ErrorAcceso catch (error) {
      if (mounted) {
        _mostrarError(error.mensaje);
      }
    } finally {
      if (mounted) {
        setState(() => _ocupado = false);
      }
    }
  }

  List<Widget> _campo(
    String etiqueta,
    TextEditingController controlador,
    String pista, {
    bool oculto = false,
    TextInputType teclado = TextInputType.text,
  }) => [
    Etiqueta(etiqueta),
    CampoTexto(
      controlador: controlador,
      pista: pista,
      oculto: oculto,
      teclado: teclado,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 46, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                const NeoIcon.cuadrado('perfil', lado: 50),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: TextoDisplay('Editar perfil', tamano: 26),
                    ),
                  ),
                ),
              ],
            ),
            const Texto(
              'Actualiza tus datos y, si quieres, cambia tu contraseña.',
              negrita: true,
            ),
            NeoCard(
              radio: 18,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  ..._campo(
                    'NOMBRE DE USUARIO',
                    _usuario,
                    'Por ejemplo: luciaperez',
                  ),
                  ..._campo('NOMBRE', _nombre, 'Tu nombre...'),
                  ..._campo('APELLIDO', _apellido, 'Tu apellido...'),
                  const Etiqueta('GRADO ESCOLAR'),
                  SelectorGrado(
                    elegido: _grado,
                    alElegir: (grado) => setState(() => _grado = grado),
                  ),
                  ..._campo(
                    'CORREO',
                    _correo,
                    'nombre@correo.com',
                    teclado: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 6),
                  const Etiqueta('CAMBIAR CONTRASEÑA'),
                  const Texto(
                    'Opcional. Déjalo vacío si no quieres cambiarla.',
                    color: Colores.textoSec,
                    negrita: true,
                  ),
                  ..._campo(
                    'CONTRASEÑA ACTUAL',
                    _actual,
                    'Tu contraseña actual',
                    oculto: true,
                  ),
                  ..._campo(
                    'CONTRASEÑA NUEVA',
                    _nueva,
                    'Mínimo 6 caracteres',
                    oculto: true,
                  ),
                  ..._campo(
                    'REPITE LA CONTRASEÑA NUEVA',
                    _nueva2,
                    'Vuelve a escribirla',
                    oculto: true,
                  ),
                  const SizedBox(height: 2),
                  ErrorFormulario(_error, key: _claveError),
                  NeoButton(
                    'GUARDAR CAMBIOS',
                    tamano: 16,
                    alto: 56,
                    habilitado: !_ocupado,
                    onPressed: _guardar,
                  ),
                  NeoButton(
                    'CANCELAR',
                    superficie: Colores.tarjetaAlt,
                    colorTexto: Colores.texto,
                    alto: 52,
                    onPressed: () =>
                        context.read<Navegacion>().irAPestana(Pestanas.perfil),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
