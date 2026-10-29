import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/actividades.dart';
import '../../contenido/libros.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/estado_libros.dart';
import '../../tema/colores.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_boton_icono.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/textos.dart';
import 'portada_libro.dart';

class DetalleLibro extends StatelessWidget {
  const DetalleLibro({super.key, required this.libroId});

  final String? libroId;

  @override
  Widget build(BuildContext context) {
    final libro = libroPorId(libroId);
    if (libro == null) {
      return const SizedBox.expand();
    }
    final estado = context.watch<EstadoUsuario>();
    final navegacion = context.read<Navegacion>();
    final leidos = estado.capitulosLeidos(libro.id);
    final traductor = libro.traductor;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: NeoBotonIcono(
              texto: 'VOLVER',
              onTap: () => navegacion.irAPestana(Pestanas.libros),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              PortadaLibro(libro: libro, ancho: 108, alto: 150, icono: 44),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 6,
                  children: [
                    TextoDisplay(libro.titulo, tamano: 22),
                    Texto(
                      traductor == null
                          ? libro.autor
                          : '${libro.autor}. Traducción de $traductor',
                      color: Colores.textoSec,
                      negrita: true,
                    ),
                    Texto(
                      '${libro.tipo}. ${textoProgreso(libro, leidos)}',
                      color: Colores.textoSec,
                      negrita: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Etiqueta('CAPÍTULOS'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              for (final capitulo in libro.capitulos)
                _TarjetaCapitulo(
                  libro: libro,
                  capitulo: capitulo,
                  leido: leidos.contains(capitulo.numero),
                ),
            ],
          ),
          const Etiqueta('ACTIVIDADES DE TU NIVEL'),
          _Actividades(libro: libro, estado: estado),
        ],
      ),
    );
  }
}

class _Actividades extends StatelessWidget {
  const _Actividades({required this.libro, required this.estado});

  final Libro libro;
  final EstadoUsuario estado;

  @override
  Widget build(BuildContext context) {
    if (estado.usuario == null) {
      return const Texto(
        'Disponibles próximamente',
        color: Colores.textoSec,
        negrita: true,
      );
    }
    final (nivel, ultima) = estado.nivelActual;
    final completadas = estado.actividadesCompletadasDesde(ultima?.fecha);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        for (final actividad in actividadesDeLibroNivel(libro.id, nivel.clave))
          _TarjetaActividad(
            actividad: actividad,
            estado: estado.progresoDe(actividad.id) != null
                ? ('EN CURSO', Colores.dorado, Colores.textoOscuro)
                : completadas.contains(actividad.id)
                ? ('COMPLETADA', Colores.verde, Colores.textoOscuro)
                : ('PENDIENTE', Colores.tarjetaAlt, Colores.textoSec),
          ),
      ],
    );
  }
}

class _TarjetaActividad extends StatelessWidget {
  const _TarjetaActividad({required this.actividad, required this.estado});

  final Actividad actividad;
  final (String, Color, Color) estado;

  @override
  Widget build(BuildContext context) {
    final (texto, fondo, color) = estado;
    return NeoCard(
      radio: 16,
      sombra: 3,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: () => context.read<Navegacion>().abrirActividad(
        actividad.id,
        origen: 'libro',
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 2,
              children: [
                Texto(actividad.titulo, tamano: 13.5, negrita: true),
                Texto(
                  'Capítulo ${actividad.capituloRequerido}',
                  color: Colores.textoSec,
                  negrita: true,
                ),
              ],
            ),
          ),
          NeoBadge(
            texto,
            superficie: fondo,
            colorTexto: color,
            ancho: 92,
            alto: 22,
          ),
        ],
      ),
    );
  }
}

class _TarjetaCapitulo extends StatelessWidget {
  const _TarjetaCapitulo({
    required this.libro,
    required this.capitulo,
    required this.leido,
  });

  final Libro libro;
  final Capitulo capitulo;
  final bool leido;

  @override
  Widget build(BuildContext context) => NeoCard(
    radio: 16,
    sombra: 3,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    onTap: () => context.read<Navegacion>().abrirLector(
      libro.id,
      capitulo.numero,
      origen: 'detalle',
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        NeoCard(
          superficie: Colores.tarjetaAlt,
          radio: 10,
          sombra: 0,
          ancho: 40,
          alto: 40,
          child: Center(
            child: TextoDisplay(
              '${capitulo.numero}',
              tamano: 15,
              color: libro.color,
              contorno: false,
            ),
          ),
        ),
        Expanded(child: Texto(capitulo.titulo, negrita: true)),
        NeoBadge(
          leido ? 'LEÍDO' : 'PENDIENTE',
          superficie: leido ? Colores.verde : Colores.tarjetaAlt,
          colorTexto: leido ? Colores.textoOscuro : Colores.textoSec,
          ancho: 84,
          alto: 24,
        ),
      ],
    ),
  );
}
