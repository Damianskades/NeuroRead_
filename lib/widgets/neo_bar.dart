import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../tema/colores.dart';

class NeoBar extends StatelessWidget {
  const NeoBar({
    super.key,
    required this.valor,
    this.maximo = 100,
    this.relleno = Colores.dorado,
    this.radio = 7,
    this.alto = 14,
    this.marcas = const [],
    this.meta,
    this.colorMeta = Colores.dorado,
  });

  final double valor;
  final double maximo;
  final Color relleno;
  final double radio;
  final double alto;
  final List<double> marcas;
  final double? meta;
  final Color colorMeta;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: alto,
    width: double.infinity,
    child: CustomPaint(
      painter: _PinturaBarra(
        valor: valor,
        maximo: maximo,
        relleno: relleno,
        radio: radio,
        marcas: marcas,
        meta: meta,
        colorMeta: colorMeta,
      ),
    ),
  );
}

class _PinturaBarra extends CustomPainter {
  const _PinturaBarra({
    required this.valor,
    required this.maximo,
    required this.relleno,
    required this.radio,
    required this.marcas,
    required this.meta,
    required this.colorMeta,
  });

  final double valor;
  final double maximo;
  final Color relleno;
  final double radio;
  final List<double> marcas;
  final double? meta;
  final Color colorMeta;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final esquina = Radius.circular(radio);
    final fraccion = maximo == 0 ? 0.0 : (valor / maximo).clamp(0.0, 1.0);
    final caja = RRect.fromRectAndRadius(Offset.zero & size, esquina);
    canvas.drawRRect(
      caja.shift(const Offset(3, 3)),
      Paint()..color = Colores.borde,
    );
    canvas.drawRRect(caja, Paint()..color = Colores.tarjetaAlt);
    if (fraccion > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, math.max(w * fraccion, h), h),
          esquina,
        ),
        Paint()..color = relleno,
      );
    }
    canvas.drawRRect(
      caja,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Colores.borde,
    );
    if (maximo == 0) {
      return;
    }
    for (final marca in marcas) {
      if (marca == meta) {
        continue;
      }
      canvas.drawRect(
        Rect.fromLTWH(w * marca / maximo - 1, 0, 2, h),
        Paint()..color = Colores.textoSec,
      );
    }
    final objetivo = meta;
    if (objetivo != null && marcas.contains(objetivo)) {
      canvas.drawRect(
        Rect.fromLTWH(w * objetivo / maximo - 1, -4, 2, h + 8),
        Paint()..color = colorMeta,
      );
    }
  }

  @override
  bool shouldRepaint(_PinturaBarra anterior) =>
      anterior.valor != valor ||
      anterior.maximo != maximo ||
      anterior.relleno != relleno ||
      anterior.radio != radio ||
      anterior.meta != meta ||
      anterior.colorMeta != colorMeta ||
      !_iguales(anterior.marcas, marcas);

  static bool _iguales(List<double> a, List<double> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
