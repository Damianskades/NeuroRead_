import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/config.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/fechas.dart';
import '../../logica/puntajes.dart';
import '../../tema/colores.dart';
import '../../widgets/boton_bloqueado.dart';
import '../../widgets/circulos.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/pintura_neo.dart';
import '../../widgets/textos.dart';

class PestanaEvaluacion extends StatelessWidget {
  const PestanaEvaluacion({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<EstadoUsuario>();
    if (estado.usuario == null) {
      return const SizedBox.expand();
    }
    final navegacion = context.read<Navegacion>();
    final (nivel, ultima) = estado.nivelActual;
    final hechas = math.min(
      estado.contarActividadesDesde(nivel.clave, ultima?.fecha),
      actividadesParaDesbloquear,
    );
    final faltan = actividadesParaDesbloquear - hechas;
    final bloqueada = faltan > 0;
    final sesiones = estado.sesiones.reversed.toList();
    return SingleChildScrollView(
      key: const PageStorageKey('evaluacion'),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              TextoDisplay('Evaluación', tamano: 26),
              Texto(
                'Tu clasificatoria para pasar de nivel.',
                color: Colores.textoSec,
                negrita: true,
              ),
            ],
          ),
          NeoCard(
            radio: 18,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 14,
                  children: [
                    NeoIcon.cuadrado(
                      bloqueada ? 'candado' : 'evaluacion',
                      lado: 52,
                      colorChip: bloqueada ? Colores.violeta : Colores.dorado,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 2,
                        children: [
                          const Etiqueta('EVALUACIÓN CLASIFICATORIA'),
                          TextoDisplay(
                            bloqueada ? 'Bloqueada' : 'Disponible',
                            tamano: 20,
                            contorno: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Texto(
                  bloqueada
                      ? 'Completa ${plural(faltan, 'actividad más', 'actividades más')} '
                            'de tu ruta para desbloquearla'
                      : 'Ya completaste las actividades de tu ruta. Puedes rendir '
                            'tu evaluación clasificatoria.',
                  negrita: true,
                ),
                if (bloqueada)
                  NeoBar(
                    valor: hechas.toDouble(),
                    maximo: actividadesParaDesbloquear.toDouble(),
                    relleno: Colores.violeta,
                  )
                else
                  const SizedBox.shrink(),
                if (bloqueada)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4,
                    children: [
                      const BotonBloqueado('EVALUACIÓN BLOQUEADA'),
                      Enlace(
                        'Ir a mi ruta',
                        onTap: () => navegacion.irAPestana(Pestanas.ruta),
                      ),
                    ],
                  )
                else
                  NeoButton(
                    'EMPEZAR EVALUACIÓN',
                    superficie: Colores.dorado,
                    tamano: 15,
                    alto: 54,
                    onPressed: () => navegacion.irA(Pantalla.bienvenida),
                  ),
              ],
            ),
          ),
          const Etiqueta('CÓMO FUNCIONA'),
          const NeoCard(
            radio: 18,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                _Paso(
                  '1',
                  Colores.dorado,
                  'Completa tu ruta',
                  'Termina $actividadesParaDesbloquear actividades de tu nivel.',
                ),
                _Paso(
                  '2',
                  Colores.naranja,
                  'Rinde la evaluación',
                  'Los seis módulos con un texto nuevo.',
                ),
                _Paso(
                  '3',
                  Colores.verde,
                  'Actualiza tu nivel',
                  'Tu nivel cambia según tu nuevo puntaje.',
                ),
              ],
            ),
          ),
          const Etiqueta('MÓDULOS DE LA EVALUACIÓN'),
          const Padding(
            padding: EdgeInsets.only(right: 3, bottom: 3),
            child: Column(
              spacing: 14,
              children: [
                _FilaModulos(
                  ('NeuroRead', 'Velocidad lectora', 'velocidad'),
                  ('NeuroTest', 'Comprensión', 'comprension'),
                ),
                _FilaModulos(
                  ('NeuroInsight', 'Interpretación', 'interpretacion'),
                  ('NeuroCreative', 'Creatividad', 'imaginacion'),
                ),
                _FilaModulos(
                  ('NeuroFocus', 'Concentración', 'concentracion'),
                  ('NeuroMemory', 'Memoria', 'retencion'),
                ),
              ],
            ),
          ),
          const Etiqueta('EVALUACIONES ANTERIORES'),
          NeoCard(
            radio: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: sesiones.isEmpty
                ? const Texto('Aún no tienes evaluaciones.')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4,
                    children: [
                      for (var i = 0; i < sesiones.length; i++) ...[
                        if (i > 0)
                          const SizedBox(
                            height: 2,
                            child: ColoredBox(color: Colores.tarjetaAlt),
                          ),
                        _FilaSesion(sesiones[i]),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Paso extends StatelessWidget {
  const _Paso(this.numero, this.fondo, this.titulo, this.texto);

  final String numero;
  final Color fondo;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 12,
    children: [
      CirculoNumero(numero, fondo: fondo),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 2,
          children: [
            Texto(titulo, tamano: 14, negrita: true),
            Texto(texto, negrita: true),
          ],
        ),
      ),
    ],
  );
}

class _FilaModulos extends StatelessWidget {
  const _FilaModulos(this.izquierdo, this.derecho);

