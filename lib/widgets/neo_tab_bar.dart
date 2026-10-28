import 'package:flutter/widgets.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'neo_icon.dart';
import 'pintura_neo.dart';
import 'presionable.dart';

class Pestana {
  const Pestana(this.clave, this.texto, this.icono);

  final String clave;
  final String texto;
  final String icono;
}

const pestanas = [
  Pestana('inicio', 'Inicio', 'inicio'),
  Pestana('ruta', 'Ruta', 'ruta'),
  Pestana('evaluacion', 'Evaluación', 'evaluacion'),
  Pestana('libros', 'Libros', 'libro'),
  Pestana('perfil', 'Perfil', 'perfil'),
];

class NeoTabBar extends StatelessWidget {
  const NeoTabBar({super.key, required this.activa, required this.alElegir});

  final String activa;
  final ValueChanged<String> alElegir;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 80,
    child: CustomPaint(
      painter: const _PinturaBarraInferior(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
        child: Row(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final pestana in pestanas)
              Expanded(
                child: NeoTab(
                  pestana: pestana,
                  activo: pestana.clave == activa,
                  onTap: () => alElegir(pestana.clave),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _PinturaBarraInferior extends CustomPainter {
  const _PinturaBarraInferior();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colores.tarjeta);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 4),
      Paint()..color = Colores.borde,
    );
  }

  @override
  bool shouldRepaint(_PinturaBarraInferior anterior) => false;
}

class NeoTab extends StatelessWidget {
  const NeoTab({
    super.key,
    required this.pestana,
    required this.activo,
    required this.onTap,
  });

  final Pestana pestana;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = activo ? Colores.textoOscuro : Colores.textoSec;
    return Presionable(
      onTap: onTap,
      builder: (context, presionado) => CustomPaint(
        painter: activo
            ? PinturaNeo(
                superficie: Colores.dorado,
                radio: 12,
                sombra: 3,
                borde: 2,
                desplazamiento: presionado ? 2 : 0,
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 7, 2, 5),
          child: Column(
            spacing: 3,
            children: [
              NeoIcon.cuadrado(
                pestana.icono,
                lado: 22,
                marco: false,
                colorGlifo: color,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    pestana.texto,
                    textAlign: TextAlign.center,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: Tipografia.display(11, color: color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
