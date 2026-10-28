import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../tema/colores.dart';

void pintarNeo(
  Canvas canvas,
  Size size, {
  required Color superficie,
  required double radio,
  double sombra = 0,
  double borde = 0,
  double desplazamiento = 0,
  Color colorBorde = Colores.borde,
}) {
  final base = Offset.zero & size;
  final esquina = Radius.circular(radio);
  if (sombra > 0) {
    final actual = math.max(sombra - desplazamiento, 0.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(base.shift(Offset(actual, actual)), esquina),
      Paint()..color = Colores.borde,
    );
  }
  final cara = RRect.fromRectAndRadius(
    base.shift(Offset(desplazamiento, desplazamiento)),
    esquina,
  );
  canvas.drawRRect(cara, Paint()..color = superficie);
  if (borde > 0) {
    canvas.drawRRect(
      cara,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borde * 2
        ..color = colorBorde,
    );
  }
}

class PinturaNeo extends CustomPainter {
  const PinturaNeo({
    required this.superficie,
    required this.radio,
    this.sombra = 0,
    this.borde = 0,
    this.desplazamiento = 0,
    this.colorBorde = Colores.borde,
  });

  final Color superficie;
  final double radio;
  final double sombra;
  final double borde;
  final double desplazamiento;
  final Color colorBorde;

  @override
  void paint(Canvas canvas, Size size) => pintarNeo(
    canvas,
    size,
    superficie: superficie,
    radio: radio,
    sombra: sombra,
    borde: borde,
    desplazamiento: desplazamiento,
    colorBorde: colorBorde,
  );

  @override
  bool shouldRepaint(PinturaNeo anterior) =>
      anterior.superficie != superficie ||
      anterior.radio != radio ||
      anterior.sombra != sombra ||
      anterior.borde != borde ||
      anterior.desplazamiento != desplazamiento ||
      anterior.colorBorde != colorBorde;
}
