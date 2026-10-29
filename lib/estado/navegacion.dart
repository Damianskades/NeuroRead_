import 'package:flutter/foundation.dart';

enum Pantalla {
  carga,
  acceso,
  registro,
  principal,
  bienvenida,
  velocidad,
  comprension,
  interpretacion,
  imaginacion,
  concentracion,
  retencion,
  lector,
  actividad,
  resultados,
  editarPerfil,
}

abstract final class Pestanas {
  static const inicio = 'inicio';
  static const ruta = 'ruta';
  static const evaluacion = 'evaluacion';
  static const libros = 'libros';
  static const libroDetalle = 'libro_detalle';
  static const perfil = 'perfil';

  static const todas = [inicio, ruta, evaluacion, libros, perfil];
}

class Navegacion extends ChangeNotifier {
  Navegacion({Pantalla inicial = Pantalla.carga}) : _actual = inicial;

  Pantalla _actual;
  String _pestana = Pestanas.inicio;

  String? libroId;
  String? actividadId;
  String origenActividad = Pestanas.ruta;
  String? sesionId;
  String origenResultados = Pestanas.inicio;
  int numeroCapitulo = 1;
  String origenLector = 'detalle';

  Pantalla get actual => _actual;

  String get pestana => _pestana;

  String get pestanaActiva =>
      _pestana == Pestanas.libroDetalle ? Pestanas.libros : _pestana;

  void irA(Pantalla pantalla) {
    if (pantalla == _actual) {
      return;
    }
    _actual = pantalla;
    notifyListeners();
  }

  void irAPestana(String nombre) {
    if (nombre != Pestanas.libroDetalle && !Pestanas.todas.contains(nombre)) {
      return;
    }
    _pestana = nombre;
    _actual = Pantalla.principal;
    notifyListeners();
  }

  void entrar({required bool evaluacionInicialHecha}) {
    if (evaluacionInicialHecha) {
      irAPestana(Pestanas.inicio);
    } else {
      irA(Pantalla.bienvenida);
    }
  }

  void abrirLibro(String id) {
    libroId = id;
    irAPestana(Pestanas.libroDetalle);
  }

  void abrirLector(String libro, int numero, {String origen = 'detalle'}) {
    libroId = libro;
    numeroCapitulo = numero;
    origenLector = origen;
    _actual = Pantalla.lector;
    notifyListeners();
  }

  void abrirActividad(String id, {String origen = Pestanas.ruta}) {
    actividadId = id;
    origenActividad = origen;
    _actual = Pantalla.actividad;
    notifyListeners();
  }

  void abrirNeuroscore(String? id, {required String origen}) {
    sesionId = id;
    origenResultados = origen;
    _actual = Pantalla.resultados;
    notifyListeners();
  }

  void volverDeLector() {
    if (origenLector == 'actividad') {
      irA(Pantalla.actividad);
    } else if (origenLector == Pestanas.libros) {
      irAPestana(Pestanas.libros);
    } else if (libroId != null) {
      abrirLibro(libroId!);
    } else {
      irAPestana(Pestanas.libros);
    }
  }

  void volverDeActividad({String? libroDeActividad}) {
    if (origenActividad == 'libro' && libroDeActividad != null) {
      abrirLibro(libroDeActividad);
    } else {
      irAPestana(
        origenActividad == Pestanas.inicio || origenActividad == Pestanas.ruta
            ? origenActividad
            : Pestanas.ruta,
      );
    }
  }

  void salirDeResultados() =>
      irAPestana(sesionId != null ? origenResultados : Pestanas.inicio);
}
