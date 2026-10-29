import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../contenido/actividades.dart';
import '../estado/navegacion.dart';
import '../widgets/modales.dart';

void salirDeLaApp() => SystemNavigator.pop();

void atras(BuildContext context) {
  final navegacion = context.read<Navegacion>();
  switch (navegacion.actual) {
    case Pantalla.acceso || Pantalla.registro:
      salirDeLaApp();
    case Pantalla.carga || Pantalla.bienvenida:
      return;
    case Pantalla.lector:
      navegacion.volverDeLector();
    case Pantalla.actividad:
      navegacion.volverDeActividad(
        libroDeActividad: actividadPorId(navegacion.actividadId)?.libroId,
      );
    case Pantalla.editarPerfil:
      navegacion.irAPestana(Pestanas.perfil);
    case Pantalla.resultados:
      navegacion.salirDeResultados();
    case Pantalla.principal:
      if (navegacion.pestana == Pestanas.libroDetalle) {
        navegacion.irAPestana(Pestanas.libros);
      } else if (navegacion.pestana != Pestanas.inicio) {
        navegacion.irAPestana(Pestanas.inicio);
      } else {
        mostrarModal<void>(
          context,
          (_) => const ModalSalir(alSalir: salirDeLaApp),
        );
      }
  }
}
