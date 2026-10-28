import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pintura_neo.dart';

class NeoTag extends StatelessWidget {
  const NeoTag(
    this.texto, {
    super.key,
    this.colorBorde = Colores.verde,
    this.tamano = 13,
    this.radio = 8,
  });

  final String texto;
  final Color colorBorde;
  final double tamano;
  final double radio;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 26,
    child: CustomPaint(
      painter: PinturaNeo(
        superficie: Colores.tarjeta,
        radio: radio,
        borde: 1.5,
        colorBorde: colorBorde,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          widthFactor: 1,
          child: Text(
            texto,
            softWrap: false,
            style: Tipografia.display(tamano, color: colorBorde),
          ),
        ),
      ),
    ),
  );
}
