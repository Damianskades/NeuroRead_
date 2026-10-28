import 'dart:ui';

import '../tema/colores.dart';
import 'animacion.dart';
import 'pintura_logo.dart';
import 'trazo.dart';

final _hojaIzquierda = trazo(
  'M100 42 C80 32 50 30 28 36 L28 126 C50 120 80 122 100 132 Z',
);
final _hojaDerecha = trazo(
  'M100 42 C120 32 150 30 172 36 L172 126 C150 120 120 122 100 132 Z',
);
const _pliegueIzquierdo =
    'M45 62 C55 52 70 54 72 66 C74 78 58 80 60 92 C62 104 80 102 84 112';
const _pliegueDerecho =
    'M155 62 C145 52 130 54 128 66 C126 78 142 80 140 92 C138 104 120 102 116 112';
final _pliegueIzq = trazo(_pliegueIzquierdo);
final _pliegueDer = trazo(_pliegueDerecho);
final _recorridoChispa = trazo(
  '$_pliegueIzquierdo L116 112 C120 102 138 104 140 92 C142 80 126 78 128 66 '
  'C130 54 145 52 155 62',
).computeMetrics().first;

class LogoLibroNeuronal extends PinturaLogo {
  const LogoLibroNeuronal(super.t);

  @override
  Size get vista => const Size(200, 164);

  @override
  void dibujar(Canvas canvas) {
    final subida = fotograma([(0, 0), (0.5, -5), (1, 0)], (t % 3.0) / 3.0);
    canvas.save();
    canvas.translate(0, subida);
    for (final hoja in [_hojaIzquierda, _hojaDerecha]) {
      relleno(canvas, hoja.shift(const Offset(6, 6)), negro);
    }
    for (final hoja in [_hojaIzquierda, _hojaDerecha]) {
      relleno(canvas, hoja, Colores.dorado);
      linea(canvas, hoja, 4, negro);
    }
    linea(canvas, segmento(100, 42, 100, 132), 3, negro);
    linea(canvas, _pliegueIzq, 3.5, Colores.textoOscuro);
    linea(canvas, _pliegueDer, 3.5, Colores.textoOscuro);
    final avance = (t % 2.6) / 2.6 * _recorridoChispa.length;
    final punto = _recorridoChispa.getTangentForOffset(avance)!.position;
    circulo(canvas, punto, 9, Colores.verde, alfa: 0.35);
    circulo(canvas, punto, 5, Colores.verde, borde: negro, anchoBorde: 2);
    canvas.restore();
  }
}

final _ojo = trazo('M30 78 Q100 24 170 78 Q100 132 30 78 Z');

class LogoOjoLector extends PinturaLogo {
  const LogoOjoLector(super.t);

  @override
  void dibujar(Canvas canvas) {
    final p = (t % 4.0) / 4.0;
    final leer = fotograma([
      (0, -22),
      (0.38, 22),
      (0.46, -22),
      (0.8, 10),
      (1, -22),
    ], p);
    final parpadeo = fotograma([
      (0, 1),
      (0.88, 1),
      (0.92, 0.08),
      (0.96, 1),
      (1, 1),
    ], p);
    canvas.save();
    escalarEn(canvas, 1, parpadeo, 100, 78);
    relleno(canvas, _ojo.shift(const Offset(6, 6)), negro);
    relleno(canvas, _ojo, crema);
    canvas.save();
    canvas.clipPath(_ojo);
    canvas.translate(leer, 0);
    circulo(
      canvas,
      const Offset(100, 78),
      21,
      Colores.turquesa,
      borde: negro,
      anchoBorde: 4,
    );
    circulo(canvas, const Offset(100, 78), 9, negro);
    circulo(canvas, const Offset(105, 73), 3.5, crema);
    canvas.restore();
    linea(canvas, _ojo, 5, negro);
    canvas.restore();
    rect(
      canvas,
      44,
      148,
      112,
      9,
      Colores.dorado,
      r: 4.5,
      borde: negro,
      anchoBorde: 2.5,
    );
    rect(
      canvas,
      44,
      166,
      80,
      9,
      Colores.verde,
      r: 4.5,
      borde: negro,
      anchoBorde: 2.5,
    );
  }
}

final _puntaPlumon = trazo('M37 122 L41 108 H49 L53 122 Z');

class LogoSubrayado extends PinturaLogo {
  const LogoSubrayado(super.t);

