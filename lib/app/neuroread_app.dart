import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../estado/estado_evaluacion.dart';
import '../estado/estado_usuario.dart';
import '../pantallas/acceso/pantalla_carga.dart';
import '../tema/medidas.dart';
import '../tema/tema_app.dart';
import 'escala_texto.dart';
import 'idioma.dart';

class NeuroReadApp extends StatelessWidget {
  const NeuroReadApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => EstadoUsuario()),
      Provider(create: (_) => EstadoEvaluacion()),
    ],
    child: MaterialApp(
      title: 'NeuroRead',
      debugShowCheckedModeBanner: false,
      theme: temaApp(),
      locale: Idioma.locale,
      supportedLocales: Idioma.soportados,
      localizationsDelegates: Idioma.delegados,
      builder: (context, child) => EscalaTexto(child: child!),
      home: const _Raiz(),
    ),
  );
}

class _Raiz extends StatefulWidget {
  const _Raiz();

  @override
  State<_Raiz> createState() => _RaizState();
}

class _RaizState extends State<_Raiz> {
  bool _cargaTerminada = false;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: Medidas.fundidoPantallas,
    child: _cargaTerminada
        ? const Scaffold(key: ValueKey('vacia'))
        : PantallaCarga(
            key: const ValueKey('carga'),
            alTerminar: () => setState(() => _cargaTerminada = true),
          ),
  );
}
