import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import 'pintura_neo.dart';
import 'presionable.dart';
import 'textos.dart';

class NeoChip extends StatelessWidget {
  const NeoChip(
    this.texto, {
    super.key,
    required this.onTap,
    this.superficie = Colores.tarjetaAlt,
    this.colorTexto = Colores.texto,
    this.tamano = 13,
    this.negrita = true,
    this.alineacion = TextAlign.left,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.altoMinimo = 0,
    this.alto,
    this.radio = 14,
    this.sombra = 3,
    this.borde = 2,
    this.habilitado = true,
  });

  final String texto;
  final VoidCallback? onTap;
  final Color superficie;
  final Color colorTexto;
  final double tamano;
  final bool negrita;
  final TextAlign alineacion;
  final EdgeInsetsGeometry padding;
  final double altoMinimo;
  final double? alto;
  final double radio;
  final double sombra;
  final double borde;
  final bool habilitado;

  @override
  Widget build(BuildContext context) => Presionable(
    onTap: onTap,
    habilitado: habilitado,
    builder: (context, presionado) => SizedBox(
      height: alto,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: altoMinimo),
        child: CustomPaint(
          painter: PinturaNeo(
            superficie: superficie,
            radio: radio,
            sombra: sombra,
            borde: borde,
            desplazamiento: presionado ? 2 : 0,
          ),
          child: Padding(
            padding: padding,
            child: Align(
              alignment: alineacion == TextAlign.center
                  ? Alignment.center
                  : Alignment.centerLeft,
              widthFactor: 1,
              heightFactor: 1,
              child: Texto(
                texto,
                tamano: tamano,
                color: colorTexto,
                negrita: negrita,
                alineacion: alineacion,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

enum EstadoOpcion { normal, correcta, incorrecta }

class ChipOpcion extends StatelessWidget {
  const ChipOpcion({
    super.key,
    required this.indice,
    required this.texto,
    required this.onTap,
    this.estado = EstadoOpcion.normal,
    this.habilitado = true,
    this.tamano = 13.5,
  });

  final int indice;
  final String texto;
  final VoidCallback? onTap;
  final EstadoOpcion estado;
  final bool habilitado;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    final (superficie, color) = switch (estado) {
      EstadoOpcion.normal => (Colores.tarjetaAlt, Colores.texto),
      EstadoOpcion.correcta => (Colores.verde, Colores.textoOscuro),
      EstadoOpcion.incorrecta => (Colores.rojo, Colores.texto),
    };
    return NeoChip(
      '${String.fromCharCode(65 + indice)})  $texto',
      onTap: onTap,
      habilitado: habilitado,
      superficie: superficie,
      colorTexto: color,
      tamano: tamano,
      altoMinimo: 56,
    );
  }
}
