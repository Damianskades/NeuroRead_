import 'dart:math';

import '../contenido/focus.dart';

class PalabraUsada {
  const PalabraUsada({
    required this.nivel,
    required this.palabra,
    required this.fecha,
  });

  final String nivel;
  final String palabra;
  final DateTime fecha;
}

List<ItemFocus> elegirItems(
  String clave,
  List<PalabraUsada> usadas, [
  Random? azar,
]) {
  final rng = azar ?? Random();
  final banco = bancosFocus[clave]!;
  final propias = usadas.where((usada) => usada.nivel == clave).toList();
  final fechas = usadas.map((usada) => usada.fecha).toSet().toList()
    ..sort((a, b) => b.compareTo(a));
  final ultimas = fechas.take(evaluacionesSinRepetir).toSet();
  final recientes = {
    for (final usada in propias)
      if (ultimas.contains(usada.fecha)) usada.palabra,
  };
  final ultimoUso = <String, DateTime>{};
  for (final usada in propias) {
    final anterior = ultimoUso[usada.palabra];
    if (anterior == null || usada.fecha.isAfter(anterior)) {
      ultimoUso[usada.palabra] = usada.fecha;
    }
  }

  List<String> tomar(List<String> lista, int cantidad) {
    final libres =
        lista.where((palabra) => !recientes.contains(palabra)).toList()
          ..shuffle(rng);
    final repetidas =
        [
          for (var i = 0; i < lista.length; i++)
            if (recientes.contains(lista[i])) (i, lista[i]),
        ]..sort((a, b) {
          final orden = ultimoUso[a.$2]!.compareTo(ultimoUso[b.$2]!);
          return orden != 0 ? orden : a.$1.compareTo(b.$1);
        });
    return [
      ...libres,
      ...repetidas.map((par) => par.$2),
    ].take(cantidad).toList();
  }

  final correctas = rng.nextBool() ? 3 : 4;
  final items = [
    for (final palabra in tomar(banco.si, correctas)) ItemFocus(palabra, true),
    for (final palabra in tomar(banco.no, palabrasPorNivel - correctas))
      ItemFocus(palabra, false),
  ]..shuffle(rng);
  return items;
}
