import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/focus.dart';
import '../../estado/estado_evaluacion.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/focus.dart';
import '../../logica/redondeo.dart';
import '../../tema/colores.dart';
import '../../widgets/mod_header.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/textos.dart';

const aprobarFocus = 4;
const preparacionSegundos = 6;

String avisoTiempo(NivelFocus nivel) =>
    '${nivel.regla}  (tienes ${nivel.tiempo} s por palabra)';

String _titulo(String texto) => texto
    .split(' ')
    .map(
      (palabra) => palabra.isEmpty
          ? palabra
          : palabra[0].toUpperCase() + palabra.substring(1).toLowerCase(),
    )
    .join(' ');

class PantallaConcentracion extends StatefulWidget {
  const PantallaConcentracion({super.key});

  @override
  State<PantallaConcentracion> createState() => _PantallaConcentracionState();
}

class _PantallaConcentracionState extends State<PantallaConcentracion> {
  final _reloj = Stopwatch();
  late final AppLifecycleListener _ciclo;
  bool _activa = true;
  VoidCallback? _diferida;
  Timer? _pendiente;
  Timer? _ticTiempo;
  Timer? _ticPreparacion;

  Map<String, List<ItemFocus>> _elegidas = const {};
  List<ItemFocus> _items = const [];
  NivelFocus? _nivel;
  int _nivelIndice = 0;
  int _indice = 0;
  int _okNivel = 0;
  int _errNivel = 0;
  int _okTotal = 0;
  int _errTotal = 0;
  final _tiempos = <double>[];
  final _rapidez = <double>[];
  bool _midiendo = false;
  bool _ultraSuperado = false;
  String _nivelMax = 'FACIL';
  int? _siguienteNivel;

  String _palabra = '?';
  String _progreso = 'Palabra 1 de 6';
  double _barra = 0;
  double _barraTiempo = 0;
  bool _barraTiempoVisible = false;
  bool _botones = true;
  String _retro = '';
  Color _colorRetro = Colores.verde;

  bool _intermedio = false;
  String _interTitulo = '';
  String _interDetalle = '';
  Color _interColor = Colores.naranja;

  bool _preparando = false;
  NivelFocus? _nivelPreparado;
  DateTime _finPreparacion = DateTime.now();
  double _barraPreparacion = 0;
  String _cuenta = '$preparacionSegundos';

  @override
  void initState() {
    super.initState();
    _ciclo = AppLifecycleListener(onStateChange: _cambioDeEstado);
    _iniciar();
  }

  @override
  void dispose() {
    _ciclo.dispose();
    _pendiente?.cancel();
    _ticTiempo?.cancel();
    _ticPreparacion?.cancel();
    super.dispose();
  }

  Future<void> _iniciar() async {
    final usadas = await context.read<EstadoUsuario>().palabrasRecientes();
    if (!mounted) {
      return;
    }
    _elegidas = {
      for (final nivel in nivelesFocus)
        if (nivel.clave != 'ULTRA')
          nivel.clave: elegirItems(nivel.clave, usadas),
    };
    _programar(() => _cargarNivel(0), 100);
  }

  void _cambioDeEstado(AppLifecycleState estado) {
    _activa = estado == AppLifecycleState.resumed;
    if (!_activa) {
      _salio();
      return;
    }
    final diferida = _diferida;
    _diferida = null;
    diferida?.call();
  }

  void _ejecutar(VoidCallback accion) {
    if (!mounted) {
      return;
    }
    if (_activa) {
      accion();
    } else {
      _diferida = accion;
    }
  }

  void _programar(VoidCallback accion, int milisegundos) {
    _pendiente?.cancel();
    _pendiente = Timer(
      Duration(milliseconds: milisegundos),
      () => _ejecutar(accion),
    );
  }

  double get _segundos => _reloj.elapsedMicroseconds / 1e6;

