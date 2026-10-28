import 'package:flutter/material.dart';

import 'colores.dart';
import 'tipografia.dart';

ThemeData temaApp() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colores.fondo,
  canvasColor: Colores.fondo,
  fontFamily: Tipografia.familia,
  colorScheme: const ColorScheme.dark(
    primary: Colores.dorado,
    onPrimary: Colores.textoOscuro,
    surface: Colores.fondo,
    onSurface: Colores.texto,
    error: Colores.rojo,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colores.dorado,
    selectionColor: Colores.dorado.withValues(alpha: 0.4),
    selectionHandleColor: Colores.dorado,
  ),
  splashFactory: NoSplash.splashFactory,
  highlightColor: Colores.transparente,
  hoverColor: Colores.transparente,
);
