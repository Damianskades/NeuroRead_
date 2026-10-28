import 'package:flutter/material.dart';

import '../tema/tema_app.dart';
import 'escala_texto.dart';
import 'idioma.dart';

class NeuroReadApp extends StatelessWidget {
  const NeuroReadApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NeuroRead',
    debugShowCheckedModeBanner: false,
    theme: temaApp(),
    locale: Idioma.locale,
    supportedLocales: Idioma.soportados,
    localizationsDelegates: Idioma.delegados,
    builder: (context, child) => EscalaTexto(child: child!),
    home: const Scaffold(),
  );
}
