import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../estado/estado_evaluacion.dart';
import '../estado/estado_usuario.dart';
import '../estado/navegacion.dart';
import '../pantallas/acceso/pantalla_acceso.dart';
import '../pantallas/acceso/pantalla_carga.dart';
import '../pantallas/acceso/pantalla_registro.dart';
import '../pantallas/pantalla_provisional.dart';
import '../servicios/recarga.dart';
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
      ChangeNotifierProvider(
        create: (_) => Navegacion(
          inicial: consumirInicioSinCarga() ? Pantalla.acceso : Pantalla.carga,
        ),
      ),
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

  void _salirDeLaCarga(Navegacion navegacion, bool conectado) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navegacion.actual == Pantalla.carga) {
        navegacion.irA(conectado ? Pantalla.provisional : Pantalla.acceso);
      }
    });
  }

  Widget _pantalla(Pantalla pantalla) => switch (pantalla) {
    Pantalla.carga => PantallaCarga(
      alTerminar: () => setState(() => _cargaTerminada = true),
    ),
    Pantalla.acceso => const PantallaAcceso(),
    Pantalla.registro => const PantallaRegistro(),
    Pantalla.provisional => const PantallaProvisional(),
  };

  @override
  Widget build(BuildContext context) {
    final navegacion = context.watch<Navegacion>();
    final (revisada, conectado) = context.select<EstadoUsuario, (bool, bool)>(
      (estado) => (estado.cuentaRevisada, estado.conectado),
    );
    if (navegacion.actual == Pantalla.carga && _cargaTerminada && revisada) {
      _salirDeLaCarga(navegacion, conectado);
    }
    return AnimatedSwitcher(
      duration: Medidas.fundidoPantallas,
      child: KeyedSubtree(
        key: ValueKey(navegacion.actual),
        child: _pantalla(navegacion.actual),
      ),
    );
  }
}
