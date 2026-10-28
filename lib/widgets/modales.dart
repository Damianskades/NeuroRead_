import 'package:flutter/material.dart';

import '../tema/colores.dart';
import 'neo_button.dart';
import 'neo_card.dart';
import 'textos.dart';

Future<T?> mostrarModal<T>(BuildContext context, WidgetBuilder constructor) =>
    showGeneralDialog<T>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colores.velo,
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animacion, secundaria) => constructor(context),
      transitionBuilder: (context, animacion, secundaria, hijo) =>
          FadeTransition(opacity: animacion, child: hijo),
    );

class ModalNeo extends StatelessWidget {
  const ModalNeo({
    super.key,
    required this.children,
    this.ancho = 320,
    this.espacio = 16,
  });

  final List<Widget> children;
  final double ancho;
  final double espacio;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: ancho,
      child: Material(
        type: MaterialType.transparency,
        child: NeoCard(
          radio: 18,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: espacio,
            children: children,
          ),
        ),
      ),
    ),
  );
}

class ModalSalir extends StatelessWidget {
  const ModalSalir({super.key, required this.alSalir});

  final VoidCallback alSalir;

  @override
  Widget build(BuildContext context) => ModalNeo(
    children: [
      const Texto('¿Quieres salir de NeuroRead?', tamano: 18, negrita: true),
      SizedBox(
        height: 52,
        child: Row(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: NeoButton(
                'SALIR',
                superficie: Colores.rojo,
                colorTexto: Colores.texto,
                tamano: 14,
                onPressed: () {
                  Navigator.of(context).pop();
                  alSalir();
                },
              ),
            ),
            Expanded(
              child: NeoButton(
                'CANCELAR',
                superficie: Colores.tarjetaAlt,
                colorTexto: Colores.texto,
                tamano: 14,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
