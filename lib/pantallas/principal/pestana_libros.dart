import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/actividades.dart';
import '../../contenido/libros.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/estado_libros.dart';
import '../../logica/fechas.dart';
import '../../tema/colores.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/textos.dart';
import 'portada_libro.dart';

class PestanaLibros extends StatelessWidget {
  const PestanaLibros({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<EstadoUsuario>();
    final estados = estadoLibros(
      leidosPorLibro: estado.leidosPorLibro,
      ultimaLectura: estado.ultimaLecturaPorLibro,
      libroDeActividadEnCurso: actividadPorId(
        estado.actividadEnCursoReciente?.actividadId,
      )?.libroId,
    );
    final orden = [
      ...libros.where((libro) => estados[libro.id]!.enCurso),
      ...libros.where((libro) => !estados[libro.id]!.enCurso),
    ];
    return SingleChildScrollView(
      key: const PageStorageKey('libros'),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              TextoDisplay('Libros', tamano: 26),
              Texto(
                'Lee para practicar y prepararte para tu próxima evaluación.',
                negrita: true,
              ),
            ],
          ),
          for (final libro in orden)
            _TarjetaLibro(
              libro: libro,
              estado: estados[libro.id]!,
              nivelUsuario: estado.usuario?.nivel,
            ),
        ],
      ),
    );
  }
}

class _TarjetaLibro extends StatelessWidget {
  const _TarjetaLibro({
    required this.libro,
    required this.estado,
    required this.nivelUsuario,
  });

  final Libro libro;
  final EstadoLibro estado;
  final String? nivelUsuario;

  Widget _insignia(String texto, Color fondo, Color color) => SizedBox(
    height: 24,
    child: Align(
      alignment: Alignment.centerLeft,
      child: NeoBadge(
        texto,
        superficie: fondo,
        colorTexto: color,
        ancho: 86,
        alto: 22,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final navegacion = context.read<Navegacion>();
    final leidos = estado.leidos;
    final total = libro.capitulos.length;
    final accion = leidos.isEmpty
        ? 'EMPEZAR'
        : leidos.length < total
        ? 'CONTINUAR'
        : 'LEER';
    final cantidad = actividadesDeLibroNivel(libro.id, nivelUsuario).length;
    return NeoCard(
      radio: 18,
      padding: const EdgeInsets.all(14),
      onTap: () => navegacion.abrirLibro(libro.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          PortadaLibro(libro: libro, ancho: 84, alto: 116, icono: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 5,
              children: [
                if (estado.enCurso)
                  _insignia('EN CURSO', Colores.dorado, Colores.textoOscuro)
                else if (leidos.isEmpty)
                  _insignia('NUEVO', Colores.tarjetaAlt, Colores.texto),
                TextoDisplay(libro.titulo, contorno: false),
                Texto(
                  '${libro.autor}. ${libro.tipo}',
                  color: Colores.textoSec,
                  negrita: true,
                ),
                Texto(
                  textoProgreso(libro, leidos),
                  color: Colores.textoSec,
                  negrita: true,
                ),
                NeoBar(
                  valor: leidos.length.toDouble(),
                  maximo: total.toDouble(),
                  relleno: libro.color,
                  radio: 5,
                  alto: 10,
                ),
                Texto(
                  plural(
                    cantidad,
                    'actividad de tu nivel',
                    'actividades de tu nivel',
                  ),
                  color: libro.color,
                  negrita: true,
                ),
                const SizedBox(height: 2),
                NeoButton(
                  accion,
                  superficie: libro.color,
                  tamano: 13,
                  alto: 40,
                  sombra: 3,
                  onPressed: () => accion == 'LEER'
                      ? navegacion.abrirLibro(libro.id)
                      : navegacion.abrirLector(
                          libro.id,
                          primerPendiente(libro, leidos),
                          origen: Pestanas.libros,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
