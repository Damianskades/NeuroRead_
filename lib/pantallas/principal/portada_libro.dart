import 'package:flutter/widgets.dart';

import '../../contenido/libros.dart';
import '../../tema/colores.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';

class PortadaLibro extends StatelessWidget {
  const PortadaLibro({
    super.key,
    required this.libro,
    required this.ancho,
    required this.alto,
    required this.icono,
  });

  final Libro libro;
  final double ancho;
  final double alto;
  final double icono;

  @override
  Widget build(BuildContext context) => NeoCard(
    superficie: libro.color,
    radio: 10,
    sombra: 3,
    ancho: ancho,
    alto: alto,
    child: Center(
      child: NeoIcon.cuadrado(
        'libro',
        lado: icono,
        marco: false,
        colorGlifo: Colores.textoOscuro,
      ),
    ),
  );
}
