import '../contenido/modulos.dart';
import '../contenido/niveles.dart';
import 'puntajes.dart';

class Logro {
  const Logro(this.nombre, this.detalle, this.ok);

  final String nombre;
  final String detalle;
  final bool ok;
}

bool _subioDeNivel(List<SesionResumen> sesiones) {
  final indices = [
    for (final sesion in sesiones)
      if (sesion.nivel != null && sesion.nivel!.isNotEmpty)
        indiceNivel(sesion.nivel),
  ];
  for (var i = 1; i < indices.length; i++) {
    if (indices[i] > indices[i - 1]) {
      return true;
    }
  }
  return false;
}

List<Logro> generarLogros({
  required List<SesionResumen> sesiones,
  required Map<String, int> leidosPorLibro,
  required Map<String, int> capitulosPorLibro,
  bool hayUsuario = true,
}) {
  final lista = hayUsuario ? sesiones : const <SesionResumen>[];
  final libroCompleto = capitulosPorLibro.entries.any(
    (entrada) =>
        entrada.value > 0 &&
        (leidosPorLibro[entrada.key] ?? 0) >= entrada.value,
  );
  return [
    Logro(
      'Primera evaluación',
      'Completa tu evaluación inicial.',
      lista.isNotEmpty,
    ),
    Logro(
      'Subiste de nivel',
      'Sube de nivel en una evaluación clasificatoria.',
      _subioDeNivel(lista),
    ),
    Logro(
      'Velocista',
      'Lee a 200 palabras por minuto o más.',
      lista.any((sesion) => (sesion.ppm ?? 0) >= ppmVelocista),
    ),
    Logro(
      'Memoria de acero',
      'Responde bien todas las preguntas de NeuroMemory.',
      lista.any((sesion) => (sesion.retencion ?? 0) >= 100),
    ),
    Logro(
      'Primer libro',
      'Lee todos los capítulos de un libro.',
      hayUsuario && libroCompleto,
    ),
  ];
}
