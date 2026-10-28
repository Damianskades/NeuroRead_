import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../logos/animacion.dart';
import '../../logos/logos.dart';
import '../../logos/pintura_logo.dart';
import '../../tema/colores.dart';
import '../../tema/tipografia.dart';

const duracionCarga = 5.6;
const _pasarOpacidad = [(0.0, 0.0), (0.3, 1.0), (0.72, 1.0), (1.0, 0.0)];
const _pasarEscala = [
  (0.0, 0.2),
  (0.3, 1.05),
  (0.42, 1.0),
  (0.72, 1.0),
  (1.0, 0.2),
];
const _llegada = 3.96;
const _llegarOpacidad = [(0.0, 0.0), (0.36, 1.0)];
const _llegarEscala = [(0.0, 0.2), (0.36, 1.1), (0.6, 1.0)];
const _nombreInicio = 4.44;
const _nombreDuracion = 0.48;
const _nombreSubida = 10.0;

final List<(PinturaLogo Function(double), double)> _logosDePaso = [
  (LogoLibroNeuronal.new, 0.0),
  (LogoOjoLector.new, 1.0),
  (LogoSubrayado.new, 2.0),
  (LogoNota20.new, 3.0),
];

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key, required this.alTerminar});

  final VoidCallback alTerminar;

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga>
    with SingleTickerProviderStateMixin {
  late final Ticker _reloj;
  Duration _anterior = Duration.zero;
  double _t = 0;
  bool _terminado = false;

  @override
  void initState() {
    super.initState();
    _reloj = createTicker(_avanzar)..start();
  }

  @override
  void dispose() {
    _reloj.dispose();
    super.dispose();
  }

  void _avanzar(Duration transcurrido) {
    final paso = (transcurrido - _anterior).inMicroseconds / 1e6;
    _anterior = transcurrido;
    setState(() => _t += math.min(paso, maxPaso));
    if (_t >= duracionCarga) {
      _salir();
    }
  }

  void _saltar() {
    if (_terminado) {
      return;
    }
    setState(() => _t = duracionCarga);
    _salir();
  }

  void _salir() {
    if (_terminado) {
      return;
    }
    _terminado = true;
    _reloj.stop();
    widget.alTerminar();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _saltar(),
      child: VistaCarga(t: _t),
    ),
  );
}

class VistaCarga extends StatelessWidget {
  const VistaCarga({super.key, required this.t});

  final double t;

  Widget _logo(PinturaLogo pintura, double opacidad, double escala) {
    if (opacidad <= 0) {
      return const SizedBox.shrink();
    }
    return Opacity(
      opacity: opacidad.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: escala,
        child: CustomPaint(size: const Size.square(240), painter: pintura),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final capas = <Widget>[
      for (final (crear, inicio) in _logosDePaso)
        if (t - inicio >= 0 && t - inicio <= 1.0)
          _logo(
            crear(t),
            fotograma(_pasarOpacidad, t - inicio),
            fotograma(_pasarEscala, t - inicio),
          ),
      if (t - _llegada >= 0)
        _logo(
          LogoNConPuntos(t),
          fotograma(_llegarOpacidad, t - _llegada, salida),
          fotograma(_llegarEscala, t - _llegada, salida),
        ),
    ];
    final avance = salida(
      ((t - _nombreInicio) / _nombreDuracion).clamp(0.0, 1.0),
    );
    final desfase = _nombreSubida * (1 - avance);
    return Material(
      color: Colores.fondo,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: 240,
                    child: Stack(children: capas),
                  ),
                  const SizedBox(height: 26),
                  _TextoEspaciado(
                    partes: const [
                      ('NEURO', Colores.texto),
                      ('READ', Colores.verde),
                    ],
                    tamano: 36,
                    espacio: 1,
                    altoCaja: 36 * Tipografia.escalaTexto,
                    opacidad: avance,
                    desfase: desfase,
                  ),
                  const SizedBox(height: 6),
                  _TextoEspaciado(
                    partes: const [('LEE. PIENSA. AVANZA.', Colores.textoSec)],
                    tamano: 13,
                    espacio: 2,
                    opacidad: avance,
                    desfase: desfase,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 90,
              child: Center(
                child: CustomPaint(
                  size: const Size(180, 10),
                  painter: _BarraCarga(math.min(t / duracionCarga, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextoEspaciado extends StatelessWidget {
  const _TextoEspaciado({
    required this.partes,
    required this.tamano,
    required this.espacio,
    required this.opacidad,
    required this.desfase,
    this.altoCaja,
  });

  final List<(String, Color)> partes;
  final double tamano;
  final double espacio;
  final double opacidad;
  final double desfase;
  final double? altoCaja;

  @override
  Widget build(BuildContext context) {
    Widget texto = Text.rich(
      TextSpan(
        children: [
          for (final (cadena, color) in partes)
            TextSpan(
              text: cadena,
              style: Tipografia.display(
                tamano,
                color: color,
              ).copyWith(letterSpacing: espacio),
            ),
        ],
      ),
      textAlign: TextAlign.center,
      softWrap: false,
    );
    if (altoCaja != null) {
      texto = SizedBox(
        height: altoCaja,
        child: OverflowBox(
          minHeight: 0,
          maxHeight: double.infinity,
          child: texto,
        ),
      );
    }
    return Opacity(
      opacity: opacidad,
      child: Transform.translate(offset: Offset(0, desfase), child: texto),
    );
  }
}

class _BarraCarga extends CustomPainter {
  const _BarraCarga(this.progreso);

  final double progreso;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6)),
      Paint()..color = Colores.borde,
    );
    final interior = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, size.width - 4, size.height - 4),
      const Radius.circular(4),
    );
    canvas.drawRRect(interior, Paint()..color = Colores.tarjetaAlt);
    canvas.save();
    canvas.clipRRect(interior);
    canvas.drawRect(
      Rect.fromLTWH(
        2,
        2,
        (size.width - 4) * progreso.clamp(0.0, 1.0),
        size.height - 4,
      ),
      Paint()..color = Colores.dorado,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BarraCarga anterior) => anterior.progreso != progreso;
}
