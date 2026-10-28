import 'dart:math' as math;

import 'package:flutter/painting.dart' show Color;

import '../contenido/modulos.dart';
import '../contenido/niveles.dart';
import '../contenido/textos.dart';
import '../tema/colores.dart';
import 'fechas.dart';
import 'redondeo.dart';

class Velocidad {
  int ppm = 0;
  double tiempoTotal = 0;
}

class Comprension {
  Comprension(this.total, this.porTipo);

  final int total;
  final Map<String, int> porTipo;
  int correctas = 0;
  int literal = 0;
  int inferencial = 0;
  int critica = 0;
  Map<String, double?> porcentajes = {
    'literal': null,
    'inferencial': null,
    'critica': null,
  };
}

class Interpretacion {
  int puntaje = 0;
  int palabrasTotal = 0;
}

class Imaginacion {
  int puntaje = 0;
  int palabras = 0;
  int riqueza = 0;
}

class Concentracion {
  int aciertos = 0;
  int errores = 0;
  int total = 0;
  double tiempoPromedio = 0;
  double rapidez = 0;
  String nivelMax = 'FACIL';
  bool ultraSuperado = false;
}

class Retencion {
  Retencion(this.total);

  final int total;
  int correctas = 0;
}

class DatosEvaluacion {
  DatosEvaluacion({
    required this.textoId,
    required this.textoTitulo,
    required this.comprension,
    required this.retencion,
  });

  factory DatosEvaluacion.de(TextoEvaluacion texto) {
    final porTipo = {'literal': 0, 'inferencial': 0, 'critica': 0};
    for (final pregunta in texto.comprension) {
      final clave = claveTipo(pregunta.tipo ?? '');
      porTipo[clave] = porTipo[clave]! + 1;
    }
    return DatosEvaluacion(
      textoId: texto.id,
      textoTitulo: texto.titulo,
      comprension: Comprension(texto.comprension.length, porTipo),
      retencion: Retencion(texto.retencion.length),
    );
  }

  final int textoId;
  final String textoTitulo;
  final velocidad = Velocidad();
  final Comprension comprension;
  final interpretacion = Interpretacion();
  final imaginacion = Imaginacion();
  final concentracion = Concentracion();
  final Retencion retencion;

  void registrarComprension(int correctas, Map<String, int> aciertosPorTipo) {
    final c = comprension;
    c.correctas = correctas;
    c.literal = aciertosPorTipo['literal'] ?? 0;
    c.inferencial = aciertosPorTipo['inferencial'] ?? 0;
    c.critica = aciertosPorTipo['critica'] ?? 0;
    c.porcentajes = {
      for (final MapEntry(key: clave, value: n) in c.porTipo.entries)
        clave: n == 0 ? null : (aciertosPorTipo[clave] ?? 0) / n * 100,
    };
  }
}

double _proporcion(int correctas, int total) =>
    total == 0 ? 0.0 : correctas / total;

Map<String, double> calcularPorcentajes(DatosEvaluacion s) {
  final propComp = _proporcion(s.comprension.correctas, s.comprension.total);
  final efectiva = s.velocidad.ppm * propComp;
  final vel = math.min(efectiva / ppmReferencia, 1.0) * 100;
  final comp = propComp * 100;
  final inter = s.interpretacion.puntaje.toDouble();
  final imag = s.imaginacion.puntaje.toDouble();
  final c = s.concentracion;
  double conc;
  if (c.total == 0) {
    conc = 0.0;
  } else {
    final acc = c.aciertos / c.total;
    final rapidez = c.rapidez.clamp(0.0, 1.0);
    final bono = c.ultraSuperado ? 10 : (c.nivelMax == 'ULTRA' ? 6 : 0);
    conc = math.min(acc * 70 + rapidez * 20 + bono, 100.0);
  }
  final ret = _proporcion(s.retencion.correctas, s.retencion.total) * 100;
  return {
    'VEL': vel,
    'COM': comp,
    'INT': inter,
    'IMA': imag,
    'CON': conc,
    'RET': ret,
  };
}

