import '../logica/puntajes.dart';
import 'conversion.dart';

SesionResumen sesionDesdeMapa(String id, Map<String, dynamic> m) =>
    SesionResumen(
      id: id,
      fecha: fechaDe(m['ses_fecha']),
      tipo: m['ses_tipo'] as String? ?? 'inicial',
      textoId: enteroDe(m['ses_textoId']),
      puntajeGlobal: enteroDe(m['ses_puntajeGlobal']) ?? 0,
      nivel: m['ses_nivel'] as String?,
      velocidad: enteroDe(m['ses_velocidad']),
      comprension: enteroDe(m['ses_comprension']),
      interpretacion: enteroDe(m['ses_interpretacion']),
      imaginacion: enteroDe(m['ses_imaginacion']),
      concentracion: enteroDe(m['ses_concentracion']),
      retencion: enteroDe(m['ses_retencion']),
      literal: enteroDe(m['ses_literal']),
      inferencial: enteroDe(m['ses_inferencial']),
      critica: enteroDe(m['ses_critica']),
      tiempoLectura: decimalDe(m['ses_tiempoLectura']),
      ppm: enteroDe(m['ses_ppm']),
    );

Map<String, Object?> mapaDeSesion(SesionResumen s, String idUsuario) => {
  'id_usuario': idUsuario,
  'ses_fecha': marcaDe(s.fecha),
  'ses_tipo': s.tipo,
  'ses_textoId': s.textoId,
  'ses_puntajeGlobal': s.puntajeGlobal,
  'ses_nivel': s.nivel,
  'ses_velocidad': s.velocidad,
  'ses_comprension': s.comprension,
  'ses_interpretacion': s.interpretacion,
  'ses_imaginacion': s.imaginacion,
  'ses_concentracion': s.concentracion,
  'ses_retencion': s.retencion,
  'ses_literal': s.literal,
  'ses_inferencial': s.inferencial,
  'ses_critica': s.critica,
  'ses_tiempoLectura': s.tiempoLectura,
  'ses_ppm': s.ppm,
};
