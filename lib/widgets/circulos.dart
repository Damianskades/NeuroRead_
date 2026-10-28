import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';

class CirculoNumero extends StatelessWidget {
  const CirculoNumero(this.texto, {super.key, this.fondo = Colores.dorado});

  final String texto;
  final Color fondo;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 30,
    child: CustomPaint(
      painter: _PinturaCirculo(fondo, borde: 3),
      child: Center(
        child: Text(
          texto,
          style: Tipografia.display(14, color: Colores.textoOscuro),
        ),
      ),
    ),
  );
}

class CirculoInicial extends StatelessWidget {
  const CirculoInicial(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 64,
    child: CustomPaint(
      painter: const _PinturaCirculo(Colores.dorado, borde: 4, sombra: 3),
      child: Center(
        child: Text(
          texto,
          style: Tipografia.display(28, color: Colores.textoOscuro),
        ),
      ),
    ),
  );
}

class _PinturaCirculo extends CustomPainter {
  const _PinturaCirculo(this.fondo, {required this.borde, this.sombra = 0});

  final Color fondo;
  final double borde;
  final double sombra;

  @override
  void paint(Canvas canvas, Size size) {
    final centro = size.center(Offset.zero);
    final radio = size.width / 2;
    if (sombra > 0) {
      canvas.drawCircle(
        centro.translate(sombra, sombra),
        radio,
        Paint()..color = Colores.borde,
      );
    }
    canvas.drawCircle(centro, radio, Paint()..color = fondo);
    canvas.drawCircle(
      centro,
      radio,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borde
        ..color = Colores.borde,
    );
  }

  @override
  bool shouldRepaint(_PinturaCirculo anterior) =>
      anterior.fondo != fondo ||
      anterior.borde != borde ||
      anterior.sombra != sombra;
}
