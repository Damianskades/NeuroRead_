import 'package:flutter/widgets.dart';

import '../contenido/config.dart';
import '../tema/colores.dart';
import 'neo_chip.dart';

class SelectorGrado extends StatelessWidget {
  const SelectorGrado({
    super.key,
    required this.elegido,
    required this.alElegir,
  });

  final String? elegido;
  final ValueChanged<String> alElegir;

  Widget _chip(String grado) {
    final activo = grado == elegido;
    return NeoChip(
      grado,
      onTap: () => alElegir(grado),
      alto: 48,
      tamano: 13,
      alineacion: TextAlign.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      superficie: activo ? Colores.dorado : Colores.tarjetaAlt,
      colorTexto: activo ? Colores.textoOscuro : Colores.texto,
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 2, 4, 6),
    child: Column(
      spacing: 10,
      children: [
        for (var i = 0; i < grados.length; i += 2)
          Row(
            spacing: 10,
            children: [
              Expanded(child: _chip(grados[i])),
              Expanded(
                child: i + 1 < grados.length
                    ? _chip(grados[i + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
      ],
    ),
  );
}
