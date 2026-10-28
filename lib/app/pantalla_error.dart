import 'dart:ui' show AppExitType;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tema/colores.dart';
import '../tema/tema_app.dart';
import '../tema/tipografia.dart';
import 'escala_texto.dart';
import 'idioma.dart';

class AppError extends StatelessWidget {
  const AppError({super.key, required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NeuroRead',
    debugShowCheckedModeBanner: false,
    theme: temaApp(),
    locale: Idioma.locale,
    supportedLocales: Idioma.soportados,
    localizationsDelegates: Idioma.delegados,
    builder: (context, child) => EscalaTexto(child: child!),
    home: PantallaError(texto: texto),
  );
}

class PantallaError extends StatefulWidget {
  const PantallaError({super.key, required this.texto});

  final String texto;

  @override
  State<PantallaError> createState() => _PantallaErrorState();
}

class _PantallaErrorState extends State<PantallaError> {
  String _boton = 'COPIAR ERROR';

  Future<void> _copiar() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.texto));
      setState(() => _boton = 'ERROR COPIADO');
    } catch (_) {
      setState(() => _boton = 'NO SE PUDO COPIAR');
    }
  }

  void _cerrar() {
    if (kIsWeb) {
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      SystemNavigator.pop();
    } else {
      ServicesBinding.instance.exitApplication(AppExitType.required);
    }
  }

  @override
  Widget build(BuildContext context) => CallbackShortcuts(
    bindings: {const SingleActivator(LogicalKeyboardKey.escape): _cerrar},
    child: Focus(
      autofocus: true,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'NeuroRead no pudo iniciar',
                  style: Tipografia.display(26),
                ),
                const SizedBox(height: 14),
                Text(
                  'Copia este texto para revisar el problema.',
                  style: Tipografia.cuerpo(14),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      widget.texto,
                      style: Tipografia.cuerpo(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: _copiar,
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    color: Colores.dorado,
                    child: Text(
                      _boton,
                      style: Tipografia.display(16, color: Colores.textoOscuro),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
