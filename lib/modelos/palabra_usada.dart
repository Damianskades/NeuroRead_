import '../logica/focus.dart';
import 'conversion.dart';

PalabraUsada palabraDesdeMapa(Map<String, dynamic> m) => PalabraUsada(
  nivel: m['pal_nivel'] as String? ?? '',
  palabra: m['pal_palabra'] as String? ?? '',
  fecha: fechaDe(m['pal_fecha']),
);

Map<String, Object?> mapaDePalabra(PalabraUsada p, String idUsuario) => {
  'id_usuario': idUsuario,
  'pal_nivel': p.nivel,
  'pal_palabra': p.palabra,
  'pal_fecha': marcaDe(p.fecha),
};