int puntajeGlobal(Map<String, double> porcentajes) {
  var suma = 0.0;
  for (final valor in porcentajes.values) {
    suma += valor;
  }
  return redondear(suma / porcentajes.length);
}

(List<String>, List<String>) fortalezasYMejoras(Map<String, double> pct) {
  final fortalezas = [
    for (final MapEntry(:key, :value) in pct.entries)
      if (value >= 70) habilidadesModulos[key]!,
  ];
  final porMejorar = [
    for (final MapEntry(:key, :value) in pct.entries)
      if (value < 60) habilidadesModulos[key]!,
  ];
  return (
    fortalezas.isEmpty
        ? ['Sigue practicando, vas por buen camino']
        : fortalezas.take(3).toList(),
    porMejorar.isEmpty
        ? ['Todo en buen nivel, felicidades']
        : porMejorar.take(3).toList(),
  );
}

class Comparacion {
  const Comparacion({
    required this.anterior,
    required this.nuevo,
    required this.diferencia,
    required this.mensaje,
    required this.signo,
  });

  final int anterior;
  final int nuevo;
  final int diferencia;
  final String mensaje;
  final int signo;
}

Comparacion comparar(int anterior, Nivel nivelPrevio, int total, Nivel nivel) {
  final cambio = indiceNivel(nivel.clave) - indiceNivel(nivelPrevio.clave);
  final signo = cambio.sign;
  return Comparacion(
    anterior: anterior,
    nuevo: total,
    diferencia: total - anterior,
    mensaje: mensajesComparacion[signo]!,
    signo: signo,
  );
}

(String, Color, Color) insigniaDiferencia(int diferencia) {
  final puntos = diferencia.abs() == 1 ? 'PUNTO' : 'PUNTOS';
  if (diferencia > 0) {
    return ('SUBISTE $diferencia $puntos', Colores.verde, Colores.textoOscuro);
  }
  if (diferencia < 0) {
    return ('BAJASTE ${-diferencia} $puntos', Colores.rojo, Colores.texto);
  }
  return ('SIN CAMBIOS', Colores.tarjetaAlt, Colores.texto);
}

class ModuloResultado {
  const ModuloResultado(this.codigo, this.valor, this.detalle);

  final String codigo;
  final String valor;
  final String detalle;
}

class DatosNeuroScore {
  const DatosNeuroScore({
    required this.puntaje,
    required this.nivel,
    required this.porcentajes,
    required this.modulos,
    required this.fortalezas,
    required this.porMejorar,
    required this.textoTitulo,
    this.comparacion,
    this.encabezado,
  });

  final int puntaje;
  final Nivel nivel;
  final Map<String, double> porcentajes;
  final List<ModuloResultado> modulos;
  final List<String> fortalezas;
  final List<String> porMejorar;
  final String textoTitulo;
  final Comparacion? comparacion;
  final String? encabezado;
}

DatosNeuroScore _armar(
  int total,
  Nivel nivel,
  Map<String, double> pct,
  List<ModuloResultado> modulos,
  String titulo,
  Comparacion? comparacion,
  String? encabezado,
) {
  final (fortalezas, porMejorar) = fortalezasYMejoras(pct);
  return DatosNeuroScore(
    puntaje: total,
    nivel: nivel,
    porcentajes: pct,
    modulos: modulos,
    fortalezas: fortalezas,
    porMejorar: porMejorar,
    textoTitulo: titulo,
    comparacion: comparacion,
    encabezado: encabezado,
  );
}

