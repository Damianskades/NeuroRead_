import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../estado/estado_evaluacion.dart';
import '../estado/estado_usuario.dart';
import '../estado/navegacion.dart';
import '../pantallas/acceso/pantalla_acceso.dart';
import '../pantallas/acceso/pantalla_carga.dart';
import '../pantallas/acceso/pantalla_registro.dart';
import '../pantallas/evaluacion/pantalla_bienvenida.dart';
import '../pantallas/evaluacion/pantalla_comprension.dart';
import '../pantallas/evaluacion/pantalla_concentracion.dart';
import '../pantallas/evaluacion/pantalla_imaginacion.dart';
import '../pantallas/evaluacion/pantalla_interpretacion.dart';
import '../pantallas/evaluacion/pantalla_retencion.dart';
import '../pantallas/evaluacion/pantalla_velocidad.dart';
import '../pantallas/lectura/pantalla_actividad.dart';
import '../pantallas/lectura/pantalla_lector.dart';
import '../pantallas/principal/pantalla_principal.dart';
import '../pantallas/provisionales.dart';
import '../pantallas/resultados/pantalla_resultados.dart';
import '../servicios/recarga.dart';
import '../tema/medidas.dart';
import '../tema/tema_app.dart';
import 'atras.dart';
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

  void _salirDeLaCarga(Navegacion navegacion, EstadoUsuario estado) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navegacion.actual != Pantalla.carga) {
        return;
      }
      final usuario = estado.usuario;
      if (usuario == null) {
        navegacion.irA(Pantalla.acceso);
      } else {
        navegacion.entrar(evaluacionInicialHecha: usuario.evaluacionInicial);
      }
    });
  }

  Widget _pantalla(Navegacion navegacion) => switch (navegacion.actual) {
    Pantalla.carga => PantallaCarga(
      alTerminar: () => setState(() => _cargaTerminada = true),
    ),
    Pantalla.acceso => const PantallaAcceso(),
    Pantalla.registro => const PantallaRegistro(),
    Pantalla.principal => const PantallaPrincipal(),
    Pantalla.bienvenida => const PantallaBienvenida(),
    Pantalla.velocidad => const PantallaVelocidad(),
    Pantalla.comprension => const PantallaComprension(),
    Pantalla.interpretacion => const PantallaInterpretacion(),
    Pantalla.imaginacion => const PantallaImaginacion(),
    Pantalla.concentracion => const PantallaConcentracion(),
    Pantalla.retencion => const PantallaRetencion(),
    Pantalla.lector => const PantallaLector(),
    Pantalla.actividad => const PantallaActividad(),
    Pantalla.resultados => const PantallaResultados(),
    Pantalla.editarPerfil => PantallaProvisional(
      titulo: 'Editar perfil',
      fase: 'Editar perfil llega en la fase 12.',
      alVolver: () => navegacion.irAPestana(Pestanas.perfil),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final navegacion = context.watch<Navegacion>();
    final estado = context.read<EstadoUsuario>();
    final listo = context.select<EstadoUsuario, bool>(
      (e) => e.cuentaRevisada && (!e.conectado || e.perfilCargado),
    );
    if (navegacion.actual == Pantalla.carga && _cargaTerminada && listo) {
      _salirDeLaCarga(navegacion, estado);
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (hecho, _) {
        if (!hecho) {
          atras(context);
        }
      },
      child: AnimatedSwitcher(
        duration: Medidas.fundidoPantallas,
        child: KeyedSubtree(
          key: ValueKey(navegacion.actual),
          child: _pantalla(navegacion),
        ),
      ),
    );
  }
}
