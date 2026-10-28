import 'dart:ui' show PathMetric;

import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';

class BotonBloqueado extends StatelessWidget {
  const BotonBloqueado(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 50,
    width: double.infinity,
    child: CustomPaint(
      painter: _PinturaBloqueado(1 / MediaQuery.devicePixelRatioOf(context)),
      child: Center(
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: Tipografia.display(14, color: Colores.textoSec),
        ),
      ),
    ),
  );
}

class _PinturaBloqueado extends CustomPainter {
  const _PinturaBloqueado(this.pixel);

  final double pixel;

  @override
  void paint(Canvas canvas, Size size) {
    const radio = Radius.circular(14);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, radio),
      Paint()..color = Colores.tarjetaAlt,
    );
    final contorno = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            pixel,
            pixel,
            size.width - 2 * pixel,
            size.height - 2 * pixel,
          ),
          radio,
        ),
      );
    final trazo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = pixel
      ..color = Colores.textoSec;
    for (final PathMetric medida in contorno.computeMetrics()) {
      var inicio = 0.0;
      while (inicio < medida.length) {
        canvas.drawPath(medida.extractPath(inicio, inicio + 6), trazo);
        inicio += 10;
      }
    }
  }

  @override
  bool shouldRepaint(_PinturaBloqueado anterior) => anterior.pixel != pixel;
}
