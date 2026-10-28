import 'package:flutter/widgets.dart';

import '../tema/colores.dart';

enum FormaDeco { cruz, punto, aro }

class FiguraDeco {
  const FiguraDeco(this.forma, this.x, this.y, this.alfa, this.radio);

  final FormaDeco forma;
  final double x;
  final double y;
  final double alfa;
  final double radio;
}

const _figuras = <int, List<FiguraDeco>>{
  4: [
    FiguraDeco(FormaDeco.cruz, 0.257164, 0.261900, 0.321843, 4.199545),
    FiguraDeco(FormaDeco.aro, 0.409464, 0.750773, 0.486594, 3.943856),
    FiguraDeco(FormaDeco.cruz, 0.533746, 0.366010, 0.308669, 4.643201),
    FiguraDeco(FormaDeco.aro, 0.893278, 0.697352, 0.496121, 3.886871),
    FiguraDeco(FormaDeco.punto, 0.325062, 0.576185, 0.510755, 3.232071),
    FiguraDeco(FormaDeco.punto, 0.119781, 0.563511, 0.416608, 2.248906),
  ],
  8: [
    FiguraDeco(FormaDeco.cruz, 0.248569, 0.777377, 0.470301, 4.255556),
    FiguraDeco(FormaDeco.cruz, 0.267646, 0.799477, 0.453304, 5.377401),
    FiguraDeco(FormaDeco.cruz, 0.456882, 0.496990, 0.504241, 4.268697),
    FiguraDeco(FormaDeco.cruz, 0.255448, 0.211995, 0.390069, 6.706193),
    FiguraDeco(FormaDeco.cruz, 0.388749, 0.268239, 0.547733, 4.189266),
    FiguraDeco(FormaDeco.punto, 0.610555, 0.426323, 0.371378, 2.967821),
  ],
  23: [
    FiguraDeco(FormaDeco.aro, 0.890876, 0.769163, 0.302559, 4.684054),
    FiguraDeco(FormaDeco.cruz, 0.429848, 0.518053, 0.331839, 5.333721),
    FiguraDeco(FormaDeco.cruz, 0.243356, 0.473020, 0.303159, 6.130025),
    FiguraDeco(FormaDeco.punto, 0.427548, 0.507580, 0.376929, 2.080576),
    FiguraDeco(FormaDeco.punto, 0.760454, 0.553474, 0.447668, 3.359029),
    FiguraDeco(FormaDeco.cruz, 0.373769, 0.655872, 0.434453, 5.981596),
  ],
  31: [
    FiguraDeco(FormaDeco.cruz, 0.051296, 0.267439, 0.464643, 4.416073),
    FiguraDeco(FormaDeco.punto, 0.143448, 0.339081, 0.319798, 3.036917),
    FiguraDeco(FormaDeco.punto, 0.649193, 0.281947, 0.400893, 2.577598),
    FiguraDeco(FormaDeco.cruz, 0.956636, 0.255867, 0.533747, 5.208837),
    FiguraDeco(FormaDeco.cruz, 0.222618, 0.398186, 0.537880, 4.630997),
    FiguraDeco(FormaDeco.punto, 0.239572, 0.550941, 0.537511, 3.174156),
  ],
};

class NeoDeco extends StatelessWidget {
  const NeoDeco({
    super.key,
    required this.semilla,
    this.tinte = Colores.dorado,
    this.alto,
    this.ancho,
  });

  final int semilla;
  final Color tinte;
  final double? alto;
  final double? ancho;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: ancho,
    height: alto,
    child: CustomPaint(
      painter: _PinturaDeco(_figuras[semilla] ?? const [], tinte),
    ),
  );
}

class _PinturaDeco extends CustomPainter {
  const _PinturaDeco(this.figuras, this.tinte);

  final List<FiguraDeco> figuras;
  final Color tinte;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w < 40 || h < 10) {
      return;
    }
    for (final figura in figuras) {
      final centro = Offset(figura.x * w, h - figura.y * h);
      final color = tinte.withValues(alpha: figura.alfa);
      final r = figura.radio;
      switch (figura.forma) {
        case FormaDeco.cruz:
          final trazo = Paint()
            ..color = color
            ..strokeWidth = 3.2
            ..strokeCap = StrokeCap.round;
          canvas.drawLine(
            centro.translate(-r, 0),
            centro.translate(r, 0),
            trazo,
          );
          canvas.drawLine(
            centro.translate(0, -r),
            centro.translate(0, r),
            trazo,
          );
        case FormaDeco.punto:
          canvas.drawCircle(centro, r, Paint()..color = color);
        case FormaDeco.aro:
          canvas.drawCircle(
            centro,
            r,
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.8,
          );
      }
    }
  }

  @override
  bool shouldRepaint(_PinturaDeco anterior) =>
      anterior.figuras != figuras || anterior.tinte != tinte;
}
