import 'package:flutter/painting.dart';

import 'colores.dart';

abstract final class Tipografia {
  static const escalaTexto = 1.15;
  static const escalaPorcentaje = 0.9;
  static const tamanoMinimoRegular = 14.0;
  static const alturaLinea = 1.23;

  static const familia = 'Jost';
  static const familiaPorcentaje = 'ComicNeue';

  static TextStyle _base(
    FontWeight peso,
    double tamano,
    Color color,
    double interlineado,
  ) => TextStyle(
    fontFamily: familia,
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
    fontWeight: FontWeight.w700,
    fontSize: tamanoBase == null ? null : tamanoBase * escalaPorcentaje,
  );
}