  void _salio() {
    if (_midiendo) {
      _responder(null, salida: true);
    }
  }

  void _cargarNivel(int indice) {
    final nivel = nivelesFocus[indice];
    final datos = context.read<EstadoEvaluacion>().datos;
    setState(() {
      _nivelIndice = indice;
      _indice = 0;
      _okNivel = 0;
      _errNivel = 0;
      _nivel = nivel;
      _nivelMax = nivel.clave;
      _items = nivel.clave == 'ULTRA'
          ? construirUltra(datos?.textoId ?? 0)
          : List.of(_elegidas[nivel.clave] ?? const <ItemFocus>[]);
      _barra = 0;
      _barraTiempoVisible = true;
      _barraTiempo = 0;
    });
    _programar(_mostrar, 200);
  }

  void _mostrar() {
    if (_indice >= _items.length) {
      _finNivel();
      return;
    }
    _ticTiempo?.cancel();
    _reloj
      ..reset()
      ..start();
    setState(() {
      _palabra = _items[_indice].palabra;
      _progreso = 'Palabra ${_indice + 1} de ${_items.length}';
      _barra = _indice.toDouble();
      _retro = '';
      _botones = true;
      _midiendo = true;
      _barraTiempo = 100;
    });
    _ticTiempo = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final limite = _nivel!.tiempo;
      final restante = limite - _segundos;
      setState(() => _barraTiempo = math.max(0, restante / limite * 100));
      if (restante <= 0) {
        _responder(null);
      }
    });
  }

  void _responder(bool? esSi, {bool salida = false}) {
    if (!_midiendo) {
      return;
    }
    final t = _segundos;
    final limite = _nivel!.tiempo.toDouble();
    _midiendo = false;
    _reloj.stop();
    _ticTiempo?.cancel();
    _tiempos.add(math.min(t, limite));
    final item = _items[_indice];
    setState(() {
      _botones = false;
      if (salida) {
        _errNivel += 1;
        _errTotal += 1;
        _retro = 'Saliste de la evaluación';
        _colorRetro = Colores.rojo;
      } else if (esSi == null || t > limite) {
        _errNivel += 1;
        _errTotal += 1;
        _retro = '¡Tiempo agotado!';
        _colorRetro = Colores.rojo;
      } else if (esSi == item.ok) {
        _rapidez.add(math.max(0, 1 - t / limite));
        _okNivel += 1;
        _okTotal += 1;
        _retro = 'Correcto (${t.toStringAsFixed(2)}s)';
        _colorRetro = Colores.verde;
      } else {
        _rapidez.add(math.max(0, 1 - t / limite));
        _errNivel += 1;
        _errTotal += 1;
        _retro = 'Error (${t.toStringAsFixed(2)}s)';
        _colorRetro = Colores.rojo;
      }
      _indice += 1;
    });
    _programar(_mostrar, 900);
  }

  void _finNivel() {
    _ticTiempo?.cancel();
    final nivel = _nivel!;
    final paso = _okNivel >= aprobarFocus;
    final resultado =
        'Resultado del nivel: $_okNivel aciertos y $_errNivel errores de '
        '${_items.length}.';
    String titulo;
    String detalle;
    if (nivel.clave == 'FACIL' || nivel.clave == 'NORMAL') {
      _siguienteNivel = _nivelIndice + 1;
      final proximo = _titulo(nivelesFocus[_siguienteNivel!].nombre);
      titulo = paso ? '¡NIVEL SUPERADO!' : 'NIVEL COMPLETADO';
      detalle = '$resultado\nAhora sube la exigencia: pasas al $proximo.';
    } else if (nivel.clave == 'DIFICIL') {
      if (paso) {
        _siguienteNivel = _nivelIndice + 1;
        titulo = '¡NEUROULTRA DESBLOQUEADO!';
        detalle =
            '$resultado\nSuperaste el modo difícil. Se activa NeuroUltra: '
            'palabras de tu propia lectura contra reloj.';
      } else {
        _siguienteNivel = null;
        titulo = 'NIVEL DIFÍCIL COMPLETADO';
        detalle =
            '$resultado\nNecesitabas $aprobarFocus aciertos para NeuroUltra. '
            'Te quedas en Difícil y continúas a NeuroMemory.';
      }
    } else {
      _siguienteNivel = null;
      _ultraSuperado = paso;
      titulo = paso ? '¡NEUROULTRA SUPERADO!' : 'NEUROULTRA COMPLETADO';
      detalle = '$resultado\nFin de NeuroFocus. Continúa a NeuroMemory.';
    }
    setState(() {
      _barra = _items.length.toDouble();
      _botones = false;
      _interTitulo = titulo;
      _interDetalle = detalle;
      _interColor = nivel.color;
      _intermedio = true;
    });
  }

  void _continuar() {
    setState(() => _intermedio = false);
    final siguiente = _siguienteNivel;
    if (siguiente != null) {
      _iniciarPreparacion(siguiente);
    } else {
      _terminar();
    }
  }

  void _iniciarPreparacion(int indice) {
    _finPreparacion = DateTime.now().add(
      const Duration(seconds: preparacionSegundos),
    );
    setState(() {
      _nivelPreparado = nivelesFocus[indice];
      _barraPreparacion = 0;
      _cuenta = '$preparacionSegundos';
      _preparando = true;
    });
    _ticPreparacion?.cancel();
    _ticPreparacion = Timer.periodic(const Duration(milliseconds: 50), (tic) {
      final restante =
          _finPreparacion.difference(DateTime.now()).inMicroseconds / 1e6;
      setState(() {
        _barraPreparacion =
            (1 - math.max(restante, 0) / preparacionSegundos) * 100;
        _cuenta = restante > 0 ? '${restante.floor() + 1}' : '¡YA!';
      });
      if (restante <= 0) {
        tic.cancel();
        _ejecutar(() {
          setState(() => _preparando = false);
          _cargarNivel(indice);
        });
      }
    });
  }

  void _terminar() {
    final total = _okTotal + _errTotal;
    final promedio = _tiempos.isEmpty
        ? 0.0
        : _tiempos.reduce((a, b) => a + b) / _tiempos.length;
    final rapidez = _rapidez.isEmpty
        ? 0.0
        : _rapidez.reduce((a, b) => a + b) / _rapidez.length;
    context.read<EstadoUsuario>().guardarPalabrasUsadas([
      for (final MapEntry(key: clave, value: items) in _elegidas.entries)
        for (final item in items) (clave, item.palabra),
    ]);
    context.read<EstadoEvaluacion>().datos!.concentracion
      ..aciertos = _okTotal
      ..errores = _errTotal
      ..total = total
      ..tiempoPromedio = redondearA(promedio, 2)
      ..rapidez = redondearA(rapidez, 4)
      ..nivelMax = _nivelMax
      ..ultraSuperado = _ultraSuperado;
    context.read<Navegacion>().irA(Pantalla.retencion);
  }

  @override
  Widget build(BuildContext context) {
    final nivel = _nivel;
    final ancho = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 46, 20, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 11,
                children: [
                  const ModHeader(
                    icono: 'bolt',
                    titulo: 'NeuroFocus',
                    subtitulo: 'Módulo 5 de 6: reacción por niveles',
                    colorChip: Colores.naranja,
                  ),
                  SizedBox(
                    height: 26,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        NeoBadge(
                          nivel?.nombre ?? 'NIVEL FÁCIL',
                          superficie: nivel?.color ?? Colores.verde,
                          ancho: 120,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Texto(
                              _progreso,
                              color: Colores.textoSec,
                              negrita: true,
                              alineacion: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  NeoBar(
                    valor: _barra,
                    maximo: nivel == null ? 4 : _items.length.toDouble(),
                    relleno: nivel?.color ?? Colores.naranja,
                  ),
                  NeoCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    child: Texto(
                      nivel == null ? '' : avisoTiempo(nivel),
                      color: Colores.naranja,
                      negrita: true,
                      alineacion: TextAlign.center,
                    ),
                  ),
                  NeoCard(
                    alto: 150,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Center(
                            child: TextoDisplay(
                              _palabra,
                              tamano: 40,
                              alineacion: TextAlign.center,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: _barraTiempoVisible ? 1 : 0,
                          child: NeoBar(
                            valor: _barraTiempo,
                            relleno: Colores.rojo,
                            alto: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 14,
                      children: [
                        _Marcador('Aciertos: $_okTotal', Colores.verde),
                        _Marcador('Errores: $_errTotal', Colores.rojo),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 30,
                    child: OverflowBox(
                      maxHeight: double.infinity,
                      child: Texto(
                        _retro,
                        tamano: 15,
                        color: _colorRetro,
                        negrita: true,
                        alineacion: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 64,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 14,
                      children: [
                        Expanded(
                          child: NeoButton(
                            nivel?.si ?? 'SÍ',
                            superficie: Colores.verde,
                            habilitado: _botones && !_intermedio,
                            onPressed: () => _responder(true),
                          ),
                        ),
                        Expanded(
                          child: NeoButton(
                            nivel?.no ?? 'NO',
                            superficie: Colores.rojo,
                            colorTexto: Colores.texto,
                            habilitado: _botones && !_intermedio,
                            onPressed: () => _responder(false),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_intermedio)
            Align(
              alignment: const Alignment(0, -0.04),
              child: NeoCard(
                radio: 20,
                ancho: math.min(ancho - 44, 340),
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 10,
                  children: [
                    Center(
                      child: TextoDisplay(
                        _interTitulo,
                        tamano: 19,
                        color: _interColor,
                        alineacion: TextAlign.center,
                      ),
                    ),
                    Texto(
                      _interDetalle,
                      negrita: true,
                      alineacion: TextAlign.center,
                    ),
                    NeoButton(
                      'CONTINUAR',
                      superficie: _interColor,
                      alto: 54,
                      onPressed: _continuar,
                    ),
                  ],
                ),
              ),
            ),
          if (_preparando && _nivelPreparado != null)
            Positioned.fill(
              child: ColoredBox(
                color: Colores.velo,
                child: Align(
                  alignment: const Alignment(0, -0.04),
                  child: NeoCard(
                    radio: 20,
                    ancho: math.min(ancho - 44, 340),
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 10,
                      children: [
                        const SizedBox(
                          height: 20,
                          child: Center(
                            child: Texto(
                              'PREPÁRATE: SIGUIENTE NIVEL',
                              color: Colores.textoSec,
                              negrita: true,
                              alineacion: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 34,
                          child: Center(
                            child: TextoDisplay(
                              _nivelPreparado!.nombre,
                              tamano: 22,
                              color: _nivelPreparado!.color,
                              alineacion: TextAlign.center,
                            ),
                          ),
                        ),
                        Texto(
                          avisoTiempo(_nivelPreparado!),
                          negrita: true,
                          alineacion: TextAlign.center,
                        ),
                        SizedBox(
                          height: 52,
                          child: Center(
                            child: TextoDisplay(
                              _cuenta,
                              tamano: 38,
                              color: _nivelPreparado!.color,
                              alineacion: TextAlign.center,
                            ),
                          ),
                        ),
                        NeoBar(
                          valor: _barraPreparacion,
                          relleno: _nivelPreparado!.color,
                          alto: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Marcador extends StatelessWidget {
  const _Marcador(this.texto, this.color);

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: NeoCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Center(
        child: Texto(
          texto,
          color: color,
          negrita: true,
          alineacion: TextAlign.center,
        ),
      ),
    ),
  );
}
