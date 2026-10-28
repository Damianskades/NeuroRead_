import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../contenido/niveles.dart';
import '../logica/fechas.dart';
import '../logica/focus.dart';
import '../logica/puntajes.dart';
import '../modelos/progreso.dart';
import '../modelos/usuario.dart';
import '../servicios/autenticacion.dart';
import '../servicios/repositorio.dart';

class Estadisticas {
  const Estadisticas(this.total, this.mejor, this.racha);

  final int total;
  final int mejor;
  final int racha;
}

class EstadoUsuario extends ChangeNotifier {
  EstadoUsuario({ServicioAutenticacion? autenticacion})
    : autenticacion = autenticacion ?? ServicioAutenticacion() {
    _cuenta = this.autenticacion.cuenta.listen(_cambioDeCuenta);
  }

  final ServicioAutenticacion autenticacion;
  late final StreamSubscription<String?> _cuenta;
  final List<StreamSubscription<Object?>> _escuchas = [];

  Repositorio get repositorio => autenticacion.repositorio;

  String? uid;
  Usuario? usuario;
  bool cuentaRevisada = false;
  bool perfilCargado = false;
  List<SesionResumen> sesiones = const [];
  List<CapituloLeido> capitulos = const [];
  List<ActividadCompletada> completadas = const [];
  List<ActividadEnCurso> enCurso = const [];

  bool get conectado => uid != null;

  void _cambioDeCuenta(String? nuevo) {
    if (nuevo == uid && cuentaRevisada) {
      return;
    }
    _cancelarEscuchas();
    uid = nuevo;
    usuario = null;
    perfilCargado = false;
    sesiones = const [];
    capitulos = const [];
    completadas = const [];
    enCurso = const [];
    cuentaRevisada = true;
    if (nuevo != null) {
      _escuchar(repositorio.escucharUsuario(nuevo), (valor) {
        usuario = valor;
        perfilCargado = true;
      });
      _escuchar(repositorio.escucharSesiones(nuevo), (v) => sesiones = v);
      _escuchar(repositorio.escucharCapitulos(nuevo), (v) => capitulos = v);
      _escuchar(repositorio.escucharCompletadas(nuevo), (v) => completadas = v);
      _escuchar(repositorio.escucharEnCurso(nuevo), (v) => enCurso = v);
    }
    notifyListeners();
  }

  void _escuchar<T>(Stream<T> flujo, void Function(T) asignar) {
    _escuchas.add(
      flujo.listen(
        (valor) {
          asignar(valor);
          notifyListeners();
        },
        onError: (Object error) =>
            debugPrint('Error al escuchar datos del usuario: $error'),
      ),
    );
  }

  void _cancelarEscuchas() {
    for (final escucha in _escuchas) {
      escucha.cancel();
    }
    _escuchas.clear();
  }

  @override
  void dispose() {
    _cuenta.cancel();
    _cancelarEscuchas();
    super.dispose();
  }

  SesionResumen? get primeraSesion => sesiones.isEmpty ? null : sesiones.first;

  SesionResumen? get ultimaSesion => sesiones.isEmpty ? null : sesiones.last;

  SesionResumen? sesionPorId(String id) {
    for (final sesion in sesiones) {
      if (sesion.id == id) {
        return sesion;
      }
    }
    return null;
  }

  SesionResumen? sesionAnteriorA(String id) {
    final i = sesiones.indexWhere((sesion) => sesion.id == id);
    return i > 0 ? sesiones[i - 1] : null;
  }

  (Nivel, SesionResumen?) get nivelActual {
    final ultima = ultimaSesion;
    if (ultima != null) {
      return (nivelDe(ultima.puntajeGlobal), ultima);
    }
    return (porClave(usuario?.nivel) ?? nivelDe(0), null);
  }

  Estadisticas get estadisticas => Estadisticas(
    sesiones.length,
    sesiones.fold(0, (mejor, sesion) => math.max(mejor, sesion.puntajeGlobal)),
    racha(sesiones.map((sesion) => sesion.fecha), DateTime.now()),
  );

