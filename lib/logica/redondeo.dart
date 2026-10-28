import 'dart:math' as math;

int redondear(num valor) {
  final x = valor.toDouble();
  final piso = x.floorToDouble();
  final resto = x - piso;
  final entero = piso.toInt();
  if (resto > 0.5) {
    return entero + 1;
  }
  if (resto < 0.5) {
    return entero;
  }
  return entero.isEven ? entero : entero + 1;
}

double redondearA(num valor, int decimales) {
  final x = valor.toDouble();
  final exacto = x.abs().toStringAsFixed(20);
  final punto = exacto.indexOf('.');
  final cola = exacto.substring(punto + 1 + decimales);
  final empate =
      cola.startsWith('5') && cola.substring(1).replaceAll('0', '').isEmpty;
  if (!empate) {
    return double.parse(x.toStringAsFixed(decimales));
  }
  final truncado = exacto.substring(
    0,
    decimales == 0 ? punto : punto + 1 + decimales,
  );
  final ultimo = int.parse(
    truncado
        .replaceAll('.', '')
        .substring(truncado.replaceAll('.', '').length - 1),
  );
  var magnitud = double.parse(truncado);
  if (ultimo.isOdd) {
    magnitud = double.parse(
      (magnitud + math.pow(10, -decimales)).toStringAsFixed(decimales),
    );
  }
  return x < 0 ? -magnitud : magnitud;
}

String textoDecimal(double valor) {
  if (valor == valor.truncateToDouble() && valor.abs() < 1e16) {
    return '${valor.toInt()}.0';
  }
  return valor.toString();
}

String textoCorto(double valor) {
  if (valor == valor.truncateToDouble() && valor.abs() < 1e16) {
    return '${valor.toInt()}';
  }
  return valor.toString();
}
