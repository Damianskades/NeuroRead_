import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/actividades.dart';
import '../../contenido/libros.dart';
import '../../contenido/niveles.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/fechas.dart';
import '../../logica/puntajes.dart';
import '../../logica/ruta.dart';
import '../../tema/colores.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/textos.dart';

class PestanaInicio extends StatelessWidget {
  const PestanaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<EstadoUsuario>();
    final usuario = estado.usuario;
    if (usuario == null) {
      return const SizedBox.expand();
    }
    final ultima = estado.ultimaSesion;
    final puntaje = ultima?.puntajeGlobal ?? 0;
    final nivel = ultima != null
        ? nivelDe(puntaje)
        : (porClave(usuario.nivel) ?? nivelDe(0));
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [
          _Encabezado(nombre: usuario.nombre, racha: estado.estadisticas.racha),
          _TarjetaNivel(nivel: nivel, puntaje: puntaje, ultima: ultima),
          _TarjetaObjetivo(ultima: ultima),
          _TarjetaContinuar(estado: estado),
          _TarjetaClasificatoria(
            faltan: actividadesFaltantes(
              estado.contarActividadesDesde(nivel.clave, ultima?.fecha),
            ),
          ),
        ],
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.nombre, required this.racha});

  final String nombre;
  final int racha;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 12,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 2,
          children: [
            Texto(
              fechaLarga(DateTime.now()),
              color: Colores.textoSec,
              negrita: true,
            ),
            TextoDisplay('Hola, $nombre', tamano: 26),
          ],
        ),
      ),
      NeoCard(
        superficie: Colores.tarjetaAlt,
        radio: 12,
        sombra: 3,
        ancho: 104,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            const NeoIcon.cuadrado(
              'llama',
              lado: 22,
              marco: false,
              colorGlifo: Colores.naranja,
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 22),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Texto(plural(racha, 'día', 'días'), negrita: true),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _TarjetaNivel extends StatelessWidget {
  const _TarjetaNivel({
    required this.nivel,
    required this.puntaje,
    required this.ultima,
  });

  final Nivel nivel;
  final int puntaje;
  final SesionResumen? ultima;

  @override
  Widget build(BuildContext context) {
    final siguiente = siguienteNivel(nivel.clave);
    final faltan = puntosParaSiguiente(puntaje);
    final navegacion = context.read<Navegacion>();
    return NeoCard(
      radio: 18,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              NeoBadge(
                nivel.nombre,
                superficie: nivel.color,
                ancho: 128,
                alto: 24,
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 24),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Texto(
                      'Tu nivel actual',
                      color: Colores.textoSec,
                      negrita: true,
                      alineacion: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 68),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextoDisplay(
                '',
                tamano: 52,
                color: nivel.color,
                span: TextSpan(
                  text: '$puntaje',
                  children: const [
                    TextSpan(
                      text: '%',
                      style: TextStyle(fontSize: 18, color: Colores.textoSec),
                    ),
                  ],
                ),
              ),
            ),
          ),
          NeoBar(
            valor: puntaje.toDouble(),
            relleno: nivel.color,
            marcas: [
              for (final n in niveles)
                if (n.minimo > 0) n.minimo.toDouble(),
            ],
            meta: siguiente?.minimo.toDouble(),
            colorMeta: siguiente?.color ?? Colores.dorado,
          ),
          Texto(
            '',
            negrita: true,
            span: siguiente == null
                ? const TextSpan(text: 'Alcanzaste el nivel más alto')
                : TextSpan(
                    children: [
                      const TextSpan(text: 'Te faltan '),
                      TextSpan(text: plural(faltan, 'punto', 'puntos')),
                      TextSpan(
                        text:
                            ' para llegar a\n${siguiente.nombre} (${siguiente.minimo}%)',
                      ),
                    ],
                  ),
          ),
          if (ultima != null)
            Enlace(
              'VER MI NEUROSCORE',
              color: nivel.color,
              alineacion: TextAlign.left,
              onTap: () => navegacion.abrirNeuroscore(
                ultima!.id,
                origen: Pestanas.inicio,
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _TarjetaObjetivo extends StatelessWidget {
  const _TarjetaObjetivo({required this.ultima});

  final SesionResumen? ultima;

  @override
  Widget build(BuildContext context) {
    final sesion = ultima;
    final habilidad =
        habilidades[habilidadMasBaja(
          sesion == null
              ? null
              : {
                  'literal': sesion.literal,
                  'inferencial': sesion.inferencial,
                  'critica': sesion.critica,
                },
        )]!;
    return NeoCard(
      radio: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          const NeoIcon.cuadrado('bombilla', lado: 46, colorChip: Colores.azul),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                const Etiqueta('OBJETIVO DE HOY'),
                TextoDisplay(habilidad.nombre, contorno: false),
                Texto(habilidad.descripcion, negrita: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaContinuar extends StatelessWidget {
  const _TarjetaContinuar({required this.estado});

  final EstadoUsuario estado;

  @override
  Widget build(BuildContext context) {
    final enCurso = estado.actividadEnCursoReciente;
    final actividad = actividadPorId(enCurso?.actividadId);
    final libro = actividad == null ? null : libroPorId(actividad.libroId);
    final navegacion = context.read<Navegacion>();
    final hayLibro = actividad != null && libro != null;
    final pasos = actividad?.pasos.length ?? 1;
    return NeoCard(
      radio: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          const Etiqueta('CONTINÚA DONDE TE QUEDASTE'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 14,
            children: [
              NeoCard(
                superficie: hayLibro ? libro.color : Colores.dorado,
                radio: 8,
                sombra: 3,
                ancho: 52,
                alto: 68,
                child: Center(
                  child: NeoIcon.cuadrado(
                    hayLibro ? 'libro' : 'ruta',
                    lado: 34,
                    marco: false,
                    colorGlifo: Colores.textoOscuro,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 4,
                  children: [
                    TextoDisplay(
                      hayLibro ? libro.titulo : 'Empieza tu ruta',
                      contorno: false,
                    ),
                    Texto(
                      hayLibro
                          ? 'Capítulo ${actividad.capituloRequerido}, actividad '
                                '${actividad.orden} de '
                                '${actividadesDeLibroNivel(actividad.libroId, actividad.nivel).length}'
                          : 'Elige un libro y completa actividades para avanzar.',
                      color: Colores.textoSec,
                      negrita: true,
                    ),
                    Opacity(
                      opacity: hayLibro ? 1 : 0,
                      child: NeoBar(
                        valor: hayLibro
                            ? (enCurso!.paso.clamp(0, pasos)).toDouble()
                            : 0,
                        maximo: pasos.toDouble(),
                        relleno: hayLibro ? libro.color : Colores.dorado,
                        radio: 5,
                        alto: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ],
          ),
          NeoButton(
            hayLibro ? 'CONTINUAR' : 'EMPEZAR',
            superficie: Colores.verde,
            alto: 52,
            onPressed: () => hayLibro
                ? navegacion.abrirActividad(
                    actividad.id,
                    origen: Pestanas.inicio,
                  )
                : navegacion.irAPestana(Pestanas.ruta),
          ),
        ],
      ),
    );
  }
}

class _TarjetaClasificatoria extends StatelessWidget {
  const _TarjetaClasificatoria({required this.faltan});

  final int faltan;

  @override
  Widget build(BuildContext context) => NeoCard(
    superficie: Colores.tarjetaAlt,
    radio: 18,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    onTap: () => context.read<Navegacion>().irAPestana(Pestanas.evaluacion),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        NeoIcon.cuadrado(
          faltan > 0 ? 'candado' : 'evaluacion',
          lado: 40,
          colorChip: Colores.fondo,
          colorGlifo: faltan > 0 ? Colores.violeta : Colores.dorado,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              const TextoDisplay('Evaluación clasificatoria', contorno: false),
              Texto(
                faltan > 0
                    ? 'Completa ${plural(faltan, 'actividad', 'actividades')} '
                          'más para desbloquearla'
                    : 'Ya puedes rendir tu evaluación',
                negrita: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