DatosNeuroScore datosSesionActual(
  DatosEvaluacion s, {
  Comparacion? comparacion,
}) {
  final pct = calcularPorcentajes(s);
  final total = puntajeGlobal(pct);
  final c = s.concentracion;
  final focusExtra = c.ultraSuperado
      ? 'NeuroUltra superado'
      : (c.nivelMax == 'ULTRA'
            ? 'Llegó a NeuroUltra'
            : 'Nivel máximo: ${nombresNivelFocus[c.nivelMax] ?? _titulo(c.nivelMax)}');
  final modulos = [
    ModuloResultado(
      'VEL',
      '${s.velocidad.ppm} PPM',
      'Leíste el texto en ${textoDecimal(s.velocidad.tiempoTotal)}s. $lectorPromedio',
    ),
    ModuloResultado(
      'COM',
      '${s.comprension.correctas}/${s.comprension.total}',
      'Literal: ${s.comprension.literal}, inferencial: ${s.comprension.inferencial}, '
          'crítica: ${s.comprension.critica}',
    ),
    ModuloResultado(
      'INT',
      '${redondear(pct['INT']!)}%',
      'Redactaste ${s.interpretacion.palabrasTotal} palabras analizando emoción e '
          'intención del autor.',
    ),
    ModuloResultado(
      'IMA',
      '${redondear(pct['IMA']!)}%',
      '${s.imaginacion.palabras} palabras con ${s.imaginacion.riqueza} descriptores '
          'sensoriales detectados.',
    ),
    ModuloResultado(
      'CON',
      '${c.aciertos}/${c.total}',
      '$focusExtra. Tiempo de reacción promedio: ${textoDecimal(c.tiempoPromedio)}s. '
          'Errores: ${c.errores}',
    ),
    ModuloResultado(
      'RET',
      '${s.retencion.correctas}/${s.retencion.total}',
      detalleRetencion,
    ),
  ];
  return _armar(
    total,
    nivelDe(total),
    pct,
    modulos,
    s.textoTitulo,
    comparacion,
    null,
  );
}

String _titulo(String texto) => texto.isEmpty
    ? texto
    : texto[0].toUpperCase() + texto.substring(1).toLowerCase();

class SesionResumen {
  const SesionResumen({
    this.id,
    required this.fecha,
    required this.tipo,
    required this.textoId,
    required this.puntajeGlobal,
    required this.nivel,
    required this.velocidad,
    required this.comprension,
    required this.interpretacion,
    required this.imaginacion,
    required this.concentracion,
    required this.retencion,
    required this.literal,
    required this.inferencial,
    required this.critica,
    required this.tiempoLectura,
    required this.ppm,
  });

  final String? id;
  final DateTime fecha;
  final String tipo;
  final int? textoId;
  final int puntajeGlobal;
  final String? nivel;
  final int? velocidad;
  final int? comprension;
  final int? interpretacion;
  final int? imaginacion;
  final int? concentracion;
  final int? retencion;
  final int? literal;
  final int? inferencial;
  final int? critica;
  final double? tiempoLectura;
  final int? ppm;

  int? valor(String campo) => switch (campo) {
    'velocidad' => velocidad,
    'comprension' => comprension,
    'interpretacion' => interpretacion,
    'imaginacion' => imaginacion,
    'concentracion' => concentracion,
    'retencion' => retencion,
    'literal' => literal,
    'inferencial' => inferencial,
    'critica' => critica,
    _ => null,
  };
}

int? _entero(double? valor) => valor == null ? null : redondear(valor);

SesionResumen sesionParaGuardar(
  DatosEvaluacion s, {
  required String tipo,
  required DateTime fecha,
}) {
  final pct = calcularPorcentajes(s);
  final total = puntajeGlobal(pct);
  final porcentajes = s.comprension.porcentajes;
  return SesionResumen(
    fecha: fecha,
    tipo: tipo,
    textoId: s.textoId,
    puntajeGlobal: total,
    nivel: nivelDe(total).clave,
    velocidad: _entero(pct['VEL']),
    comprension: _entero(pct['COM']),
    interpretacion: _entero(pct['INT']),
    imaginacion: _entero(pct['IMA']),
    concentracion: _entero(pct['CON']),
    retencion: _entero(pct['RET']),
    literal: _entero(porcentajes['literal']),
    inferencial: _entero(porcentajes['inferencial']),
    critica: _entero(porcentajes['critica']),
    tiempoLectura: s.velocidad.tiempoTotal,
    ppm: s.velocidad.ppm,
  );
}

