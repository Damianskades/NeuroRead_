import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/actividades.dart';
import '../../contenido/config.dart';
import '../../contenido/libros.dart';
import '../../contenido/niveles.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/ruta.dart';
import '../../modelos/progreso.dart';
import '../../tema/colores.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_chip.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/neo_tag.dart';
import '../../widgets/textos.dart';

const _filtros = {
  'todas': 'Todas',
  'pendientes': 'Pendientes',
  'completadas': 'Completadas',
};

class PestanaRuta extends StatefulWidget {
  const PestanaRuta({super.key});

  @override
  State<PestanaRuta> createState() => _PestanaRutaState();
}

class _PestanaRutaState extends State<PestanaRuta> {
  static const _claveFiltro = 'filtroRuta';

  late String _filtro =
      PageStorage.maybeOf(context)?.readState(context, identifier: _claveFiltro)
          as String? ??
      'todas';

  void _elegir(String filtro) {
    PageStorage.maybeOf(context)
        ?.writeState(context, filtro, identifier: _claveFiltro);
    setState(() => _filtro = filtro);
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<EstadoUsuario>();
    if (estado.usuario == null) {
      return const SizedBox.expand();
    }
    final (nivel, ultima) = estado.nivelActual;
    var filas = ordenarRuta(
      nivel: nivel.clave,
      enCursoRecientes: estado.enCursoRecientes,
      completadas: estado.actividadesCompletadasDesde(ultima?.fecha),
      porcentajes: {
        'literal': ultima?.literal,
        'inferencial': ultima?.inferencial,
        'critica': ultima?.critica,
      },
    );
    if (_filtro == 'pendientes') {
      filas = [
        for (final fila in filas)
          if (fila.$2 != EstadoActividad.completada) fila,
      ];
    } else if (_filtro == 'completadas') {
      filas = [
        for (final fila in filas)
          if (fila.$2 == EstadoActividad.completada) fila,
      ];
    }
    final hechas = math.min(
      estado.contarActividadesDesde(nivel.clave, ultima?.fecha),
      actividadesParaDesbloquear,
    );
    const meta = actividadesParaDesbloquear;
    return SingleChildScrollView(
      key: const PageStorageKey('ruta'),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              const TextoDisplay('Tu ruta', tamano: 26),
              Texto(
                'Actividades de nivel ${nivel.nombre} para subir tu puntaje. '
                'Empieza por las que trabajan tus habilidades más bajas.',
                negrita: true,
              ),
            ],
          ),
          NeoCard(
            radio: 18,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    const Expanded(
                      child: Etiqueta('PROGRESO HACIA LA EVALUACIÓN'),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextoDisplay(
                        '$hechas de $meta',
                        tamano: 15,
                        color: Colores.violeta,
                        contorno: false,
                        alineacion: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                NeoBar(
                  valor: hechas.toDouble(),
                  maximo: meta.toDouble(),
                  relleno: Colores.violeta,
                ),
                const Texto(
                  'Completa $meta actividades para desbloquear la evaluación '
                  'clasificatoria y pasar de nivel.',
                  negrita: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                for (final MapEntry(key: clave, value: texto)
                    in _filtros.entries)
                  Expanded(
                    child: NeoChip(
                      texto,
                      onTap: () => _elegir(clave),
                      superficie: clave == _filtro
                          ? Colores.dorado
                          : Colores.tarjetaAlt,
                      colorTexto: clave == _filtro
                          ? Colores.textoOscuro
                          : Colores.texto,
                      sombra: clave == _filtro ? 2 : 0,
                      alineacion: TextAlign.center,
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
          ),
          if (filas.isEmpty)
            const Texto('No hay actividades en esta lista.')
          else
            for (final (actividad, estadoActividad) in filas)
              _TarjetaActividad(
                actividad: actividad,
                estado: estadoActividad,
                progreso: estado.progresoDe(actividad.id),
              ),
        ],
      ),
    );
  }
}

class _TarjetaActividad extends StatelessWidget {
  const _TarjetaActividad({
    required this.actividad,
    required this.estado,
    required this.progreso,
  });

  final Actividad actividad;
  final EstadoActividad estado;
  final ActividadEnCurso? progreso;

  @override
  Widget build(BuildContext context) {
    final navegacion = context.read<Navegacion>();
    final libro = libroPorId(actividad.libroId)!;
    final habilidad = habilidades[actividad.habilidad]!;
    final enCurso = estado == EstadoActividad.enCurso;
    final (icono, chip) = switch (estado) {
      EstadoActividad.enCurso => ('play', Colores.dorado),
      EstadoActividad.pendiente => ('ruta', Colores.tarjetaAlt),
      EstadoActividad.completada => ('check', Colores.verde),
    };
    final (textoInsignia, fondo, color) = switch (estado) {
      EstadoActividad.enCurso => (
        'EN CURSO',
        Colores.dorado,
        Colores.textoOscuro,
      ),
      EstadoActividad.pendiente => (
        'PENDIENTE',
        Colores.tarjetaAlt,
        Colores.textoSec,
      ),
      EstadoActividad.completada => (
        'COMPLETADA',
        Colores.verde,
        Colores.textoOscuro,
      ),
    };
    void abrir() => navegacion.abrirActividad(actividad.id);
    final total = actividad.pasos.length;
    final hechos = math.min(progreso?.paso ?? 0, total);
    final tarjeta = NeoCard(
      radio: 16,
      borde: enCurso ? 3 : 2,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: abrir,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              NeoIcon.cuadrado(
                icono,
                lado: 36,
                radio: 10,
                colorChip: chip,
                colorGlifo: estado == EstadoActividad.pendiente
                    ? Colores.texto
                    : null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 3,
                  children: [
                    TextoDisplay(actividad.titulo, tamano: 15, contorno: false),
                    Texto(
                      '${libro.titulo}, capítulo ${actividad.capituloRequerido}',
                      color: Colores.textoSec,
                      negrita: true,
                    ),
                  ],
                ),
              ),
              NeoBadge(
                textoInsignia,
                superficie: fondo,
                colorTexto: color,
                ancho: 92,
                alto: 22,
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: NeoTag(habilidad.nombre, colorBorde: habilidad.color),
          ),
          if (enCurso) ...[
            Texto(
              'Paso ${math.min(hechos + 1, total)} de $total',
              color: Colores.textoSec,
              negrita: true,
            ),
            NeoBar(
              valor: hechos.toDouble(),
              maximo: total.toDouble(),
              relleno: Colores.dorado,
              radio: 5,
              alto: 10,
            ),
            NeoButton(
              'CONTINUAR',
              superficie: Colores.verde,
              tamano: 14,
              alto: 50,
              onPressed: abrir,
            ),
          ],
        ],
      ),
    );
    return estado == EstadoActividad.completada
        ? Opacity(opacity: 0.8, child: tarjeta)
        : tarjeta;
  }
}
