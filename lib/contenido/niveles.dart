import 'dart:math' as math;

import 'package:flutter/painting.dart' show Color;

import '../tema/colores.dart';

class Nivel {
  const Nivel({
    required this.clave,
    required this.nombre,
    required this.minimo,
    required this.maximo,
    required this.color,
    required this.retroalimentacion,
    required this.recomendacion,
    required this.objetivo,
  });

  final String clave;
  final String nombre;
  final int minimo;
  final int maximo;
  final Color color;
  final String retroalimentacion;
  final String recomendacion;
  final String objetivo;
}

class Habilidad {
  const Habilidad({
    required this.clave,
    required this.nombre,
    required this.color,
    required this.descripcion,
  });

  final String clave;
  final String nombre;
  final Color color;
  final String descripcion;
}

const niveles = <Nivel>[
  Nivel(
    clave: 'EXPLORADOR',
    nombre: 'EXPLORADOR',
    minimo: 0,
    maximo: 59,
    color: Colores.turquesa,
    retroalimentacion: 'Estás comenzando a desarrollar tus habilidades de comprensión lectora. Necesitas practicar la identificación de información explícita, reconocer personajes y acontecimientos, comprender palabras por su contexto y ordenar las ideas principales. Cada lectura es una nueva oportunidad para avanzar.',
    recomendacion: 'Realiza lecturas breves, identifica personajes, lugares y hechos, ordena acontecimientos y responde preguntas literales con ayuda de pistas del texto.',
    objetivo: 'Reforzar comprensión literal, vocabulario y secuencia de acontecimientos.',
  ),
  Nivel(
    clave: 'CONSTRUCTOR',
    nombre: 'CONSTRUCTOR',
    minimo: 60,
    maximo: 74,
    color: Colores.dorado,
    retroalimentacion: 'Estás consolidando tus habilidades lectoras. Puedes reconocer información importante, pero necesitas seguir practicando cómo relacionar ideas, explicar causas y consecuencias, identificar las intenciones de los personajes y elaborar resúmenes. Sigue practicando para ganar seguridad.',
    recomendacion: 'Lee un fragmento y responde preguntas sobre causas, consecuencias, motivos de los personajes y significado de expresiones. Después, elabora un resumen con tus propias palabras.',
    objetivo: 'Mejorar inferencias, relaciones entre ideas y elaboración de resúmenes.',
  ),
  Nivel(
    clave: 'ESTRATEGA',
    nombre: 'ESTRATEGA',
    minimo: 75,
    maximo: 89,
    color: Colores.naranja,
    retroalimentacion: 'Demuestras un buen manejo de las habilidades de comprensión lectora y puedes resolver retos de mayor complejidad. Tu siguiente desafío es interpretar información implícita, justificar tus respuestas con evidencias del texto, evaluar decisiones y construir opiniones fundamentadas.',
    recomendacion: 'Realiza actividades de inferencia, análisis de personajes, identificación de hechos y opiniones, y argumentación con evidencias textuales.',
    objetivo:
        'Fortalecer argumentación, interpretación y evaluación de evidencias.',
  ),
  Nivel(
    clave: 'MAESTRO',
    nombre: 'MAESTRO',
    minimo: 90,
    maximo: 100,
    color: Colores.verde,
    retroalimentacion: 'Has demostrado un alto desempeño en esta evaluación. Ahora puedes profundizar en la interpretación, comparar perspectivas, evaluar críticamente las ideas y aplicar lo aprendido a nuevas situaciones. Recuerda que cada lectura presenta oportunidades para seguir desarrollándote.',
    recomendacion: 'Resuelve retos avanzados, compara interpretaciones, argumenta con evidencias y responde una nueva evaluación con preguntas diferentes para comprobar cómo aplicas tus habilidades.',
    objetivo: 'Profundizar el análisis, contrastar perspectivas y transferir aprendizajes.',
  ),
];

const habilidades = <String, Habilidad>{
  'literal': Habilidad(
    clave: 'literal',
    nombre: 'Localizar información',
    color: Colores.verde,
    descripcion: 'Encuentra datos, personajes y hechos que el texto dice de forma explícita.',
  ),
  'inferencial': Habilidad(
    clave: 'inferencial',
    nombre: 'Realizar inferencias',
    color: Colores.azul,
    descripcion: 'Deduce lo que el texto no dice directamente usando las pistas del autor.',
  ),
  'critica': Habilidad(
    clave: 'critica',
    nombre: 'Interpretar y evaluar el texto',
    color: Colores.naranja,
    descripcion: 'Opina sobre el mensaje del texto y justifica tu postura con evidencias.',
  ),
};

String claveTipo(String tipo) {
  final t = tipo.trim().toLowerCase();
  if (t == 'literal') {
    return 'literal';
  }
  if (t == 'inferencial') {
    return 'inferencial';
  }
  return 'critica';
}

Nivel nivelDe(num puntaje) {
  for (final nivel in niveles.reversed) {
    if (puntaje >= nivel.minimo) {
      return nivel;
    }
  }
  return niveles.first;
}

Nivel? porClave(String? clave) {
  for (final nivel in niveles) {
    if (nivel.clave == clave) {
      return nivel;
    }
  }
  return null;
}

int indiceNivel(String? clave) =>
    niveles.indexWhere((nivel) => nivel.clave == clave);

Nivel? siguienteNivel(String clave) {
  final i = indiceNivel(clave);
  if (i >= 0 && i < niveles.length - 1) {
    return niveles[i + 1];
  }
  return null;
}

int puntosParaSiguiente(int puntaje) {
  final siguiente = siguienteNivel(nivelDe(puntaje).clave);
  if (siguiente == null) {
    return 0;
  }
  return math.max(siguiente.minimo - puntaje, 0);
}
