import 'conversion.dart';

class Usuario {
  const Usuario({
    required this.id,
    required this.nombreUsuario,
    required this.nombre,
    required this.apellido,
    required this.grado,
    required this.correo,
    required this.nivel,
    required this.evaluacionInicial,
    required this.estado,
    required this.creado,
    required this.actualizado,
  });

  factory Usuario.desdeMapa(String id, Map<String, dynamic> m) => Usuario(
    id: id,
    nombreUsuario: m['usu_nombreUs'] as String? ?? '',
    nombre: m['usu_nombre'] as String? ?? '',
    apellido: m['usu_apellido'] as String? ?? '',
    grado: m['usu_grado'] as String? ?? '',
    correo: m['usu_correo'] as String? ?? '',
    nivel: m['usu_nivel'] as String?,
    evaluacionInicial: m['usu_evaluacionInicial'] as bool? ?? false,
    estado: m['usu_estado'] as String? ?? 'activo',
    creado: fechaDe(m['usu_creado']),
    actualizado: fechaDe(m['usu_actualizado']),
  );

  final String id;
  final String nombreUsuario;
  final String nombre;
  final String apellido;
  final String grado;
  final String correo;
  final String? nivel;
  final bool evaluacionInicial;
  final String estado;
  final DateTime creado;
  final DateTime actualizado;

  Map<String, Object?> aMapa() => {
    'id_usuario': id,
    'usu_nombreUs': nombreUsuario,
    'usu_nombre': nombre,
    'usu_apellido': apellido,
    'usu_grado': grado,
    'usu_correo': correo,
    'usu_nivel': nivel,
    'usu_evaluacionInicial': evaluacionInicial,
    'usu_estado': estado,
    'usu_creado': marcaDe(creado),
    'usu_actualizado': marcaDe(actualizado),
  };
}
