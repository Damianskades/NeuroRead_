import 'conversion.dart';

class RespuestaPaso {
  const RespuestaPaso({
    required this.paso,
    required this.tipo,
    required this.correcta,
    required this.valor,
  });

  factory RespuestaPaso.desdeMapa(Map<String, dynamic> m) => RespuestaPaso(
    paso: enteroDe(m['paso']) ?? 0,
    tipo: m['tipo'] as String? ?? '',
    correcta: m['correcta'] as bool? ?? false,
    valor: switch (m['valor']) {
      final num numero => numero.toInt(),
      final List<dynamic> lista => lista.cast<String>(),
      final otro => otro,
    },
  );

  final int paso;
  final String tipo;
  final bool correcta;
  final Object? valor;

  Map<String, Object?> aMapa() => {
    'paso': paso,
    'tipo': tipo,
    'correcta': correcta,
    'valor': valor,
  };
}

List<RespuestaPaso> _respuestas(Object? lista) => [
  for (final elemento in (lista as List<dynamic>? ?? const []))
    RespuestaPaso.desdeMapa(Map<String, dynamic>.from(elemento as Map)),
];

class CapituloLeido {
  const CapituloLeido({
    required this.libroId,
    required this.capitulo,
    required this.fecha,
  });

  factory CapituloLeido.desdeMapa(Map<String, dynamic> m) => CapituloLeido(
    libroId: m['cap_libroId'] as String? ?? '',
    capitulo: enteroDe(m['cap_capitulo']) ?? 0,
    fecha: fechaDe(m['cap_fecha']),
  );

  final String libroId;
  final int capitulo;
  final DateTime fecha;

  static String idDocumento(String libroId, int capitulo) =>
      '${libroId}_${capitulo.toString().padLeft(2, '0')}';

  Map<String, Object?> aMapa(String idUsuario) => {
    'id_usuario': idUsuario,
    'cap_libroId': libroId,
    'cap_capitulo': capitulo,
    'cap_fecha': marcaDe(fecha),
  };
}

class ActividadCompletada {
  const ActividadCompletada({
    this.id,
    required this.actividadId,
    required this.libroId,
    required this.nivel,
    required this.aciertos,
    required this.total,
    required this.respuestas,
    required this.fecha,
  });

  factory ActividadCompletada.desdeMapa(String id, Map<String, dynamic> m) =>
      ActividadCompletada(
        id: id,
        actividadId: m['aco_actividadId'] as String? ?? '',
        libroId: m['aco_libroId'] as String?,
        nivel: m['aco_nivel'] as String?,
        aciertos: enteroDe(m['aco_aciertos']) ?? 0,
        total: enteroDe(m['aco_total']) ?? 0,
        respuestas: _respuestas(m['aco_respuesta']),
        fecha: fechaDe(m['aco_fecha']),
      );

  final String? id;
  final String actividadId;
  final String? libroId;
  final String? nivel;
  final int aciertos;
  final int total;
  final List<RespuestaPaso> respuestas;
  final DateTime fecha;

  Map<String, Object?> aMapa(String idUsuario) => {
    'id_usuario': idUsuario,
    'aco_actividadId': actividadId,
    'aco_libroId': libroId,
    'aco_nivel': nivel,
    'aco_aciertos': aciertos,
    'aco_total': total,
    'aco_respuesta': [for (final r in respuestas) r.aMapa()],
    'aco_fecha': marcaDe(fecha),
  };
}

class ActividadEnCurso {
  const ActividadEnCurso({
    required this.actividadId,
    required this.paso,
    required this.respuestas,
    required this.actualizado,
  });

  factory ActividadEnCurso.desdeMapa(Map<String, dynamic> m) =>
      ActividadEnCurso(
        actividadId: m['aec_actividadId'] as String? ?? '',
        paso: enteroDe(m['aec_paso']) ?? 0,
        respuestas: _respuestas(m['aec_respuestas']),
        actualizado: fechaDe(m['aec_actualizado']),
      );

  final String actividadId;
  final int paso;
  final List<RespuestaPaso> respuestas;
  final DateTime actualizado;

  Map<String, Object?> aMapa(String idUsuario) => {
    'id_usuario': idUsuario,
    'aec_actividadId': actividadId,
    'aec_paso': paso,
    'aec_respuestas': [for (final r in respuestas) r.aMapa()],
    'aec_actualizado': marcaDe(actualizado),
  };
}
