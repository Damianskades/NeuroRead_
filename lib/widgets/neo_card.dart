import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import 'pintura_neo.dart';

class NeoCard extends StatelessWidget {
  const NeoCard({
    super.key,
    required this.child,
    this.superficie = Colores.tarjeta,
    this.radio = 16,
    this.sombra = 4,
    this.borde = 2,
    this.padding = EdgeInsets.zero,
    this.ancho,
    this.alto,
    this.onTap,
  });

  final Widget child;
  final Color superficie;
  final double radio;
  final double sombra;
  final double borde;
  final EdgeInsetsGeometry padding;
  final double? ancho;
  final double? alto;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget tarjeta = CustomPaint(
      painter: PinturaNeo(
        superficie: superficie,
        radio: radio,
        sombra: sombra,
        borde: borde,
      ),
      child: Padding(padding: padding, child: child),
    );
    if (ancho != null || alto != null) {
      tarjeta = SizedBox(width: ancho, height: alto, child: tarjeta);
    }
    if (onTap != null) {
      tarjeta = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: tarjeta,
      );
    }
    return tarjeta;
  }
}
