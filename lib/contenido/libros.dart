import 'package:flutter/painting.dart' show Color;
import 'package:flutter/services.dart' show rootBundle;

import '../tema/colores.dart';

class Capitulo {
  const Capitulo(this.numero, this.titulo);

  final int numero;
  final String titulo;

  String get archivo => '${numero.toString().padLeft(2, '0')}.txt';
}

class Libro {
  const Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    this.traductor,
    required this.tipo,
    required this.color,
    required this.fuente,
    required this.capitulos,
  });

  final String id;
  final String titulo;
  final String autor;
  final String? traductor;
  final String tipo;
  final Color color;
  final String fuente;
  final List<Capitulo> capitulos;
}

const libros = <Libro>[
  Libro(
    id: 'selva',
    titulo: 'Cuentos de la selva',
    autor: 'Horacio Quiroga',
    tipo: 'Cuentos',
    color: Colores.verde,
    fuente: 'https://es.wikisource.org/wiki/Cuentos_de_la_selva',
    capitulos: [
      Capitulo(1, 'La tortuga gigante'),
      Capitulo(2, 'Las medias de los flamencos'),
      Capitulo(3, 'El loro pelado'),
      Capitulo(4, 'La guerra de los yacarés'),
      Capitulo(5, 'La gama ciega'),
      Capitulo(
        6,
        'Historia de dos cachorros de coatí y de dos cachorros de hombre',
      ),
      Capitulo(7, 'El Paso del Yabebirí'),
      Capitulo(8, 'La abeja haragana'),
    ],
  ),
  Libro(
    id: 'isla',
    titulo: 'La isla del tesoro',
    autor: 'Robert Louis Stevenson',
    traductor: 'Manuel Caballero',
    tipo: 'Novela',
    color: Colores.turquesa,
    fuente:
        'https://es.wikisource.org/wiki/La_isla_del_tesoro_(Manuel_Caballero)',
    capitulos: [
      Capitulo(1, 'EL VIEJO LOBO MARINO EN LA POSADA DEL “ALMIRANTE BENBOW”'),
      Capitulo(2, '“BLACK DOG” APARECE Y DESAPARECE'),
      Capitulo(3, 'EL DISCO NEGRO'),
      Capitulo(4, 'EL COFRE DEL MUERTO'),
      Capitulo(5, 'DEL FIN QUE TUVO EL MENDIGO CIEGO'),
      Capitulo(6, 'LOS PAPELES DEL CAPITÁN'),
      Capitulo(7, 'SALGO PARA BRÍSTOL'),
      Capitulo(8, 'LA TABERNA DE “EL VIGÍA.”'),
      Capitulo(9, 'PÓLVORA Y ARMAS'),
      Capitulo(10, 'EL VIAJE'),
      Capitulo(11, 'LO QUE OÍ DESDE EL BARRIL'),
      Capitulo(12, 'CONSEJO DE GUERRA'),
      Capitulo(13, 'CÓMO EMPEZÓ LA AVENTURA'),
      Capitulo(14, 'EL PRIMER GOLPE'),
      Capitulo(15, 'EL HOMBRE DE LA ISLA'),
      Capitulo(
        16,
        'EL DOCTOR PROSIGUE LA NARRACIÓN Y REFIERE CÓMO FUÉ ABANDONADO EL BUQUE',
      ),
      Capitulo(
        17,
        'EL DOCTOR, CONTINUANDO LA NARRACIÓN, DESCRIBE EL ÚLTIMO VIAJE DEL SERENÍ',
      ),
      Capitulo(
        18,
        'EN QUE CUENTA EL DOCTOR CÓMO CONCLUYÓ EL PRIMER DÍA DE PELEA',
      ),
      Capitulo(
        19,
        'EL NARRADOR PRIMERO TOMA OTRA VEZ LA PALABRA—LA GUARNICIÓN DE LA ESTACADA',
      ),
      Capitulo(20, 'LA EMBAJADA DE SILVER'),
      Capitulo(21, 'EL ATAQUE'),
      Capitulo(22, 'DE CUAL FUÉ EL PRINCIPIO DE MI AVENTURA'),
      Capitulo(23, 'EL REFLUJO CORRE'),
      Capitulo(24, 'EL VIAJE DEL “CORACLE”'),
      Capitulo(25, '¡ABAJO LA BANDERA DEL PIRATA!'),
      Capitulo(26, 'ISRAEL HANDS'),
      Capitulo(27, '“¡PIEZAS DE Á OCHO!”'),
      Capitulo(28, 'EL CAMPO ENEMIGO'),
      Capitulo(29, 'OTRA VEZ EL DISCO NEGRO'),
      Capitulo(30, 'BAJO PALABRA'),
      Capitulo(31, 'EN BUSCA DEL TESORO—EL DIRECTORIO DE FLINT'),
      Capitulo(32, 'LA VOZ DEL ALMA EN PENA'),
      Capitulo(33, 'LA CAÍDA DE UN CAUDILLO'),
      Capitulo(34, 'SE CUENTA EL FIN DE ESTA VERDADERA HISTORIA'),
    ],
  ),
  Libro(
    id: 'principe',
    titulo: 'El príncipe feliz',
    autor: 'Oscar Wilde',
    tipo: 'Cuento',
    color: Colores.violeta,
    fuente: 'https://es.wikisource.org/wiki/El_pr%C3%ADncipe_feliz',
    capitulos: [Capitulo(1, 'El príncipe feliz')],
  ),
];

Libro? libroPorId(String? id) {
  for (final libro in libros) {
    if (libro.id == id) {
      return libro;
    }
  }
  return null;
}

Capitulo? capituloDe(String libroId, int numero) {
  final libro = libroPorId(libroId);
  if (libro == null) {
    return null;
  }
  for (final capitulo in libro.capitulos) {
    if (capitulo.numero == numero) {
      return capitulo;
    }
  }
  return null;
}

Future<String> leerCapitulo(String libroId, int numero) async {
  final capitulo = capituloDe(libroId, numero);
  if (capitulo == null) {
    return '';
  }
  final texto = await rootBundle.loadString(
    'assets/libros/$libroId/${capitulo.archivo}',
  );
  return texto.replaceAll('\r\n', '\n').trim();
}

Future<List<String>> parrafosCapitulo(String libroId, int numero) async =>
    (await leerCapitulo(
      libroId,
      numero,
    )).split('\n\n').where((parrafo) => parrafo.trim().isNotEmpty).toList();

Map<String, int> capitulosPorLibro() => {
  for (final libro in libros) libro.id: libro.capitulos.length,
};
