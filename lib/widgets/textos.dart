import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/porcentaje.dart';
import '../tema/tipografia.dart';
import 'presionable.dart';

TextSpan _armar(String? texto, InlineSpan? span, TextStyle estilo) =>
    conPorcentaje(
      TextSpan(
        style: estilo,
        text: span == null ? texto : null,
        children: span == null ? null : [span],
      ),
    );

class Texto extends StatelessWidget {
  const Texto(
    this.texto, {
    super.key,
    this.span,
    this.tamano = 13,
    this.color = Colores.texto,
    this.negrita = false,
    this.alineacion = TextAlign.left,
    this.interlineado = 1,
  });

  final String texto;
  final InlineSpan? span;
  final double tamano;
  final Color color;
  final bool negrita;
  final TextAlign alineacion;
  final double interlineado;

  @override
  Widget build(BuildContext context) => Text.rich(
    _armar(
      texto,
      span,
      Tipografia.texto(
        tamano,
        color: color,
        negrita: negrita,
        interlineado: interlineado,
      ),
    ),
    textAlign: alineacion,
  );
}

class TextoDisplay extends StatelessWidget {
  const TextoDisplay(
    this.texto, {
    super.key,
    this.span,
    this.tamano = 16,
    this.color = Colores.texto,
    this.contorno = true,
    this.alineacion = TextAlign.left,
    this.maxLineas,
  });

  final String texto;
  final InlineSpan? span;
  final double tamano;
  final Color color;
  final bool contorno;
  final TextAlign alineacion;
  final int? maxLineas;

  @override
  Widget build(BuildContext context) {
    final relleno = _armar(
      texto,
      span,
      Tipografia.display(tamano, color: color),
    );
    final frente = Text.rich(
      relleno,
      textAlign: alineacion,
      maxLines: maxLineas,
      overflow: maxLineas == null ? null : TextOverflow.ellipsis,
    );
    if (!contorno) {
      return frente;
    }
    final trazo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 / MediaQuery.devicePixelRatioOf(context)
      ..strokeJoin = StrokeJoin.round
      ..color = Colores.borde;
    return Stack(
      children: [
        Text.rich(
          _soloTrazo(relleno, trazo) as TextSpan,
          textAlign: alineacion,
          maxLines: maxLineas,
          overflow: maxLineas == null ? null : TextOverflow.ellipsis,
        ),
        frente,
      ],
    );
  }
}

InlineSpan _soloTrazo(InlineSpan span, Paint trazo) {
  if (span is! TextSpan) {
    return span;
  }
  final estilo = span.style;
  return TextSpan(
    text: span.text,
    style: estilo == null
        ? null
        : TextStyle(
            fontFamily: estilo.fontFamily,
            fontWeight: estilo.fontWeight,
            fontSize: estilo.fontSize,
            height: estilo.height,
            leadingDistribution: estilo.leadingDistribution,
            letterSpacing: estilo.letterSpacing,
            foreground: trazo,
          ),
    children: span.children?.map((hijo) => _soloTrazo(hijo, trazo)).toList(),
  );
}

class Etiqueta extends StatelessWidget {
  const Etiqueta(this.texto, {super.key, this.color = Colores.textoSec});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      Texto(texto, tamano: 13, color: color, negrita: true);
}

class TituloSeccion extends StatelessWidget {
  const TituloSeccion(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Texto(texto, tamano: 13, color: Colores.textoSec, negrita: true),
  );
}

class Enlace extends StatelessWidget {
  const Enlace(
    this.texto, {
    super.key,
    required this.onTap,
    this.color = Colores.dorado,
    this.tamano = 13,
  });

  final String texto;
  final VoidCallback? onTap;
  final Color color;
  final double tamano;

  @override
  Widget build(BuildContext context) => Presionable(
    onTap: onTap,
    builder: (context, _) => SizedBox(
      height: 48,
      child: Center(
        child: Texto(
          texto,
          tamano: tamano,
          color: color,
          negrita: true,
          alineacion: TextAlign.center,
        ),
      ),
    ),
  );
}

class ErrorFormulario extends StatelessWidget {
  const ErrorFormulario(this.texto, {super.key, this.color = Colores.rojo});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 24),
    child: Center(
      child: Texto(
        texto,
        tamano: 13,
        color: color,
        negrita: true,
        alineacion: TextAlign.center,
      ),
    ),
  );
}

class AvisoCampo extends StatelessWidget {
  const AvisoCampo(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) => texto.isEmpty
      ? const SizedBox.shrink()
      : SizedBox(
          width: double.infinity,
          child: Texto(texto, tamano: 13, color: Colores.rojo, negrita: true),
        );
}

class ContadorPalabras extends StatelessWidget {
  const ContadorPalabras(
    this.texto, {
    super.key,
    this.color = Colores.textoSec,
    this.alineacion = TextAlign.left,
  });

  final String texto;
  final Color color;
  final TextAlign alineacion;

  @override
  Widget build(BuildContext context) => Texto(
    texto,
    tamano: 13,
    color: color,
    negrita: true,
    alineacion: alineacion,
  );
}