Nivel nivelDeSesion(SesionResumen sesion) =>
    porClave(sesion.nivel) ?? nivelDe(sesion.puntajeGlobal);

String _porCiento(num? valor) => valor == null ? '--' : '${redondear(valor)}%';

DatosNeuroScore datosSesionGuardada(
  SesionResumen sesion,
  SesionResumen? previa,
) {
  final pct = {
    for (final MapEntry(key: codigo, value: campo) in camposModulos.entries)
      codigo: (sesion.valor(campo) ?? 0).toDouble(),
  };
  final total = sesion.puntajeGlobal;
  final nivel = nivelDeSesion(sesion);
  final ppm = sesion.ppm;
  final tiempo = sesion.tiempoLectura;
  final velocidad = ppm != null ? '$ppm PPM' : _porCiento(pct['VEL']);
  final lectura = tiempo != null
      ? 'Leíste el texto en ${textoCorto(redondearA(tiempo, 1))}s. $lectorPromedio'
      : 'Obtuviste ${_porCiento(pct['VEL'])} en velocidad lectora.';
  final modulos = [
    ModuloResultado('VEL', velocidad, lectura),
    ModuloResultado(
      'COM',
      _porCiento(pct['COM']),
      'Literal: ${_porCiento(sesion.literal)}, inferencial: '
          '${_porCiento(sesion.inferencial)}, crítica: ${_porCiento(sesion.critica)}',
    ),
    ModuloResultado(
      'INT',
      _porCiento(pct['INT']),
      'Obtuviste ${_porCiento(pct['INT'])} al analizar la emoción y la intención del autor.',
    ),
    ModuloResultado(
      'IMA',
      _porCiento(pct['IMA']),
      'Obtuviste ${_porCiento(pct['IMA'])} en imaginación, creatividad y visualización.',
    ),
    ModuloResultado(
      'CON',
      _porCiento(pct['CON']),
      'Obtuviste ${_porCiento(pct['CON'])} en atención y tiempo de reacción.',
    ),
    ModuloResultado('RET', _porCiento(pct['RET']), detalleRetencion),
  ];
  Comparacion? comparacion;
  if (previa != null) {
    comparacion = comparar(
      previa.puntajeGlobal,
      nivelDeSesion(previa),
      total,
      nivel,
    );
  }
  final texto = textoPorId(sesion.textoId)?.titulo ?? '';
  final tipo = sesion.tipo == 'inicial'
      ? 'Evaluación inicial'
      : 'Clasificatoria';
  return _armar(
    total,
    nivel,
    pct,
    modulos,
    texto,
    comparacion,
    '$tipo, ${fechaCorta(sesion.fecha)}',
  );
}

int contarPalabrasTexto(String texto) {
  final limpio = texto.trim();
  return limpio.isEmpty ? 0 : limpio.split(RegExp(r'\s+')).length;
}

int calcularPpm(String texto, double segundos) =>
    redondear(contarPalabrasTexto(texto) / math.max(segundos, 0.1) * 60);

int puntajeInterpretacion(List<int> palabrasPorRespuesta, int preguntas) {
  var puntaje = 0.0;
  for (final palabras in palabrasPorRespuesta) {
    puntaje += math.min(palabras / 30, 1.0);
  }
  return redondear(puntaje / preguntas * 100);
}

int puntajeImaginacion(int palabras, int riqueza) => redondear(
  (math.min(palabras / 80, 1.0) + math.min(riqueza / 8, 1.0)) / 2 * 100,
);
