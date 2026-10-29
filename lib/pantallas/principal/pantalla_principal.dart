import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/navegacion.dart';
import '../../tema/medidas.dart';
import '../../widgets/neo_tab_bar.dart';
import '../provisionales.dart';
import 'detalle_libro.dart';
import 'pestana_inicio.dart';
import 'pestana_libros.dart';
import 'pestana_ruta.dart';

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  Widget _pestana(String nombre, String? libroId) => switch (nombre) {
    Pestanas.ruta => const PestanaRuta(),
    Pestanas.evaluacion => const PestanaProvisional(
      titulo: 'Evaluación',
      fase: 'La evaluación clasificatoria llega en la fase 11.',
    ),
    Pestanas.libros => const PestanaLibros(),
    Pestanas.libroDetalle => DetalleLibro(libroId: libroId),
    Pestanas.perfil => const PestanaProvisional(
      titulo: 'Perfil',
      fase: 'El perfil llega en la fase 12.',
      conCerrarSesion: true,
    ),
    _ => const PestanaInicio(),
  };

  @override
  Widget build(BuildContext context) {
    final navegacion = context.watch<Navegacion>();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: AnimatedSwitcher(
                duration: Medidas.fundidoPestanas,
                child: KeyedSubtree(
                  key: ValueKey(
                    navegacion.pestana == Pestanas.libroDetalle
                        ? '${navegacion.pestana}_${navegacion.libroId}'
                        : navegacion.pestana,
                  ),
                  child: _pestana(navegacion.pestana, navegacion.libroId),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: NeoTabBar(
              activa: navegacion.pestanaActiva,
              alElegir: navegacion.irAPestana,
            ),
          ),
        ],
      ),
    );
  }
}
