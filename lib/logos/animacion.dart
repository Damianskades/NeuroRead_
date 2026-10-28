import 'dart:ui';

typedef Curva = double Function(double);

Curva curvaCss(double x1, double y1, double x2, double y2) {
  double coordenada(double u, double a, double b) =>
      3 * (1 - u) * (1 - u) * u * a + 3 * (1 - u) * u * u * b + u * u * u;

  return (t) {
    if (t <= 0) {
      return 0;
    }
    if (t >= 1) {
      return 1;
    }
    var bajo = 0.0;
    var alto = 1.0;
    for (var i = 0; i < 24; i++) {
      final u = (bajo + alto) / 2;
      if (coordenada(u, x1, x2) < t) {
        bajo = u;
      } else {
        alto = u;
      }
    }
    return coordenada((bajo + alto) / 2, y1, y2);
  };
}

final Curva entradaSalida = curvaCss(0.42, 0, 0.58, 1);
final Curva salida = curvaCss(0, 0, 0.58, 1);

T _fotograma<T>(
  List<(double, T)> claves,
  double p,
  Curva curva,
  T Function(T, T, double) mezclar,
) {
  if (p <= claves.first.$1) {
    return claves.first.$2;
  }
  for (var i = 1; i < claves.length; i++) {
    final (p0, v0) = claves[i - 1];
    final (p1, v1) = claves[i];
    if (p <= p1) {
      return mezclar(v0, v1, p1 > p0 ? curva((p - p0) / (p1 - p0)) : 1);
    }
  }
  return claves.last.$2;
}

double fotograma(List<(double, double)> claves, double p, [Curva? curva]) =>
    _fotograma(claves, p, curva ?? entradaSalida, (a, b, t) => a + (b - a) * t);

Offset fotogramaPunto(
  List<(double, Offset)> claves,
  double p, [
  Curva? curva,
]) => _fotograma(
  claves,
  p,
  curva ?? entradaSalida,
  (a, b, t) => Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t),
);
