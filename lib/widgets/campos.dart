import 'package:flutter/material.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';

class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.controlador,
    this.pista = '',
    this.oculto = false,
    this.colorCursor = Colores.dorado,
    this.teclado = TextInputType.text,
    this.alEnviar,
    this.alCambiar,
    this.foco,
    this.soloLectura = false,
  }) : _largo = false;

  const CampoTexto.largo({
    super.key,
    required this.controlador,
    this.pista = '',
    this.colorCursor = Colores.dorado,
    this.alCambiar,
    this.foco,
    this.soloLectura = false,
  }) : _largo = true,
       oculto = false,
       teclado = TextInputType.multiline,
       alEnviar = null;

  final TextEditingController controlador;
  final String pista;
  final bool oculto;
  final Color colorCursor;
  final TextInputType teclado;
  final ValueChanged<String>? alEnviar;
  final ValueChanged<String>? alCambiar;
  final FocusNode? foco;
  final bool soloLectura;
  final bool _largo;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _largo ? 150 : 48,
    child: CustomPaint(
      foregroundPainter: const _BordeRecto(),
      child: TextField(
        controller: controlador,
        focusNode: foco,
        obscureText: oculto,
        obscuringCharacter: '*',
        readOnly: soloLectura,
        keyboardType: teclado,
        textInputAction: _largo ? TextInputAction.newline : null,
        maxLines: _largo ? null : 1,
        expands: _largo,
        textAlignVertical: _largo ? TextAlignVertical.top : null,
        autocorrect: false,
        enableSuggestions: false,
        cursorColor: colorCursor,
        onSubmitted: alEnviar,
        onChanged: alCambiar,
        style: Tipografia.cuerpo(14),
        decoration: InputDecoration(
          hintText: pista,
          hintStyle: Tipografia.cuerpo(14, color: Colores.textoSec),
          filled: true,
          fillColor: Colores.tarjetaAlt,
          border: InputBorder.none,
          isDense: true,
          contentPadding: _largo
              ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
              : const EdgeInsets.all(14),
        ),
      ),
    ),
  );
}

class CampoTextoFlexible extends StatelessWidget {
  const CampoTextoFlexible({
    super.key,
    required this.controlador,
    this.pista = '',
    this.colorCursor = Colores.dorado,
    this.alCambiar,
  });

  final TextEditingController controlador;
  final String pista;
  final Color colorCursor;
  final ValueChanged<String>? alCambiar;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF332920), Colores.tarjetaAlt],
      ),
      border: Border.all(
        color: const Color(0xFF110E0B),
        width: 1 / MediaQuery.devicePixelRatioOf(context),
      ),
    ),
    child: TextField(
      controller: controlador,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      autocorrect: false,
      enableSuggestions: false,
      cursorColor: colorCursor,
      onChanged: alCambiar,
      style: Tipografia.cuerpo(14),
      decoration: InputDecoration(
        hintText: pista,
        hintStyle: Tipografia.cuerpo(14, color: Colores.textoSec),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    ),
  );
}

class _BordeRecto extends CustomPainter {
  const _BordeRecto();

  @override
  void paint(Canvas canvas, Size size) => canvas.drawRect(
    Offset.zero & size,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colores.borde,
  );

  @override
  bool shouldRepaint(_BordeRecto anterior) => false;
}
