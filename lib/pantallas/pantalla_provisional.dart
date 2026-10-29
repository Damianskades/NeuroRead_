import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../estado/estado_usuario.dart';
import '../estado/navegacion.dart';
import '../tema/colores.dart';
import '../widgets/neo_button.dart';
import '../widgets/textos.dart';

class PantallaProvisional extends StatelessWidget {
  const PantallaProvisional({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final navegacion = context.read<Navegacion>();
    await context.read<EstadoUsuario>().cerrarSesion();
    navegacion.irA(Pantalla.acceso);
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<EstadoUsuario>().usuario;
    final destino = usuario == null
        ? ''
        : (usuario.evaluacionInicial ? 'Inicio' : 'Evaluación inicial');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 18,
            children: [
              TextoDisplay(
                usuario == null ? 'Cargando...' : 'Hola, ${usuario.nombre}',
                tamano: 26,
              ),
              if (usuario != null)
                Texto(
                  'Pantalla provisional hasta la fase 7. Aquí se abrirá: $destino.',
                  tamano: 14,
                ),
              const Spacer(),
              NeoButton(
                'CERRAR SESIÓN',
                superficie: Colores.transparente,
                colorBorde: Colores.rojo,
                colorTexto: Colores.rojo,
                sombra: 0,
                alto: 52,
                onPressed: () => _cerrarSesion(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
