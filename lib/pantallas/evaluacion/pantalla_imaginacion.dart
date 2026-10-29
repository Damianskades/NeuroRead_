import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/estado_evaluacion.dart';
import '../../estado/navegacion.dart';
import '../../logica/puntajes.dart';
import '../../logica/riqueza.dart';
import '../../logica/validacion.dart';
import '../../tema/colores.dart';
import '../../widgets/campos.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/teclado.dart';
import '../../widgets/textos.dart';
import 'marco_modulo.dart';
import 'pantalla_interpretacion.dart';

class PantallaImaginacion extends StatefulWidget {
  const PantallaImaginacion({super.key});

  @override
  State<PantallaImaginacion> createState() => _PantallaImaginacionState();
}

class _PantallaImaginacionState extends State<PantallaImaginacion> {
  final _campo = TextEditingController();
  String _aviso = '';

  @override
  void dispose() {
    _campo.dispose();
    super.dispose();
  }

  void _guardar() {
    final texto = _campo.text;
    final redaccion = analizarRedaccion(texto, minPalabras: minPalabrasModulo);
    if (!redaccion.valida) {
      setState(() => _aviso = redaccion.mensaje);
      return;
    }
    final riqueza = contarRiqueza(texto);
    context.read<EstadoEvaluacion>().datos!.imaginacion
      ..puntaje = puntajeImaginacion(redaccion.total, riqueza)
      ..palabras = redaccion.total
      ..riqueza = riqueza;
    context.read<Navegacion>().irA(Pantalla.concentracion);
  }

  @override
  Widget build(BuildContext context) {
    final palabras = contarPalabras(_campo.text);
    return MarcoModulo(
      children: [
        Expanded(
          child: ColumnaConCampo(
            arriba: [
              NeoCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 58),
                  child: Row(
                    spacing: 12,
                    children: [
                      const NeoIcon.cuadrado(
                        'spark',
                        lado: 48,
                        colorChip: Colores.turquesa,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 2,
                          children: [
                            const SizedBox(
                              height: 28,
                              child: Row(
                                spacing: 8,
                                children: [
                                  Expanded(
                                    child: TextoDisplay(
                                      'NeuroCreative',
                                      tamano: 20,
                                      color: Colores.turquesa,
                                      maxLineas: 1,
                                    ),
                                  ),
                                  NeoBadge('ESTRELLA', ancho: 74, alto: 28),
                                ],
                              ),
                            ),
                            const Texto(
                              'Módulo 4 de 6: imaginación y creatividad',
                              color: Colores.textoSec,
                              negrita: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const NeoCard(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Texto(
                  'Imagina un FINAL ALTERNATIVO para la historia que leíste. '
                  'Describe colores, sonidos, sensaciones e hipótesis: cuanto más '
                  'rico tu vocabulario, mayor tu puntaje.',
                  negrita: true,
                ),
              ),
            ],
            aviso: AvisoCampo(_aviso),
            contador: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(
                  flex: 62,
                  child: ContadorPalabras(
                    textoContador(palabras),
                    color: colorContador(palabras),
                  ),
                ),
                Expanded(
                  flex: 38,
                  child: ContadorPalabras(
                    'Riqueza: ${nivelRiqueza(contarRiqueza(_campo.text))}',
                    color: Colores.verde,
                    alineacion: TextAlign.right,
                  ),
                ),
              ],
            ),
            campo: CampoTextoFlexible(
              controlador: _campo,
              pista: 'Describe tu final alternativo aquí...',
              colorCursor: Colores.turquesa,
              alCambiar: (_) => setState(() {}),
            ),
            boton: NeoButton(
              'EVALUAR MI CREATIVIDAD',
              superficie: Colores.turquesa,
              tamano: 16,
              alto: 58,
              onPressed: _guardar,
            ),
          ),
        ),
      ],
    );
  }
}
