import 'package:cloud_firestore/cloud_firestore.dart';

import '../contenido/focus.dart';
import '../logica/focus.dart';
import '../logica/puntajes.dart';
import '../modelos/conversion.dart';
import '../modelos/palabra_usada.dart';
import '../modelos/progreso.dart';
import '../modelos/sesion.dart';
import '../modelos/usuario.dart';

typedef Documento = Map<String, dynamic>;

class Repositorio {
  Repositorio([FirebaseFirestore? db]) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const subcolecciones = [
    'sesiones',
    'capitulosLeidos',
    'actividadesCompletadas',
    'actividadesEnCurso',
    'palabrasUsadas',
  ];

  DocumentReference<Documento> usuario(String uid) =>
      _db.collection('usuarios').doc(uid);

  DocumentReference<Documento> acceso(String clave) =>
      _db.collection('accesos').doc(clave);

  CollectionReference<Documento> _sub(String uid, String nombre) =>
      usuario(uid).collection(nombre);

  WriteBatch lote() => _db.batch();

  Future<void> limpiarCache() async {
    await _db.terminate();
    await _db.clearPersistence();
  }

  Stream<Usuario?> escucharUsuario(String uid) => usuario(uid)
      .snapshots()
      .map((doc) => doc.exists ? Usuario.desdeMapa(doc.id, doc.data()!) : null);

  Stream<List<SesionResumen>> escucharSesiones(String uid) =>
      _sub(uid, 'sesiones')
          .orderBy('ses_fecha')
          .snapshots()
          .map(
            (q) => [for (final d in q.docs) sesionDesdeMapa(d.id, d.data())],
          );

  Stream<List<CapituloLeido>> escucharCapitulos(String uid) =>
      _sub(uid, 'capitulosLeidos').snapshots().map(
        (q) => [for (final d in q.docs) CapituloLeido.desdeMapa(d.data())],
      );

  Stream<List<ActividadCompletada>> escucharCompletadas(String uid) =>
      _sub(uid, 'actividadesCompletadas')
          .orderBy('aco_fecha')
          .snapshots()
          .map(
            (q) => [
              for (final d in q.docs)
                ActividadCompletada.desdeMapa(d.id, d.data()),
            ],
          );

  Stream<List<ActividadEnCurso>> escucharEnCurso(String uid) =>
      _sub(uid, 'actividadesEnCurso')
          .orderBy('aec_actualizado', descending: true)
          .snapshots()
          .map(
            (q) => [
              for (final d in q.docs) ActividadEnCurso.desdeMapa(d.data()),
            ],
          );

  Future<void> marcarCapituloLeido(String uid, CapituloLeido capitulo) =>
      _sub(uid, 'capitulosLeidos')
          .doc(CapituloLeido.idDocumento(capitulo.libroId, capitulo.capitulo))
          .set(capitulo.aMapa(uid));

  Future<void> guardarActividadEnCurso(String uid, ActividadEnCurso progreso) =>
      _sub(
        uid,
        'actividadesEnCurso',
      ).doc(progreso.actividadId).set(progreso.aMapa(uid));

  Future<void> borrarActividadEnCurso(String uid, String actividadId) =>
      _sub(uid, 'actividadesEnCurso').doc(actividadId).delete();

  Future<void> completarActividad(String uid, ActividadCompletada completada) {
    final lote = _db.batch()
      ..set(_sub(uid, 'actividadesCompletadas').doc(), completada.aMapa(uid))
      ..delete(_sub(uid, 'actividadesEnCurso').doc(completada.actividadId));
    return lote.commit();
  }

  (String, Future<void>) guardarSesion(
    String uid,
    SesionResumen sesion, {
    required bool inicial,
  }) {
    final doc = _sub(uid, 'sesiones').doc();
    final lote = _db.batch()
      ..set(doc, mapaDeSesion(sesion, uid))
      ..update(usuario(uid), {
        'usu_nivel': sesion.nivel,
        if (inicial) 'usu_evaluacionInicial': true,
        'usu_actualizado': marcaDe(sesion.fecha),
      });
    return (doc.id, lote.commit());
  }

  Future<void> guardarPalabrasUsadas(String uid, List<PalabraUsada> palabras) {
    final lote = _db.batch();
    for (final palabra in palabras) {
      lote.set(_sub(uid, 'palabrasUsadas').doc(), mapaDePalabra(palabra, uid));
    }
    return lote.commit();
  }

  Future<List<PalabraUsada>> palabrasRecientes(
    String uid, {
    bool soloCache = false,
  }) async {
    final consulta = await _sub(uid, 'palabrasUsadas')
        .orderBy('pal_fecha', descending: true)
        .limit(evaluacionesSinRepetir * palabrasPorNivel * 3)
        .get(soloCache ? const GetOptions(source: Source.cache) : null);
    return [for (final d in consulta.docs) palabraDesdeMapa(d.data())];
  }

  Future<List<DocumentReference<Documento>>> documentosDelUsuario(
    String uid,
  ) async {
    final referencias = <DocumentReference<Documento>>[];
    for (final nombre in subcolecciones) {
      final consulta = await _sub(
        uid,
        nombre,
      ).get(const GetOptions(source: Source.server));
      referencias.addAll(consulta.docs.map((d) => d.reference));
    }
    return referencias;
  }
}