  List<int> capitulosLeidos(String libroId) => [
    for (final capitulo in capitulos)
      if (capitulo.libroId == libroId) capitulo.capitulo,
  ]..sort();

  Map<String, List<int>> get leidosPorLibro {
    final mapa = <String, List<int>>{};
    for (final capitulo in capitulos) {
      mapa.putIfAbsent(capitulo.libroId, () => []).add(capitulo.capitulo);
    }
    for (final lista in mapa.values) {
      lista.sort();
    }
    return mapa;
  }

  Map<String, DateTime> get ultimaLecturaPorLibro {
    final mapa = <String, DateTime>{};
    for (final capitulo in capitulos) {
      final anterior = mapa[capitulo.libroId];
      if (anterior == null || capitulo.fecha.isAfter(anterior)) {
        mapa[capitulo.libroId] = capitulo.fecha;
      }
    }
    return mapa;
  }

  bool _despuesDe(DateTime fecha, DateTime? desde) =>
      desde == null || fecha.isAfter(desde);

  int contarActividadesDesde(String nivel, DateTime? desde) => {
    for (final actividad in completadas)
      if (actividad.nivel == nivel && _despuesDe(actividad.fecha, desde))
        actividad.actividadId,
  }.length;

  Set<String> actividadesCompletadasDesde(DateTime? desde) => {
    for (final actividad in completadas)
      if (_despuesDe(actividad.fecha, desde)) actividad.actividadId,
  };

  ActividadEnCurso? get actividadEnCursoReciente =>
      enCurso.isEmpty ? null : enCurso.first;

  ActividadEnCurso? progresoDe(String actividadId) {
    for (final progreso in enCurso) {
      if (progreso.actividadId == actividadId) {
        return progreso;
      }
    }
    return null;
  }

  List<String> get enCursoRecientes => [
    for (final progreso in enCurso) progreso.actividadId,
  ];

  void _sinEsperar(Future<void> escritura) => unawaited(
    escritura.catchError(
      (Object error) => debugPrint('Error al guardar en Firestore: $error'),
    ),
  );

  void marcarCapituloLeido(String libroId, int capitulo) {
    final id = uid;
    if (id == null || capitulosLeidos(libroId).contains(capitulo)) {
      return;
    }
    _sinEsperar(
      repositorio.marcarCapituloLeido(
        id,
        CapituloLeido(
          libroId: libroId,
          capitulo: capitulo,
          fecha: DateTime.now(),
        ),
      ),
    );
  }

  void guardarProgreso(String actividadId, List<RespuestaPaso> respuestas) {
    final id = uid;
    if (id == null) {
      return;
    }
    _sinEsperar(
      repositorio.guardarActividadEnCurso(
        id,
        ActividadEnCurso(
          actividadId: actividadId,
          paso: respuestas.length,
          respuestas: respuestas,
          actualizado: DateTime.now(),
        ),
      ),
    );
  }

  void completarActividad(ActividadCompletada completada) {
    final id = uid;
    if (id == null) {
      return;
    }
    _sinEsperar(repositorio.completarActividad(id, completada));
  }

  String? guardarSesion(SesionResumen sesion, {required bool inicial}) {
    final id = uid;
    if (id == null) {
      return null;
    }
    final (idSesion, escritura) = repositorio.guardarSesion(
      id,
      sesion,
      inicial: inicial,
    );
    _sinEsperar(escritura);
    return idSesion;
  }

  void guardarPalabrasUsadas(List<(String, String)> palabras) {
    final id = uid;
    if (id == null) {
      return;
    }
    final fecha = DateTime.now();
    _sinEsperar(
      repositorio.guardarPalabrasUsadas(id, [
        for (final (nivel, palabra) in palabras)
          PalabraUsada(nivel: nivel, palabra: palabra, fecha: fecha),
      ]),
    );
  }

  Future<List<PalabraUsada>> palabrasRecientes() async {
    final id = uid;
    if (id == null) {
      return const [];
    }
    try {
      return await repositorio.palabrasRecientes(id);
    } catch (error) {
      debugPrint('No se pudieron leer las palabras usadas: $error');
      return const [];
    }
  }
}
