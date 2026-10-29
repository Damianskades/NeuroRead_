import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/estado_evaluacion.dart';
import '../../estado/navegacion.dart';
import '../../logica/puntajes.dart';
import '../../logica/redondeo.dart';
import '../../tema/colores.dart';
import '../../widgets/mod_header.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/textos.dart';
import 'marco_modulo.dart';

const ppmMaximo = 800;

class PantallaVelocidad extends StatefulWidget {
  const PantallaVelocidad({super.key});

  @override
  State<PantallaVelocidad> createState() => _PantallaVelocidadState();
}

class _PantallaVelocidadState extends State<PantallaVelocidad> {
  final _cronometro = Stopwatch();
  Timer? _tic;
  Timer? _salida;
  bool _corriendo = false;
  String _reloj = '0.0 s';
  String _estado = 'Listo para leer';

  String get _texto =>
      context.read<EstadoEvaluacion>().textoActivo?.texto ?? '';

  @override
  void dispose() {
    _tic?.cancel();
    _salida?.cancel();
    super.dispose();
  }

  double get _segundos => _cronometro.elapsedMicroseconds / 1e6;

  void _preparar(String estado) {
    _tic?.cancel();
    _cronometro
      ..stop()
      ..reset();
    setState(() {
      _corriendo = false;
      _reloj = '0.0 s';
      _estado = estado;
    });
  }

  void _empezar() {
    _cronometro
      ..reset()
      ..start();
    _tic?.cancel();
    _tic = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => setState(() => _reloj = '${_segundos.toStringAsFixed(1)} s'),
    );
    setState(() {
      _corriendo = true;
      _estado = 'Leyendo...';
    });
  }

  void _terminar() {
    if (!_corriendo) {
      return;
    }
    final transcurrido = math.max(_segundos, 0.1);
    _tic?.cancel();
    _cronometro.stop();
    _corriendo = false;
    final ppm = calcularPpm(_texto, transcurrido);
    if (ppm > ppmMaximo) {
      _preparar(
        'Lectura demasiado rápida. Vuelve a intentarlo '
        'leyendo con atención.',
      );
      return;
    }
    final velocidad = context.read<EstadoEvaluacion>().datos!.velocidad
      ..ppm = ppm
      ..tiempoTotal = redondearA(transcurrido, 1);
    setState(() {
      _reloj = '${transcurrido.toStringAsFixed(1)} s';
      _estado = '${velocidad.ppm} PPM registradas';
    });
    final navegacion = context.read<Navegacion>();
    _salida = Timer(
      const Duration(milliseconds: 1400),
      () => navegacion.irA(Pantalla.comprension),
    );
  }

  @override
  Widget build(BuildContext context) {
    final texto = _texto;
    final terminado = _salida != null;
    return MarcoModulo(
      children: [
        const ModHeader(
          icono: 'book',
          titulo: 'NeuroRead',
          subtitulo: 'Módulo 1 de 6: velocidad lectora',
        ),
        NeoCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextoDisplay(
                              _reloj,
                              tamano: 22,
                              color: Colores.dorado,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                          child: Texto(
                            'Cronómetro',
                            color: Colores.textoSec,
                            negrita: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 32),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Texto(
                                '${contarPalabrasTexto(texto)} palabras',
                                tamano: 15,
                                negrita: true,
                                alineacion: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 16),
                          child: Texto(
                            _estado,
                            color: Colores.textoSec,
                            negrita: true,
                            alineacion: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const NeoCard(
          superficie: Colores.tarjetaAlt,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Texto(
            'Consejo: lee a tu ritmo natural, sin correr. La comprensión del '
            'texto se evalúa en el siguiente módulo.',
            negrita: true,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 280),
              child: NeoCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Texto(texto, tamano: 14, interlineado: 1.25),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 62,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 14,
            children: [
              Expanded(
                child: Opacity(
                  opacity: _corriendo || terminado ? 0.35 : 1,
                  child: NeoButton(
                    'EMPEZAR',
                    superficie: Colores.azul,
                    colorTexto: Colores.texto,
                    habilitado: !_corriendo && !terminado,
                    onPressed: _empezar,
                  ),
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: _corriendo || terminado ? 1 : 0.35,
                  child: NeoButton(
                    'TERMINÉ DE LEER',
                    superficie: Colores.verde,
                    habilitado: _corriendo || terminado,
                    onPressed: _terminar,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
