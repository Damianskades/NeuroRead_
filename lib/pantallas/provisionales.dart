import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../estado/estado_usuario.dart';
import '../estado/navegacion.dart';
import '../tema/colores.dart';
import '../widgets/neo_boton_icono.dart';
import '../widgets/neo_button.dart';
import '../widgets/textos.dart';

Future<void> _cerrarSesion(BuildContext context) async {
  final navegacion = context.read<Navegacion>();
  await context.read<EstadoUsuario>().cerrarSesion();
  navegacion.irA(Pantalla.acceso);
}

Widget _botonCerrarSesion(BuildContext context) => NeoButton(
  'CERRAR SESIÓN',
  superficie: Colores.transparente,
  colorBorde: Colores.rojo,
  colorTexto: Colores.rojo,
  sombra: 0,
  alto: 52,
  onPressed: () => _cerrarSesion(context),
);

class PestanaProvisional extends StatelessWidget {
  const PestanaProvisional({
    super.key,
    required this.titulo,
    required this.fase,
    this.conCerrarSesion = false,
  });

  final String titulo;
  final String fase;
  final bool conCerrarSesion;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        TextoDisplay(titulo, tamano: 26),
        Texto(fase, negrita: true),
        const Spacer(),
        if (conCerrarSesion) _botonCerrarSesion(context),
      ],
    ),
  );
}

class PantallaProvisional extends StatelessWidget {
  const PantallaProvisional({
    super.key,
    required this.titulo,
    required this.fase,
    this.alVolver,
    this.conCerrarSesion = false,
  });

  final String titulo;
  final String fase;
  final VoidCallback? alVolver;
  final bool conCerrarSesion;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 36, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            if (alVolver != null)
              NeoBotonIcono(texto: 'VOLVER', onTap: alVolver),
            TextoDisplay(titulo, tamano: 26),
            Texto(fase, negrita: true),
            const Spacer(),
            if (conCerrarSesion) _botonCerrarSesion(context),
          ],
        ),
      ),
    ),
  );
}
