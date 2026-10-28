import 'dart:math' as math;

final _token = RegExp('[a-záéíóúüñ]+');

List<String> _tokens(String texto) => _token
    .allMatches(texto.toLowerCase())
    .map((coincidencia) => coincidencia.group(0)!)
    .toList();

int contarPalabras(String texto) => _tokens(texto).length;

class Redaccion {
  const Redaccion(this.valida, this.mensaje, this.total);

  final bool valida;
  final String mensaje;
  final int total;
}

(T, int) _masComun<T>(Iterable<T> elementos) {
  final conteo = <T, int>{};
  for (final elemento in elementos) {
    conteo[elemento] = (conteo[elemento] ?? 0) + 1;
  }
  late T mejor;
  var veces = 0;
  for (final MapEntry(:key, :value) in conteo.entries) {
    if (value > veces) {
      mejor = key;
      veces = value;
    }
  }
  return (mejor, veces);
}

Redaccion analizarRedaccion(String texto, {int minPalabras = 10}) {
  final tokens = _tokens(texto);
  final total = tokens.length;
  if (total == 0) {
    return const Redaccion(false, 'Escribe tu respuesta para continuar.', 0);
  }
  if (total < minPalabras) {
    return Redaccion(
      false,
      'Escribe al menos $minPalabras palabras ($total escritas).',
      total,
    );
  }
  final ratio = tokens.toSet().length / total;
  final (palabra, repes) = _masComun(tokens);
  if (repes > math.max(4, (total * 0.30).floor())) {
    return Redaccion(
      false,
      'Repites demasiado la palabra $palabra. Usa vocabulario variado.',
      total,
    );
  }
  if (ratio < 0.50) {
    return Redaccion(
      false,
      'Tu texto repite muchas palabras. Desarrolla ideas nuevas.',
      total,
    );
  }
  if (tokens.length > 1) {
    final pares = [
      for (var i = 0; i < tokens.length - 1; i++)
        '${tokens[i]} ${tokens[i + 1]}',
    ];
    final (_, veces) = _masComun(pares);
    if (veces >= 3) {
      return Redaccion(
        false,
        'No repitas la misma frase. Expresa ideas diferentes.',
        total,
      );
    }
  }
  final cortas = tokens.where((token) => token.length <= 2).length;
  if (cortas / total > 0.55) {
    return Redaccion(
      false,
      'Usa palabras completas y oraciones con sentido.',
      total,
    );
  }
  return Redaccion(true, '', total);
}
