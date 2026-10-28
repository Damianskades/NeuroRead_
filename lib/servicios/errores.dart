import 'package:firebase_auth/firebase_auth.dart';

abstract final class Mensajes {
  static const credenciales =
      'Usuario o contraseña incorrectos. Intenta de nuevo.';
  static const usuarioExiste = 'Ese nombre de usuario ya existe.';
  static const correoExiste = 'Ese correo ya está registrado.';
  static const usuarioOCorreoExiste =
      'Ese nombre de usuario o correo ya existe.';
  static const claveActual = 'La contraseña actual no es correcta.';
  static const claveIncorrecta = 'La contraseña no es correcta.';
  static const usuarioNoExiste = 'El usuario no existe.';
  static const sinConexion =
      'No hay conexión a internet. Revisa tu conexión e intenta de nuevo.';
  static const demasiadosIntentos =
      'Hiciste demasiados intentos. Espera unos minutos e intenta de nuevo.';
  static const general = 'No se pudo completar la acción. Intenta de nuevo.';
}

class ErrorAcceso implements Exception {
  const ErrorAcceso(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

const _codigosRed = {
  'network-request-failed',
  'unavailable',
  'deadline-exceeded',
};
const _codigosCredenciales = {
  'wrong-password',
  'invalid-credential',
  'user-not-found',
  'invalid-email',
  'user-disabled',
};

ErrorAcceso traducirError(
  Object error, {
  String credenciales = Mensajes.credenciales,
}) {
  if (error is ErrorAcceso) {
    return error;
  }
  if (error is FirebaseAuthException || error is FirebaseException) {
    final codigo = (error as FirebaseException).code;
    if (_codigosRed.contains(codigo)) {
      return const ErrorAcceso(Mensajes.sinConexion);
    }
    if (codigo == 'too-many-requests') {
      return const ErrorAcceso(Mensajes.demasiadosIntentos);
    }
    if (_codigosCredenciales.contains(codigo)) {
      return ErrorAcceso(credenciales);
    }
  }
  return const ErrorAcceso(Mensajes.general);
}
