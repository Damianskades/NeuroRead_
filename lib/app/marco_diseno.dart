import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/medidas.dart';

class MarcoDiseno extends StatelessWidget {
  const MarcoDiseno({super.key, required this.child});

  static const anchoMinimo = 600.0;

  final Widget child;

  static bool get _aplica =>
      kIsWeb || defaultTargetPlatform == TargetPlatform.windows;

  @override
  Widget build(BuildContext context) {
    final datos = MediaQuery.of(context);
    final tamano = datos.size;
    if (!_aplica || tamano.width < anchoMinimo) {
      return child;
    }
    final escala = math.min(
      tamano.width / Medidas.anchoDiseno,
      tamano.height / Medidas.altoDiseno,
    );
    return ColoredBox(
      color: Colores.borde,
      child: Center(
        child: SizedBox(
          width: Medidas.anchoDiseno * escala,
          height: Medidas.altoDiseno * escala,
          child: FittedBox(
            child: SizedBox(
              width: Medidas.anchoDiseno,
              height: Medidas.altoDiseno,
              child: ClipRect(
                child: MediaQuery(
                  data: datos.copyWith(
                    size: const Size(Medidas.anchoDiseno, Medidas.altoDiseno),
                    devicePixelRatio: datos.devicePixelRatio * escala,
                    padding: EdgeInsets.zero,
                    viewPadding: EdgeInsets.zero,
                    viewInsets: EdgeInsets.zero,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
