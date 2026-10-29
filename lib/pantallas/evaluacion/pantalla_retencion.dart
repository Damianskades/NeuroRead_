import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/textos.dart';
import '../../estado/estado_evaluacion.dart';
import '../../estado/navegacion.dart';
import '../../tema/colores.dart';
import '../../widgets/mod_header.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/textos.dart';
import 'marco_modulo.dart';
import 'pantalla_comprension.dart';

const esperaMemoria = 30;

class PantallaRetencion extends StatefulWidget {
  const PantallaRetencion({super.key});

  @override
  State<PantallaRetencion> createState() => _PantallaRetencionState();
}

class _PantallaRetencionState extends State<PantallaRetencion> {
  late final AppLifecycleListener _ciclo;
  bool _activa = true;
  Timer? _cuenta;
  Timer? _siguiente;
  int _segundos = esperaMemoria;
  bool _esperando = true;
  int _indice = 0;
  int _correctas = 0;
  List<String> _opciones = const [];
  int _respuesta = 0;
  int? _elegida;
  String _retro = '';
  bool _retroBien = true;
  bool _terminado = false;

  List<PreguntaOpciones> get _preguntas =>
      context.read<EstadoEvaluacion>().textoActivo?.retencion ?? const [];

  @override
  void initState() {
    super.initState();
    _ciclo = AppLifecycleListener(
      onStateChange: (estado) => _activa = estado == AppLifecycleState.resumed,
    );
    _cuenta = Timer.periodic(const Duration(seconds: 1), (tic) {
      if (!_activa) {
        return;
      }
      setState(() => _segundos -= 1);
      if (_segundos <= 0) {
        tic.cancel();
        setState(() {
          _esperando = false;
          _mostrar();
        });
      }
    });
  }

  @override
  void dispose() {
    _ciclo.dispose();
    _cuenta?.cancel();
    _siguiente?.cancel();
    super.dispose();
  }

  void _mostrar() {
    final preguntas = _preguntas;
    if (_indice >= preguntas.length) {
      _fin();
      return;
    }
    final pregunta = preguntas[_indice];
    final (opciones, respuesta) = mezclarOpciones(
      pregunta.opciones,
      pregunta.respuesta,
    );
    _opciones = opciones;
    _respuesta = respuesta;
    _elegida = null;
    _retro = '';
  }

  void _responder(int indice) {
    if (_elegida != null) {
      return;
    }
    final bien = indice == _respuesta;
    if (bien) {
      _correctas += 1;
    }
    setState(() {
      _elegida = indice;
      _retroBien = bien;
      _retro = bien
          ? '¡Correcto!'
          : 'Incorrecto, la respuesta correcta está en verde';
      _indice += 1;
    });
    _siguiente = Timer(
      const Duration(milliseconds: 1400),
      () => setState(_mostrar),
    );
  }

  void _fin() {
    _terminado = true;
    context.read<EstadoEvaluacion>().datos!.retencion.correctas = _correctas;
    final navegacion = context.read<Navegacion>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => navegacion.irA(Pantalla.resultados),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = _preguntas;
    final total = preguntas.length;
    final actual = (_elegida == null ? _indice : _indice - 1).clamp(
      0,
      total - 1,
    );
    return MarcoModulo(
      children: [
        const ModHeader(
          icono: 'brain',
          titulo: 'NeuroMemory',
          subtitulo: 'Módulo 6 de 6: memoria diferida',
          colorChip: Colores.violeta,
        ),
        SizedBox(
          height: 22,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Texto(
              _esperando
                  ? 'Preparando test de memoria...'
                  : 'Pregunta ${actual + 1} de $total',
              color: Colores.textoSec,
              negrita: true,
            ),
          ),
        ),
        NeoBar(
          valor: _esperando ? 0 : (_terminado ? total : actual).toDouble(),
          maximo: _esperando ? 3 : total.toDouble(),
          relleno: Colores.violeta,
        ),
        if (_esperando)
          NeoCard(
            alto: 196,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                const Center(
                  child: NeoIcon.cuadrado(
                    'timer',
                    lado: 44,
                    colorChip: Colores.violeta,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextoDisplay(
                      '$_segundos',
                      tamano: 44,
                      color: Colores.violeta,
                      alineacion: TextAlign.center,
                    ),
                  ),
                ),
                const Texto(
                  'Sin releer el texto: en unos segundos comprobaremos cuánto '
                  'recuerdas de la lectura.',
                  negrita: true,
                  alineacion: TextAlign.center,
                ),
              ],
            ),
          )
        else
          const SizedBox.shrink(),
        if (_esperando)
          const Opacity(opacity: 0, child: SizedBox(height: 28))
        else
          NeoCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Texto(
              preguntas[actual].pregunta,
              tamano: 14.5,
              negrita: true,
            ),
          ),
        Expanded(
          child: _esperando
              ? const SizedBox.shrink()
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: PreguntaMezclada(
                    key: ValueKey(actual),
                    opciones: _opciones,
                    respuesta: _respuesta,
                    elegida: _elegida,
                    alResponder: _responder,
                  ),
                ),
        ),
        SizedBox(
          height: 30,
          child: OverflowBox(
            maxHeight: double.infinity,
            child: Texto(
              _retro,
              tamano: 15,
              color: _retroBien ? Colores.verde : Colores.rojo,
              negrita: true,
              alineacion: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
