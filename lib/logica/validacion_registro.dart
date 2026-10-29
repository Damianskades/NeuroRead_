final _usuario = RegExp(r'^[A-Za-z0-9_]{3,20}$');
final _nombre = RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÜüÑñ ]+$');
final _correo = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

const claveMinima = 6;

String limpiarNombre(String texto) =>
    texto.split(RegExp(r'\s+')).where((parte) => parte.isNotEmpty).join(' ');

String? validarDatos({
  required String usuario,
  required String nombre,
  required String apellido,
  required String? grado,
  required String correo,
}) {
  if ([usuario, nombre, apellido, grado ?? '', correo].any((v) => v.isEmpty)) {
    return 'Completa todos los campos y elige tu grado escolar.';
  }
  if (!_usuario.hasMatch(usuario)) {
    return 'El nombre de usuario debe tener de 3 a 20 caracteres: letras sin '
        'tilde, números o guion bajo.';
  }
  if (!_nombre.hasMatch(nombre)) {
    return 'El nombre solo puede tener letras, espacios y tildes.';
  }
  if (!_nombre.hasMatch(apellido)) {
    return 'El apellido solo puede tener letras, espacios y tildes.';
  }
  if (!_correo.hasMatch(correo)) {
    return 'Escribe un correo válido, por ejemplo nombre@correo.com.';
  }
  return null;
}

String? validarClaveNueva(String clave, String clave2) {
  if (clave.length < claveMinima) {
    return 'La contraseña debe tener al menos $claveMinima caracteres.';
  }
  if (clave != clave2) {
    return 'Las contraseñas no coinciden.';
  }
  return null;
}

String? validarRegistro({
  required String usuario,
  required String nombre,
  required String apellido,
  required String? grado,
  required String correo,
  required String clave,
  required String clave2,
}) {
  if ([
    usuario,
    nombre,
    apellido,
    grado ?? '',
    correo,
    clave,
    clave2,
  ].any((v) => v.isEmpty)) {
    return 'Completa todos los campos y elige tu grado escolar.';
  }
  return validarDatos(
        usuario: usuario,
        nombre: nombre,
        apellido: apellido,
        grado: grado,
        correo: correo,
      ) ??
      validarClaveNueva(clave, clave2);
}
