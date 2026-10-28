import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import 'neo_card.dart';
import 'neo_icon.dart';
import 'textos.dart';

class ModHeader extends StatelessWidget {
  const ModHeader({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    this.colorChip = Colores.dorado,
  });

  final String icono;
  final String titulo;
  final String subtitulo;
  final Color colorChip;

  @override
  Widget build(BuildContext context) => NeoCard(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        NeoIcon.cuadrado(icono, lado: 48, colorChip: colorChip),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 2,
            children: [
              TextoDisplay(titulo, tamano: 20, color: colorChip),
              Texto(
                subtitulo,
                tamano: 13,
                color: Colores.textoSec,
                negrita: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