  @override
  void dibujar(Canvas canvas) {
    final p = (t % 3.2) / 3.2;
    cuadradoHoja(canvas);
    canvas.save();
    canvas.clipRRect(hojaRedondeada);
    rect(canvas, 38.75, 0, 2.5, 200, Colores.rojo);
    final subrayado = fotograma([
      (0, 0),
      (0.08, 0),
      (0.45, 1),
      (0.88, 1),
      (0.96, 0),
      (1, 0),
    ], p);
    if (subrayado > 0) {
      canvas.save();
      escalarEn(canvas, subrayado, 1, 30, 99);
      rect(canvas, 30, 86, 150, 26, Colores.verde);
      canvas.restore();
    }
    for (final (x, y, w, h, r) in const [
      (52.0, 40.0, 112.0, 9.0, 4.5),
      (52.0, 64.0, 86.0, 9.0, 4.5),
      (52.0, 94.0, 120.0, 10.0, 5.0),
      (52.0, 124.0, 100.0, 9.0, 4.5),
      (52.0, 148.0, 60.0, 9.0, 4.5),
    ]) {
      rect(canvas, x, y, w, h, negro, r: r);
    }
    final movimiento = fotogramaPunto([
      (0, const Offset(-21, -15)),
      (0.08, const Offset(-21, -15)),
      (0.45, const Offset(125, -15)),
      (0.6, const Offset(150, -60)),
      (0.88, const Offset(150, -60)),
      (1, const Offset(-21, -15)),
    ], p);
    canvas.save();
    canvas.translate(movimiento.dx, movimiento.dy);
    rotarEn(canvas, 38, 40, 120);
    rect(canvas, 38, 126, 22, 70, negro, r: 5);
    rect(
      canvas,
      34,
      122,
      22,
      70,
      Colores.turquesa,
      r: 5,
      borde: negro,
      anchoBorde: 4,
    );
    rect(canvas, 34, 150, 22, 10, crema, borde: negro, anchoBorde: 3);
    relleno(canvas, _puntaPlumon, Colores.verde);
    linea(canvas, _puntaPlumon, 4, negro);
    canvas.restore();
    canvas.restore();
    bordeHoja(canvas);
  }
}

final _circuloNota = trazo(
  'M60 108 C58 72 98 58 128 66 C160 74 170 108 150 136 C130 160 78 158 62 132 '
  'C54 118 58 98 74 84',
).computeMetrics().first;
final _vistoNota = trazo('M138 166 L148 176 L168 152').computeMetrics().first;

class LogoNota20 extends PinturaLogo {
  const LogoNota20(super.t);

  void _parcial(Canvas canvas, PathMetric medida, double fraccion) {
    if (fraccion <= 0) {
      return;
    }
    linea(
      canvas,
      medida.extractPath(0, medida.length * fraccion),
      6,
      Colores.rojo,
    );
  }

  @override
  void dibujar(Canvas canvas) {
    final p = (t % 3.4) / 3.4;
    cuadradoHoja(canvas);
    canvas.save();
    canvas.clipRRect(hojaRedondeada);
    for (var y = 36.0; y < 200; y += 20) {
      rect(canvas, 0, y - 0.75, 200, 1.5, Colores.azul, alfa: 0.45);
    }
    rect(canvas, 28.75, 0, 2.5, 200, Colores.rojo);
    rect(canvas, 40, 22, 56, 7, negro, r: 3.5, alfa: 0.7);
    texto(canvas, '20', 111, 139, 74, negro);
    texto(canvas, '20', 107, 135, 74, Colores.rojo, contorno: 1.75);
    final circuloAvance =
        1 - fotograma([(0, 1), (0.1, 1), (0.45, 0), (0.9, 0), (1, 1)], p);
    final vistoAvance =
        1 - fotograma([(0, 1), (0.48, 1), (0.6, 0), (0.9, 0), (1, 1)], p);
    _parcial(canvas, _circuloNota, circuloAvance);
    _parcial(canvas, _vistoNota, vistoAvance);
    canvas.restore();
    bordeHoja(canvas);
  }
}

class LogoNConPuntos extends PinturaLogo {
  const LogoNConPuntos(super.t);

  void _libro(
    Canvas canvas,
    double x,
    double y,
    double alto,
    Color color,
    List<double> rayas,
  ) {
    rect(canvas, x + 5, y + 5, 34, alto, negro, r: 6);
    rect(canvas, x, y, 34, alto, color, r: 6, borde: negro, anchoBorde: 5);
    for (final raya in rayas) {
      linea(canvas, segmento(x + 7, raya, x + 27, raya), 3.5, negro);
    }
  }

  @override
  void dibujar(Canvas canvas) {
    final p = (t % 3.6) / 3.6;
    rect(canvas, 18, 18, 172, 172, negro, r: 40);
    rect(
      canvas,
      8,
      8,
      172,
      172,
      Colores.dorado,
      r: 40,
      borde: negro,
      anchoBorde: 6,
    );
    final caer = fotograma([
      (0, 27),
      (0.2, -4),
      (0.28, 3),
      (0.34, 0),
      (0.9, 0),
      (1, 27),
    ], p);
    canvas.save();
    rotarEn(canvas, caer, 94, 156);
    rotarEn(canvas, -27, 94, 96);
    _libro(canvas, 77, 34, 122, crema, const [54, 136]);
    canvas.restore();
    _libro(canvas, 36, 42, 114, Colores.turquesa, const [60, 138]);
    _libro(canvas, 118, 42, 114, Colores.verde, const [60, 138]);
    linea(canvas, segmento(28, 160, 162, 160), 7, negro);
    final puntos = fotograma([
      (0, 0),
      (0.34, 0),
      (0.42, 1.2),
      (0.48, 1),
      (0.86, 1),
      (0.94, 0),
      (1, 0),
    ], p);
    if (puntos > 0) {
      canvas.save();
      escalarEn(canvas, puntos, puntos, 163, 20);
      rect(canvas, 136, 6, 62, 32, negro, r: 16);
      rect(
        canvas,
        132,
        2,
        62,
        32,
        Colores.rojo,
        r: 16,
        borde: negro,
        anchoBorde: 4,
      );
      texto(canvas, '+10', 163, 24, 17, crema);
      canvas.restore();
    }
  }
}
