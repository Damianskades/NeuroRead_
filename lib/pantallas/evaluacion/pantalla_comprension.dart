import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/niveles.dart';
import '../../contenido/textos.dart';
import '../../estado/estado_evaluacion.dart';
import '../../estado/navegacion.dart';
import '../../tema/colores.dart';
import '../../widgets/mod_header.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_chip.dart';
import '../../widgets/textos.dart';
import 'marco_modulo.dart';

const _colorTipo = {
  'Literal': Colores.verde,
  'Inferencial': Colores.azul,
  'Crítica': Colores.naranja,
  'Critica': Colores.naranja,
};

final _azar = math.Random();

(List<String>, int) mezclarOpciones(List<String> opciones, int respuesta) {
  final orden = List.generate(opciones.length, (i) => i)..shuffle(_azar);
  return ([for (final i in orden) opciones[i]], orden.indexOf(respuesta));
}

class PreguntaMezclada extends StatelessWidget {
  const PreguntaMezclada({
    super.key,
    required this.opciones,
    required this.respuesta,
    required this.elegida,
    required this.alResponder,
  });

  final List<String> opciones;
  final int respuesta;
  final int? elegida;
  final ValueChanged<int> alResponder;

  @override
  Widget build(BuildContext context) {
    final respondida = elegida != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        for (var i = 0; i < opciones.length; i++)
          ChipOpcion(
            indice: i,
            texto: opciones[i],
            habilitado: !respondida,
            estado: !respondida
                ? EstadoOpcion.normal
                : i == respuesta
                ? EstadoOpcion.correcta
                : i == elegida
                ? EstadoOpcion.incorrecta
                : EstadoOpcion.normal,
            onTap: () => alResponder(i),
          ),
      ],
    );
  }
}

class PantallaComprension extends StatefulWidget {
  const PantallaComprension({super.key});

  @override
  State<PantallaComprension> createState() => _PantallaComprensionState();
}

class _PantallaComprensionState extends State<PantallaComprension> {
  final _aciertos = {'literal': 0, 'inferencial': 0, 'critica': 0};
  int _indice = 0;
  int _correctas = 0;
  List<String> _opciones = const [];
  int _respuesta = 0;
  int? _elegida;
  String _retro = '';
  bool _retroBien = true;
  Timer? _espera;
  bool _terminado = false;

  List<PreguntaOpciones> get _preguntas =>
      context.read<EstadoEvaluacion>().textoActivo?.comprension ?? const [];

  @override
  void initState() {
    super.initState();
    _mostrar();
  }

  @override
  void dispose() {
    _espera?.cancel();
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
    final pregunta = _preguntas[_indice];
    final bien = indice == _respuesta;
    if (bien) {
      _correctas += 1;
      final clave = claveTipo(pregunta.tipo ?? '');
      _aciertos[clave] = _aciertos[clave]! + 1;
    }
    setState(() {
      _elegida = indice;
      _retroBien = bien;
      _retro = bien
          ? '¡Correcto!'
          : 'Incorrecto, observa la respuesta en verde';
      _indice += 1;
    });
    _espera = Timer(
      const Duration(milliseconds: 1400),
      () => setState(_mostrar),
    );
  }

  void _fin() {
    _terminado = true;
    context.read<EstadoEvaluacion>().datos!.registrarComprension(
      _correctas,
      _aciertos,
    );
    final navegacion = context.read<Navegacion>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => navegacion.irA(Pantalla.interpretacion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = _preguntas;
    final total = preguntas.length;
    final actual = math.min(
      _elegida == null ? _indice : _indice - 1,
      total - 1,
    );
    final pregunta = preguntas[math.max(actual, 0)];
    final tipo = pregunta.tipo ?? '';
    return MarcoModulo(
      children: [
        const ModHeader(
          icono: 'check',
          titulo: 'NeuroTest',
          subtitulo: 'Módulo 2 de 6: comprensión lectora',
          colorChip: Colores.verde,
        ),
        SizedBox(
          height: 24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Texto(
                    'Pregunta ${actual + 1} de $total',
                    color: Colores.textoSec,
                    negrita: true,
                  ),
                ),
              ),
              NeoBadge(
                tipo.toUpperCase(),
                superficie: _colorTipo[tipo] ?? Colores.verde,
                ancho: 96,
              ),
            ],
          ),
        ),
        NeoBar(
          valor: (_terminado ? total : actual).toDouble(),
          maximo: total.toDouble(),
          relleno: Colores.verde,
        ),
        NeoCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Texto(pregunta.pregunta, tamano: 14.5, negrita: true),
        ),
        Expanded(
          child: SingleChildScrollView(
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
          height: 32,
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
