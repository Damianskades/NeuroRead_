import 'dart:math' as math;

import '../contenido/actividades.dart';
import '../contenido/config.dart';
import '../contenido/libros.dart';
import '../contenido/niveles.dart';

enum EstadoActividad { enCurso, pendiente, completada }

String habilidadMasBaja(Map<String, int?>? porcentajes) {
  String? clave;
  int? menor;
  for (final habilidad in habilidades.keys) {
    final valor = porcentajes?[habilidad];
    if (valor != null && (menor == null || valor < menor)) {
      clave = habilidad;
      menor = valor;
    }
  }
  return clave ?? 'literal';
}

int actividadesFaltantes(int hechas) =>
    math.max(actividadesParaDesbloquear - hechas, 0);

final Map<String, int> _ordenLibros = {
  for (var i = 0; i < libros.length; i++) libros[i].id: i,
};

List<(Actividad, EstadoActividad)> ordenarRuta({
  required String nivel,
  required List<String> enCursoRecientes,
  required Set<String> completadas,
  required Map<String, int?> porcentajes,
}) {
  final recientes = {
    for (var i = 0; i < enCursoRecientes.length; i++) enCursoRecientes[i]: i,
  };
  const rango = {
    EstadoActividad.enCurso: 0,
    EstadoActividad.pendiente: 1,
    EstadoActividad.completada: 2,
  };
  final filas = [
    for (final actividad in actividadesDeNivel(nivel))
      (
        actividad,
        recientes.containsKey(actividad.id)
            ? EstadoActividad.enCurso
            : (completadas.contains(actividad.id)
                  ? EstadoActividad.completada
                  : EstadoActividad.pendiente),
      ),
  ];
  List<int> clave((Actividad, EstadoActividad) fila) {
    final (actividad, estado) = fila;
    return [
      rango[estado]!,
      recientes[actividad.id] ?? 0,
      porcentajes[actividad.habilidad] ?? 101,
      _ordenLibros[actividad.libroId]!,
      actividad.orden,
    ];
  }

  filas.sort((a, b) {
    final ka = clave(a);
    final kb = clave(b);
    for (var i = 0; i < ka.length; i++) {
      if (ka[i] != kb[i]) {
        return ka[i].compareTo(kb[i]);
      }
    }
    return 0;
  });
  return filas;
}
