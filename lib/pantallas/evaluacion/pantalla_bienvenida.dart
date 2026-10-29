import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/estado_evaluacion.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../tema/colores.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_deco.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/textos.dart';

const _textos = {
  'inicial': (
    'Evaluación inicial',
    'Esta evaluación de dificultad moderada mide tu punto de partida. '
        'Al terminar conocerás tu nivel.',
  ),
  'clasificatoria': (
    'Evaluación clasificatoria',
    'Demuestra lo que avanzaste. Tu nivel se actualizará según tu '
        'nuevo puntaje.',
  ),
};

class PantallaBienvenida extends StatefulWidget {
  const PantallaBienvenida({super.key});

  @override
  State<PantallaBienvenida> createState() => _PantallaBienvenidaState();
}

class _PantallaBienvenidaState extends State<PantallaBienvenida> {
  @override
  void initState() {
    super.initState();
    context.read<EstadoEvaluacion>().nueva(
      evaluacionInicialHecha:
          context.read<EstadoUsuario>().usuario?.evaluacionInicial ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final evaluacion = context.read<EstadoEvaluacion>();
    final (titulo, intro) = _textos[evaluacion.tipo] ?? _textos['inicial']!;
    final lectura = evaluacion.textoActivo?.titulo ?? '';
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 46, 20, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              const IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextoDisplay(
                          '',
                          tamano: 25,
                          span: TextSpan(
                            children: [
                              TextSpan(text: 'NEURO'),
                              TextSpan(
                                text: 'READ',
                                style: TextStyle(color: Colores.verde),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    NeoDeco(semilla: 4, tinte: Colores.verde, ancho: 70),
                  ],
                ),
              ),
              NeoCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 4,
                  children: [
                    TextoDisplay(titulo, contorno: false),
                    Texto(intro, negrita: true),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 22),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Texto(
                          'Texto de hoy: $lectura',
                          color: Colores.dorado,
                          negrita: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const TituloSeccion('EVALUACIÓN: 6 MÓDULOS'),
              const _TarjetaModulo(
                'NeuroRead',
                'Velocidad lectora medida en palabras por minuto',
                'book',
                Colores.dorado,
              ),
              const _TarjetaModulo(
                'NeuroTest',
                'Comprensión literal, inferencial y crítica',
                'check',
                Colores.verde,
              ),
              const _TarjetaModulo(
                'NeuroInsight',
                'Interpretación: emoción e intención del autor',
                'eye',
                Colores.azul,
              ),
              const _TarjetaModulo(
                'NeuroCreative',
                'Imaginación, creatividad y visualización',
                'spark',
                Colores.turquesa,
                estrella: true,
              ),
              const _TarjetaModulo(
                'NeuroFocus',
                '4 niveles de reacción: llega al modo NeuroUltra',
                'bolt',
                Colores.naranja,
              ),
              const _TarjetaModulo(
                'NeuroMemory',
                'Retención: memoria inmediata y diferida',
                'brain',
                Colores.violeta,
              ),
              const TituloSeccion('PANELES INTELIGENTES: 3 ANÁLISIS'),
              const _TarjetaModulo(
                'NeuroScore',
                'Perfil lector con puntaje global y desglose',
                'gauge',
                Colores.marino,
              ),
              const _TarjetaModulo(
                'NeuroCoach',
                'Actividades de tu ruta según tus resultados',
                'target',
                Colores.marino,
              ),
              const _TarjetaModulo(
                'NeuroTrack',
                'Historial, logros y evolución en tu perfil',
                'chart',
                Colores.marino,
              ),
              const SizedBox(height: 10),
              NeoButton(
                'INICIAR EVALUACIÓN',
                superficie: Colores.dorado,
                tamano: 17,
                alto: 64,
                onPressed: () =>
                    context.read<Navegacion>().irA(Pantalla.velocidad),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaModulo extends StatelessWidget {
  const _TarjetaModulo(
    this.titulo,
    this.descripcion,
    this.icono,
    this.color, {
    this.estrella = false,
  });

  final String titulo;
  final String descripcion;
  final String icono;
  final Color color;
  final bool estrella;

  @override
  Widget build(BuildContext context) => NeoCard(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        NeoIcon.cuadrado(icono, lado: 46, colorChip: color),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 2,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextoDisplay(titulo, tamano: 14.5, color: color),
                      ),
                    ),
                  ),
                  if (estrella)
                    const NeoBadge('ESTRELLA', ancho: 74, alto: 24)
                  else
                    const SizedBox(width: 0, height: 24),
                ],
              ),
              Texto(descripcion, negrita: true),
            ],
          ),
        ),
      ],
    ),
  );
}