  final (String, String, String) izquierdo;
  final (String, String, String) derecho;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        Expanded(child: _TarjetaModulo(izquierdo)),
        Expanded(child: _TarjetaModulo(derecho)),
      ],
    ),
  );
}

class _TarjetaModulo extends StatelessWidget {
  const _TarjetaModulo(this.modulo);

  final (String, String, String) modulo;

  @override
  Widget build(BuildContext context) {
    final (nombre, habilidad, clave) = modulo;
    return CustomPaint(
      painter: const PinturaNeo(
        superficie: Colores.tarjetaAlt,
        radio: 14,
        sombra: 3,
        borde: 2,
      ),
      foregroundPainter: _Franja(Colores.modulos[clave]!),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 2,
          children: [
            Texto(nombre, negrita: true),
            Texto(habilidad, color: Colores.textoSec, negrita: true),
          ],
        ),
      ),
    );
  }
}

class _Franja extends CustomPainter {
  const _Franja(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawRRect(
    RRect.fromRectAndCorners(
      Rect.fromLTWH(2, 2, size.width - 4, 6),
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
    ),
    Paint()..color = color,
  );

  @override
  bool shouldRepaint(_Franja anterior) => anterior.color != color;
}

class _FilaSesion extends StatelessWidget {
  const _FilaSesion(this.sesion);

  final SesionResumen sesion;

  @override
  Widget build(BuildContext context) {
    final nivel = nivelDeSesion(sesion);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.read<Navegacion>().abrirNeuroscore(
        sesion.id,
        origen: Pestanas.evaluacion,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 2,
                children: [
                  Texto(
                    sesion.tipo == 'inicial'
                        ? 'Evaluación inicial'
                        : 'Clasificatoria',
                    tamano: 14,
                    negrita: true,
                  ),
                  Texto(
                    fechaCorta(sesion.fecha),
                    color: Colores.textoSec,
                    negrita: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 62,
              child: TextoDisplay(
                '${sesion.puntajeGlobal}%',
                tamano: 20,
                color: nivel.color,
                contorno: false,
                alineacion: TextAlign.right,
              ),
            ),
            NeoBadge(
              nivel.nombre,
              superficie: nivel.color,
              ancho: 104,
              alto: 24,
            ),
            const NeoIcon.cuadrado(
              'volver',
              lado: 18,
              marco: false,
              girado: true,
              colorGlifo: Colores.textoSec,
            ),
          ],
        ),
      ),
    );
  }
}
