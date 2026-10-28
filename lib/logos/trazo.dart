import 'dart:ui';

final _fichas = RegExp(r'[MLHVCQZ]|-?[0-9.]+');
final _orden = RegExp('[A-Z]');

Path trazo(String d) {
  final fichas = _fichas
      .allMatches(d)
      .map((coincidencia) => coincidencia.group(0)!)
      .toList();
  final camino = Path();
  var actual = Offset.zero;
  var inicio = Offset.zero;
  var orden = 'M';
  var i = 0;
  double numero() => double.parse(fichas[i++]);
  while (i < fichas.length) {
    if (_orden.hasMatch(fichas[i])) {
      orden = fichas[i++];
      if (orden == 'Z') {
        camino.close();
        actual = inicio;
      }
      continue;
    }
    switch (orden) {
      case 'M':
        actual = Offset(numero(), numero());
        inicio = actual;
        camino.moveTo(actual.dx, actual.dy);
        orden = 'L';
      case 'L':
        actual = Offset(numero(), numero());
        camino.lineTo(actual.dx, actual.dy);
      case 'H':
        actual = Offset(numero(), actual.dy);
        camino.lineTo(actual.dx, actual.dy);
      case 'V':
        actual = Offset(actual.dx, numero());
        camino.lineTo(actual.dx, actual.dy);
      case 'C':
        final a = Offset(numero(), numero());
        final b = Offset(numero(), numero());
        actual = Offset(numero(), numero());
        camino.cubicTo(a.dx, a.dy, b.dx, b.dy, actual.dx, actual.dy);
      case 'Q':
        final a = Offset(numero(), numero());
        actual = Offset(numero(), numero());
        camino.quadraticBezierTo(a.dx, a.dy, actual.dx, actual.dy);
    }
  }
  return camino;
}
