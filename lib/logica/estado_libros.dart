import '../contenido/libros.dart';

class EstadoLibro {
  const EstadoLibro(this.leidos, this.enCurso);

  final List<int> leidos;
  final bool enCurso;
}

Map<String, EstadoLibro> estadoLibros({
  required Map<String, List<int>> leidosPorLibro,
  required Map<String, DateTime> ultimaLectura,
  String? libroDeActividadEnCurso,
}) {
  var enCursoId = libroDeActividadEnCurso;
  if (enCursoId == null) {
    (DateTime, String)? mejor;
    for (final libro in libros) {
      final leidos = leidosPorLibro[libro.id]?.length ?? 0;
      final ultima = ultimaLectura[libro.id];
      if (leidos > 0 && leidos < libro.capitulos.length && ultima != null) {
        final candidato = (ultima, libro.id);
        if (mejor == null ||
            candidato.$1.isAfter(mejor.$1) ||
            (candidato.$1 == mejor.$1 &&
                candidato.$2.compareTo(mejor.$2) > 0)) {
          mejor = candidato;
        }
      }
    }
    enCursoId = mejor?.$2;
  }
  return {
    for (final libro in libros)
      libro.id: EstadoLibro(
        List.of(leidosPorLibro[libro.id] ?? const <int>[])..sort(),
        libro.id == enCursoId,
      ),
  };
}

int primerPendiente(Libro libro, List<int> leidos) {
  for (final capitulo in libro.capitulos) {
    if (!leidos.contains(capitulo.numero)) {
      return capitulo.numero;
    }
  }
  return 1;
}

String textoProgreso(Libro libro, List<int> leidos) {
  final n = leidos.length;
  if (n == 0) {
    return 'Sin empezar';
  }
  final unidad = libro.id == 'selva' ? 'cuentos leídos' : 'capítulos leídos';
  return '$n de ${libro.capitulos.length} $unidad';
}
