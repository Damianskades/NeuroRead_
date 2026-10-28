import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'neo_icon.dart';
import 'pintura_neo.dart';
import 'presionable.dart';

class NeoBotonIcono extends StatelessWidget {
  const NeoBotonIcono({
    super.key,
    required this.texto,
    required this.onTap,
    this.icono = 'volver',
    this.superficie = Colores.tarjetaAlt,
    this.colorTexto = Colores.texto,
    this.radio = 12,
    this.ancho = 118,
    this.alto = 48,
  });

  final String texto;
  final VoidCallback? onTap;
  final String icono;
  final Color superficie;
  final Color colorTexto;
  final double radio;
  final double ancho;
  final double alto;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    widthFactor: 1,
    heightFactor: 1,
    child: Presionable(
      onTap: onTap,
      builder: (context, presionado) => SizedBox(
        width: ancho,
        height: alto,
        child: CustomPaint(
          painter: PinturaNeo(
            superficie: superficie,
            radio: radio,
            sombra: 3,
            borde: 2,
            desplazamiento: presionado ? 2 : 0,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 14, 6),
            child: Row(
              spacing: 6,
              children: [
                NeoIcon.cuadrado(
                  icono,
                  lado: 22,
                  marco: false,
                  colorGlifo: colorTexto,
                ),
                Expanded(
                  child: Text(
                    texto,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: Tipografia.display(13, color: colorTexto),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
