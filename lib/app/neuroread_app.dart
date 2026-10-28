import 'package:flutter/material.dart';

import '../tema/tema_app.dart';
import 'escala_texto.dart';

class NeuroReadApp extends StatelessWidget {
  const NeuroReadApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NeuroRead',
    debugShowCheckedModeBanner: false,
    theme: temaApp(),
    builder: (context, child) => EscalaTexto(child: child!),
    home: const Scaffold(),
  );
}
