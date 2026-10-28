import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'colores.dart';

abstract final class Tipografia {
  static const escalaTexto = 1.15;
  static const escalaPorcentaje = 0.9;
  static const tamanoMinimoRegular = 14.0;
  static const alturaLinea = 1.23;

  static const _libre = 'Jost';
  static const _librePorcentaje = 'ComicNeue';

  static bool get _windows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  static String get familia => _windows ? 'Century Gothic' : _libre;

  static List<String>? get respaldo => _windows ? const [_libre] : null;

  static String get familiaPorcentaje =>
      _windows ? 'Comic Sans MS' : _librePorcentaje;

  static List<String>? get respaldoPorcentaje =>
      _windows ? const [_librePorcentaje] : null;

  static TextStyle _base(
    FontWeight peso,
    double tamano,
    Color color,
    double interlineado,
  ) => TextStyle(
    fontFamily: familia,
    fontFamilyFallback: respaldo,
    fontWeight: peso,
    fontSize: tamano,
    color: color,
    height: alturaLinea * interlineado,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle display(
    double tamano, {
    Color color = Colores.texto,
    double interlineado = 1,
  }) => _base(FontWeight.w700, tamano, color, interlineado);

  static TextStyle cuerpo(
    double tamano, {
    Color color = Colores.texto,
    double interlineado = 1,
  }) => _base(FontWeight.w400, tamano, color, interlineado);

  static TextStyle texto(
    double tamano, {
    Color color = Colores.texto,
    bool negrita = false,
    double interlineado = 1,
  }) => negrita || tamano < tamanoMinimoRegular
      ? display(tamano, color: color, interlineado: interlineado)
      : cuerpo(tamano, color: color, interlineado: interlineado);

  static TextStyle porcentaje(double? tamanoBase) => TextStyle(
    fontFamily: familiaPorcentaje,
    fontFamilyFallback: respaldoPorcentaje,
    fontWeight: FontWeight.w700,
    fontSize: tamanoBase == null ? null : tamanoBase * escalaPorcentaje,
  );
}
