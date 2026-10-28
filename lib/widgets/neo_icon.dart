import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import 'pintura_neo.dart';

const _equivalencias = {
  'book': 'libro',
  'eye': 'ojo',
  'bolt': 'rayo',
  'brain': 'cerebro',
  'gauge': 'medidor',
  'timer': 'reloj',
  'spark': 'chispa',
  'trophy': 'trofeo',
  'target': 'objetivo',
  'chart': 'grafico',
  'lock': 'candado',
  'user': 'perfil',
  'home': 'inicio',
  'close': 'cerrar',
  'back': 'volver',
  'flame': 'llama',
  'bulb': 'bombilla',
};

class NeoIcon extends StatelessWidget {
  const NeoIcon(
    this.icono, {
    super.key,
    this.colorChip = Colores.dorado,
    this.colorGlifo,
    this.ancho = 46,
    this.alto = 46,
    this.radio = 12,
    this.marco = true,
    this.girado = false,
  });

  const NeoIcon.cuadrado(
    this.icono, {
    super.key,
    required double lado,
    this.colorChip = Colores.dorado,
    this.colorGlifo,
    this.radio = 12,
    this.marco = true,
    this.girado = false,
  }) : ancho = lado,
       alto = lado;

  final String icono;
  final Color colorChip;
  final Color? colorGlifo;
  final double ancho;
  final double alto;
  final double radio;
  final bool marco;
  final bool girado;

  @override
  Widget build(BuildContext context) {
    final nombre = _equivalencias[icono] ?? icono;
    final lado = (math.min(ancho, alto) * (marco ? 0.6 : 1.0)).roundToDouble();
    Widget glifo = Image.asset(
      'assets/iconos/$nombre.png',
      width: lado,
      height: lado,
      color: colorGlifo ?? Colores.oscuro(colorChip, 0.28),
      colorBlendMode: BlendMode.srcIn,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, pila) => SizedBox.square(dimension: lado),
    );
    if (girado) {
      glifo = RotatedBox(quarterTurns: 2, child: glifo);
    }
    return SizedBox(
      width: ancho,
      height: alto,
      child: CustomPaint(
        painter: marco
            ? PinturaNeo(
                superficie: colorChip,
                radio: radio,
                sombra: 3,
                borde: 2,
              )
            : null,
        child: Center(child: glifo),
      ),
    );
  }
}
