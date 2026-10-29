import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/estado_evaluacion.dart';
import '../../estado/navegacion.dart';
import '../../logica/fechas.dart';
import '../../logica/puntajes.dart';
import '../../logica/validacion.dart';
import '../../tema/colores.dart';
import '../../widgets/campos.dart';
import '../../widgets/mod_header.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/teclado.dart';
import '../../widgets/textos.dart';
import 'marco_modulo.dart';

const minPalabrasModulo = 10;

String textoContador(int palabras) =>
    '${plural(palabras, 'palabra', 'palabras')} de $minPalabrasModulo mínimas';

Color colorContador(int palabras) =>
    palabras >= minPalabrasModulo ? Colores.verde : Colores.textoSec;

class PantallaInterpretacion extends StatefulWidget {
  const PantallaInterpretacion({super.key});

  @override
  State<PantallaInterpretacion> createState() => _PantallaInterpretacionState();
}

class _PantallaInterpretacionState extends State<PantallaInterpretacion> {
  final _campo = TextEditingController();
  final _palabras = <int>[];
  int _indice = 0;
  String _aviso = '';

  List<String> get _preguntas =>
      context.read<EstadoEvaluacion>().textoActivo?.interpretacion ?? const [];

  @override
  void dispose() {
    _campo.dispose();
    super.dispose();
  }

  void _siguiente() {
    final redaccion = analizarRedaccion(
      _campo.text,
      minPalabras: minPalabrasModulo,
    );
    if (!redaccion.valida) {
      setState(() => _aviso = redaccion.mensaje);
      return;
    }
    _palabras.add(redaccion.total);
    final preguntas = _preguntas;
    if (_indice + 1 >= preguntas.length) {
      final interpretacion = context
          .read<EstadoEvaluacion>()
          .datos!
          .interpretacion;
      interpretacion
        ..puntaje = puntajeInterpretacion(_palabras, preguntas.length)
        ..palabrasTotal = _palabras.fold(0, (suma, n) => suma + n);
      context.read<Navegacion>().irA(Pantalla.imaginacion);
      return;
    }
    setState(() {
      _indice += 1;
      _aviso = '';
      _campo.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = _preguntas;
    final total = preguntas.length;
    final actual = _indice.clamp(0, total - 1);
    final palabras = contarPalabras(_campo.text);
    return MarcoModulo(
      children: [
        Expanded(
          child: ColumnaConCampo(
            arriba: [
              const ModHeader(
                icono: 'eye',
                titulo: 'NeuroInsight',
                subtitulo: 'Módulo 3 de 6: interpretación profunda',
                colorChip: Colores.azul,
              ),
              SizedBox(
                height: 22,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Texto(
                    'Pregunta ${actual + 1} de $total',
                    color: Colores.textoSec,
                    negrita: true,
                  ),
                ),
              ),
              NeoBar(
                valor: _indice.toDouble(),
                maximo: total.toDouble(),
                relleno: Colores.azul,
              ),
              NeoCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Texto(preguntas[actual], tamano: 14, negrita: true),
              ),
              const NeoCard(
                superficie: Colores.tarjetaAlt,
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Texto(
                  'Guía: responde con tus propias palabras, menciona emociones, '
                  'intención del autor y ejemplos. Se detectan respuestas repetitivas.',
                  negrita: true,
                ),
              ),
            ],
            aviso: AvisoCampo(_aviso),
            contador: ContadorPalabras(
              textoContador(palabras),
              color: colorContador(palabras),
            ),
            campo: CampoTextoFlexible(
              controlador: _campo,
              pista: 'Escribe tu análisis aquí...',
              colorCursor: Colores.azul,
              alCambiar: (_) => setState(() {}),
            ),
            boton: NeoButton(
              'SIGUIENTE',
              superficie: Colores.azul,
              colorTexto: Colores.texto,
              tamano: 16,
              alto: 58,
              onPressed: _siguiente,
            ),
          ),
        ),
      ],
    );
  }
}
