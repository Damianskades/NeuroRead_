import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pintura_neo.dart';

class NeoBadge extends StatelessWidget {
  const NeoBadge(
    this.texto, {
    super.key,
    this.superficie = Colores.dorado,
    this.colorTexto = Colores.textoOscuro,
    this.tamano = 11,
    this.radio = 9,
    this.ancho,
    this.alto,
  });

  final String texto;
  final Color superficie;
  final Color colorTexto;
  final double tamano;
  final double radio;
  final double? ancho;
  final double? alto;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: ancho,
    height: alto,
    child: CustomPaint(
      painter: PinturaNeo(
        superficie: superficie,
        radio: radio,
        sombra: 2,
        borde: 1.5,
      ),
      child: Center(
        child: Text(
          texto,
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: Tipografia.display(tamano, color: colorTexto),
        ),
      ),
    ),
  );
}
