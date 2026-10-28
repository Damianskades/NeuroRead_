import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';

const negro = Colores.borde;
const crema = Colores.texto;
const maxPaso = 0.1;

double radianes(double grados) => grados * math.pi / 180;

abstract class PinturaLogo extends CustomPainter {
  const PinturaLogo(this.t);

  final double t;

  Size get vista => const Size(200, 200);

  void dibujar(Canvas canvas);

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width / vista.width, size.height / vista.height);
    canvas.save();
    canvas.translate(
      (size.width - vista.width * s) / 2,
      (size.height - vista.height * s) / 2,
    );
    canvas.scale(s);
    dibujar(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(PinturaLogo anterior) => anterior.t != t;
}

void relleno(Canvas canvas, Path camino, Color color) =>
    canvas.drawPath(camino, Paint()..color = color);

void linea(
  Canvas canvas,
  Path camino,
  double ancho,
  Color color, {
  StrokeCap remate = StrokeCap.round,
}) => canvas.drawPath(
  camino,
  Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = ancho
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = remate
    ..color = color,
);

Path segmento(double x1, double y1, double x2, double y2) => Path()
  ..moveTo(x1, y1)
  ..lineTo(x2, y2);

void rect(
  Canvas canvas,
  double x,
  double y,
  double w,
  double h,
  Color color, {
  double r = 0,
  Color? borde,
  double anchoBorde = 0,
  double alfa = 1,
}) {
  final caja = Rect.fromLTWH(x, y, w, h);
  final redondeada = RRect.fromRectAndRadius(caja, Radius.circular(r));
  final pintura = Paint()..color = color.withValues(alpha: alfa);
  if (r > 0) {
    canvas.drawRRect(redondeada, pintura);
  } else {
    canvas.drawRect(caja, pintura);
  }
  if (borde != null) {
    final trazo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = anchoBorde
      ..color = borde;
    if (r > 0) {
      canvas.drawRRect(redondeada, trazo);
    } else {
      canvas.drawRect(caja, trazo..strokeJoin = StrokeJoin.miter);
    }
  }
}

void circulo(
  Canvas canvas,
  Offset centro,
  double r,
  Color color, {
  Color? borde,
  double anchoBorde = 0,
  double alfa = 1,
}) {
  canvas.drawCircle(centro, r, Paint()..color = color.withValues(alpha: alfa));
  if (borde != null) {
    canvas.drawCircle(
      centro,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = anchoBorde
        ..color = borde,
    );
  }
}

void texto(
  Canvas canvas,
  String cadena,
  double x,
  double y,
  double tamano,
  Color color, {
  double contorno = 0,
}) {
  TextPainter pintor(Paint? trazo) => TextPainter(
    text: TextSpan(
      text: cadena,
      style: TextStyle(
        fontFamily: Tipografia.familia,
        fontFamilyFallback: Tipografia.respaldo,
        fontWeight: FontWeight.w700,
        fontSize: tamano,
        color: trazo == null ? color : null,
        foreground: trazo,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  final relleno = pintor(null);
  final base = relleno.computeDistanceToActualBaseline(TextBaseline.alphabetic);
  final posicion = Offset(x - relleno.width / 2, y - base);
  if (contorno > 0) {
    final trazo = pintor(
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = contorno * 2
        ..strokeJoin = StrokeJoin.round
        ..color = negro,
    );
    trazo.paint(canvas, posicion);
    trazo.dispose();
  }
  relleno.paint(canvas, posicion);
  relleno.dispose();
}

const _hoja = Rect.fromLTWH(8, 8, 172, 172);

RRect get hojaRedondeada =>
    RRect.fromRectAndRadius(_hoja, const Radius.circular(40));

void cuadradoHoja(Canvas canvas, [Color color = crema]) {
  canvas.drawRRect(
    hojaRedondeada.shift(const Offset(10, 10)),
    Paint()..color = negro,
  );
  canvas.drawRRect(hojaRedondeada, Paint()..color = color);
}

void bordeHoja(Canvas canvas) => canvas.drawRRect(
  hojaRedondeada,
  Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6
    ..color = negro,
);

void rotarEn(Canvas canvas, double grados, double x, double y) {
  canvas.translate(x, y);
  canvas.rotate(radianes(grados));
  canvas.translate(-x, -y);
}

void escalarEn(Canvas canvas, double sx, double sy, double x, double y) {
  canvas.translate(x, y);
  canvas.scale(sx, sy);
  canvas.translate(-x, -y);
}
