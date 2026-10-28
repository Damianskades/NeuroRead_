import 'package:flutter/painting.dart';

abstract final class Colores {
  static const fondo = Color(0xFF211A14);
  static const tarjeta = Color(0xFF2E251D);
  static const tarjetaAlt = Color(0xFF3A2F25);
  static const borde = Color(0xFF000000);

  static const texto = Color(0xFFF2EAD9);
  static const textoSec = Color(0xFFCFC4AC);
  static const textoOscuro = Color(0xFF412402);

  static const dorado = Color(0xFFF5C84B);
  static const verde = Color(0xFFA4CE4E);
  static const turquesa = Color(0xFF2DD4BF);
  static const azul = Color(0xFF4A90D9);
  static const naranja = Color(0xFFF7941D);
  static const marino = Color(0xFF1B4F8C);
  static const violeta = Color(0xFFB39DFF);
  static const rojo = Color(0xFFE85C4A);

  static const transparente = Color(0x00000000);
  static const velo = Color(0x99000000);

  static const modulos = <String, Color>{
    'velocidad': dorado,
    'comprension': verde,
    'interpretacion': azul,
    'imaginacion': turquesa,
    'concentracion': naranja,
    'retencion': violeta,
    'resultados': marino,
  };

  static const modulosCodigo = <String, Color>{
    'VEL': dorado,
    'COM': verde,
    'INT': azul,
    'IMA': turquesa,
    'CON': naranja,
    'RET': violeta,
  };

  static Color oscuro(Color color, [double factor = 0.35]) => Color.from(
    alpha: 1,
    red: color.r * factor,
    green: color.g * factor,
    blue: color.b * factor,
  );
}
