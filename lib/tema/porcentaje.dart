import 'package:flutter/painting.dart';

import 'tipografia.dart';

TextSpan conPorcentaje(
  TextSpan raiz, [
  TextStyle heredado = const TextStyle(),
]) {
  final efectivo = heredado.merge(raiz.style);
  final hijos = <InlineSpan>[
    if (raiz.text != null) ..._partir(raiz.text!, efectivo),
    for (final hijo in raiz.children ?? const <InlineSpan>[])
      hijo is TextSpan ? conPorcentaje(hijo, efectivo) : hijo,
  ];
  return TextSpan(
    style: raiz.style,
    children: hijos,
    recognizer: raiz.recognizer,
    semanticsLabel: raiz.semanticsLabel,
  );
}

TextSpan textoConPorcentaje(String texto, [TextStyle? estilo]) =>
    conPorcentaje(TextSpan(text: texto, style: estilo));

List<InlineSpan> _partir(String texto, TextStyle efectivo) {
  final partes = texto.split('%');
  return [
    for (var i = 0; i < partes.length; i++) ...[
      if (partes[i].isNotEmpty) TextSpan(text: partes[i]),
      if (i < partes.length - 1)
        TextSpan(text: '%', style: Tipografia.porcentaje(efectivo.fontSize)),
    ],
  ];
}
