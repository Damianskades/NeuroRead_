import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pintura_neo.dart';
import 'presionable.dart';

const _textoApagado = Color(0x4DFFFFFF);

class NeoButton extends StatelessWidget {
  const NeoButton(
    this.texto, {
    super.key,
    required this.onPressed,
    this.superficie = Colores.dorado,
    this.colorTexto = Colores.textoOscuro,
    this.tamano = 15,
    this.alto,
    this.ancho,
    this.radio = 14,
    this.sombra = 5,
    this.borde = 2,
    this.colorBorde = Colores.borde,
    this.habilitado = true,
  });

  final String texto;
  final VoidCallback? onPressed;
  final Color superficie;
  final Color colorTexto;
  final double tamano;
  final double? alto;
  final double? ancho;
  final double radio;
  final double sombra;
  final double borde;
  final Color colorBorde;
  final bool habilitado;

  @override
  Widget build(BuildContext context) => Presionable(
    onTap: onPressed,
    habilitado: habilitado,
    builder: (context, presionado) => SizedBox(
      width: ancho,
      height: alto,
      child: CustomPaint(
        painter: PinturaNeo(
          superficie: superficie,
          radio: radio,
          sombra: sombra,
          borde: borde,
          colorBorde: colorBorde,
          desplazamiento: presionado && sombra > 0 ? 3 : 0,
        ),
        child: Center(
          child: Text(
            texto,
            textAlign: TextAlign.center,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: Tipografia.display(
              tamano,
              color: habilitado ? colorTexto : _textoApagado,
            ),
          ),
        ),
      ),
    ),
  );
}
