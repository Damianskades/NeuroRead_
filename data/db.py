import os
import re
import glob
import json
import hmac
import shutil
import sqlite3
import hashlib
from contextlib import contextmanager
from datetime import date, datetime, timedelta

_BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(_BASE, 'neuroread.db')
BACKUP_DIR = os.path.join(_BASE, 'backups')
BACKUPS_MAXIMOS = 5

ITERACIONES = 200000

SEED_USUARIOS = [
    ('angela', 'Angela', 'Prueba', 'Segundo de secundaria',
     'angela@neuroread.local', 'user123'),
    ('gabriel', 'Gabriel', 'Prueba', 'Tercero de secundaria',
     'gabriel@neuroread.local', 'user321'),
]

USUARIOS = {
    'id': 'id_usuario', 'nombre_usuario': 'usu_nombreUs', 'nombre': 'usu_nombre',
    'apellido': 'usu_apellido', 'grado': 'usu_grado', 'correo': 'usu_correo',
    'password_hash': 'usu_contrasenaHash', 'sal': 'usu_sal', 'nivel': 'usu_nivel',
    'evaluacion_inicial': 'usu_evaluacionInicial', 'estado': 'usu_estado',
    'creado': 'usu_creado', 'actualizado': 'usu_actualizado',
}
SESIONES = {
    'id': 'id_sesion', 'usuario_id': 'id_usuario', 'fecha': 'ses_fecha',
    'tipo': 'ses_tipo', 'texto_id': 'ses_textoId', 'puntaje_global': 'ses_puntajeGlobal',
    'nivel': 'ses_nivel', 'velocidad': 'ses_velocidad', 'comprension': 'ses_comprension',
    'interpretacion': 'ses_interpretacion', 'imaginacion': 'ses_imaginacion',
    'concentracion': 'ses_concentracion', 'retencion': 'ses_retencion',
    'literal': 'ses_literal', 'inferencial': 'ses_inferencial', 'critica': 'ses_critica',
    'tiempo_lectura': 'ses_tiempoLectura', 'ppm': 'ses_ppm',
}
CAPITULOS = {
    'id': 'id_capituloLeido', 'usuario_id': 'id_usuario', 'libro_id': 'cap_libroId',
    'capitulo': 'cap_capitulo', 'fecha': 'cap_fecha',
}
COMPLETADAS = {
    'id': 'id_actividadCompletada', 'usuario_id': 'id_usuario',
    'actividad_id': 'aco_actividadId', 'libro_id': 'aco_libroId', 'nivel': 'aco_nivel',
    'aciertos': 'aco_aciertos', 'total': 'aco_total', 'respuesta': 'aco_respuesta',
    'fecha': 'aco_fecha',
}
EN_CURSO = {
    'usuario_id': 'id_usuario', 'actividad_id': 'aec_actividadId', 'paso': 'aec_paso',
    'respuestas': 'aec_respuestas', 'actualizado': 'aec_actualizado',
}

MIGRACION = [
    ('usuarios', 'tblUsuarios', USUARIOS),
    ('sesiones', 'tblSesiones', SESIONES),
    ('capitulos_leidos', 'tblCapitulosLeidos', CAPITULOS),
    ('actividades_completadas', 'tblActividadesCompletadas', COMPLETADAS),
    ('actividad_en_curso', 'tblActividadEnCurso', EN_CURSO),
]

PUBLICOS_USUARIO = ['id', 'nombre_usuario', 'nombre', 'apellido', 'grado', 'correo', 'nivel',
                    'evaluacion_inicial', 'estado', 'creado', 'actualizado']

ESQUEMA = [
    """CREATE TABLE IF NOT EXISTS tblUsuarios (
        id_usuario            INTEGER PRIMARY KEY AUTOINCREMENT,
        usu_nombreUs          TEXT NOT NULL UNIQUE COLLATE NOCASE,
        usu_nombre            TEXT NOT NULL,
        usu_apellido          TEXT NOT NULL,
        usu_grado             TEXT NOT NULL,
        usu_correo            TEXT NOT NULL UNIQUE COLLATE NOCASE,
        usu_contrasenaHash    TEXT NOT NULL,
        usu_sal               TEXT,
        usu_nivel             TEXT,
        usu_evaluacionInicial INTEGER NOT NULL DEFAULT 0,
        usu_estado            TEXT NOT NULL DEFAULT 'activo',
        usu_creado            TEXT NOT NULL,
        usu_actualizado       TEXT NOT NULL
    )""",
    """CREATE TABLE IF NOT EXISTS tblSesiones (
        id_sesion          INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario         INTEGER NOT NULL REFERENCES tblUsuarios(id_usuario),
        ses_fecha          TEXT NOT NULL,
        ses_tipo           TEXT NOT NULL DEFAULT 'inicial',
        ses_textoId        INTEGER,
        ses_puntajeGlobal  INTEGER NOT NULL,
        ses_nivel          TEXT,
        ses_velocidad      INTEGER,
        ses_comprension    INTEGER,
        ses_interpretacion INTEGER,
        ses_imaginacion    INTEGER,
        ses_concentracion  INTEGER,
        ses_retencion      INTEGER,
        ses_literal        INTEGER,
        ses_inferencial    INTEGER,
        ses_critica        INTEGER,
        ses_tiempoLectura  REAL,
        ses_ppm            INTEGER
    )""",
    """CREATE TABLE IF NOT EXISTS tblCapitulosLeidos (
        id_capituloLeido INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario       INTEGER NOT NULL REFERENCES tblUsuarios(id_usuario),
        cap_libroId      TEXT NOT NULL,
        cap_capitulo     INTEGER NOT NULL,
        cap_fecha        TEXT NOT NULL,
        UNIQUE (id_usuario, cap_libroId, cap_capitulo)
    )""",
    """CREATE TABLE IF NOT EXISTS tblActividadesCompletadas (
        id_actividadCompletada INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario             INTEGER NOT NULL REFERENCES tblUsuarios(id_usuario),
        aco_actividadId        TEXT NOT NULL,
        aco_libroId            TEXT,
        aco_nivel              TEXT,
        aco_aciertos           INTEGER,
        aco_total              INTEGER,
        aco_respuesta          TEXT,
        aco_fecha              TEXT NOT NULL
    )""",
    """CREATE TABLE IF NOT EXISTS tblActividadEnCurso (
        id_usuario      INTEGER NOT NULL REFERENCES tblUsuarios(id_usuario),
        aec_actividadId TEXT NOT NULL,
        aec_paso        INTEGER NOT NULL DEFAULT 0,
        aec_respuestas  TEXT,
        aec_actualizado TEXT NOT NULL,
        PRIMARY KEY (id_usuario, aec_actividadId)
    )""",
]

SQL_USUARIOS_ANTIGUA = """
    CREATE TABLE {nombre} (
        id                 INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_usuario     TEXT NOT NULL UNIQUE COLLATE NOCASE,
        nombre             TEXT NOT NULL,
        apellido           TEXT NOT NULL,
        grado              TEXT NOT NULL,
        correo             TEXT NOT NULL UNIQUE COLLATE NOCASE,
        password_hash      TEXT NOT NULL,
        sal                TEXT,
        nivel              TEXT,
        evaluacion_inicial INTEGER NOT NULL DEFAULT 0,
        estado             TEXT NOT NULL DEFAULT 'activo',
        creado             TEXT NOT NULL,
        actualizado        TEXT NOT NULL
    )"""


def _a_app(fila, equivalencias):
    if fila is None:
        return None
    inversa = {v: k for k, v in equivalencias.items()}
    return {inversa.get(k, k): fila[k] for k in fila.keys()}


def _ahora():
    return datetime.now().isoformat(timespec='seconds')


def _ahora_fino():
    return datetime.now().isoformat(timespec='microseconds')


def _conn():
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute('PRAGMA foreign_keys = ON')
    return con


@contextmanager
def _db():
    con = _conn()
    try:
        with con:
            yield con
    finally:
        con.close()


def _nueva_sal():
    return os.urandom(16).hex()


def _hash(password, sal):
    return hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'),
                               bytes.fromhex(sal), ITERACIONES).hex()


def _hash_antiguo(password):
    return hashlib.sha256(password.encode('utf-8')).hexdigest()


def _verificar(fila, password):
    if fila['usu_sal']:
        calculado = _hash(password, fila['usu_sal'])
    else:
        calculado = _hash_antiguo(password)
    return hmac.compare_digest(calculado, fila['usu_contrasenaHash'])


def _guardar_clave(con, usuario_id, password):
    sal = _nueva_sal()
    con.execute('UPDATE tblUsuarios SET usu_contrasenaHash = ?, usu_sal = ?, '
                'usu_actualizado = ? WHERE id_usuario = ?',
                (_hash(password, sal), sal, _ahora(), usuario_id))


def _tablas(con):
    return {f[0] for f in con.execute("SELECT name FROM sqlite_master WHERE type = 'table'")}


def _columnas(con, tabla):
    return [f[1] for f in con.execute(f'PRAGMA table_info({tabla})')]


def _migrar_usuarios_muy_antiguos(con):
    filas = con.execute('SELECT id, nombre, password_hash, creado FROM usuarios '
                        'ORDER BY id').fetchall()
    con.execute('PRAGMA foreign_keys = OFF')
    try:
        con.execute('BEGIN')
        con.execute('DROP TABLE IF EXISTS usuarios_nuevo')
        con.execute(SQL_USUARIOS_ANTIGUA.format(nombre='usuarios_nuevo'))
        usados = set()
        for f in filas:
            usuario = f['nombre'].strip().lower()
            if usuario in usados:
                usuario = f'{usuario}{f["id"]}'
            usados.add(usuario)
            con.execute(
                'INSERT INTO usuarios_nuevo (id, nombre_usuario, nombre, apellido, '
                'grado, correo, password_hash, sal, creado, actualizado) '
                "VALUES (?, ?, ?, '', '', ?, ?, NULL, ?, ?)",
                (f['id'], usuario, f['nombre'], f'{usuario}@neuroread.local',
                 f['password_hash'], f['creado'], f['creado']))
        con.execute('DROP TABLE usuarios')
        con.execute('ALTER TABLE usuarios_nuevo RENAME TO usuarios')
        con.execute('COMMIT')
    except Exception:
        con.execute('ROLLBACK')
        raise
    finally:
        con.execute('PRAGMA foreign_keys = ON')


def _migrar_a_tbl(con):
    existentes = _tablas(con)
    con.execute('PRAGMA foreign_keys = OFF')
    try:
        con.execute('BEGIN')
        for sql in ESQUEMA:
            con.execute(sql)
        for antigua, nueva, equivalencias in MIGRACION:
            if antigua not in existentes:
                continue
            disponibles = set(_columnas(con, antigua))
            pares = [(vieja, col) for vieja, col in equivalencias.items() if vieja in disponibles]
            origen = ', '.join(v for v, _ in pares)
            destino = ', '.join(c for _, c in pares)
            con.execute(f'INSERT INTO {nueva} ({destino}) SELECT {origen} FROM {antigua}')
        for antigua, _, _ in reversed(MIGRACION):
            if antigua in existentes:
                con.execute(f'DROP TABLE {antigua}')
        if con.execute('PRAGMA foreign_key_check').fetchall():
            raise sqlite3.IntegrityError('Referencias rotas al migrar a las tablas tbl.')
        con.execute('COMMIT')
    except Exception:
        con.execute('ROLLBACK')
        raise
    finally:
        con.execute('PRAGMA foreign_keys = ON')


def init_db():
    con = sqlite3.connect(DB_PATH, isolation_level=None)
    con.row_factory = sqlite3.Row
    try:
        tablas = _tablas(con)
        if 'tblUsuarios' not in tablas and 'usuarios' in tablas:
            respaldar_db()
            if 'nombre_usuario' not in _columnas(con, 'usuarios'):
                _migrar_usuarios_muy_antiguos(con)
            _migrar_a_tbl(con)
        else:
            for sql in ESQUEMA:
                con.execute(sql)
    finally:
        con.close()
    for datos in SEED_USUARIOS:
        if not _existe(datos[0], datos[4]):
            crear_usuario(*datos)


def _existe(nombre_usuario, correo):
    with _db() as con:
        return con.execute('SELECT 1 FROM tblUsuarios WHERE usu_nombreUs = ? '
                           'OR usu_correo = ?', (nombre_usuario, correo)).fetchone() is not None


def _limpiar(nombre_usuario, nombre, apellido, grado, correo):
    return (nombre_usuario.strip(), nombre.strip(), apellido.strip(),
            grado.strip(), correo.strip().lower())


def _validar_datos(con, datos, excluir_id=None):
    nombre_usuario, nombre, apellido, grado, correo = datos
    if not all(datos):
        return 'Completa todos los campos.'
    if not re.match(r'^[^@\s]+@[^@\s]+\.[^@\s]+$', correo):
        return 'Escribe un correo válido.'
    otro = excluir_id if excluir_id is not None else -1
    if con.execute('SELECT 1 FROM tblUsuarios WHERE usu_nombreUs = ? AND id_usuario <> ?',
                   (nombre_usuario, otro)).fetchone():
        return 'Ese nombre de usuario ya existe.'
    if con.execute('SELECT 1 FROM tblUsuarios WHERE usu_correo = ? AND id_usuario <> ?',
                   (correo, otro)).fetchone():
        return 'Ese correo ya está registrado.'
    return None


def _usuario_publico(fila):
    datos = _a_app(fila, USUARIOS)
    return {k: datos[k] for k in PUBLICOS_USUARIO} if datos else None


def crear_usuario(nombre_usuario, nombre, apellido, grado, correo, password):
    datos = _limpiar(nombre_usuario, nombre, apellido, grado, correo)
    if not password:
        return None, 'Completa todos los campos.'
    with _db() as con:
        error = _validar_datos(con, datos)
        if error:
            return None, error
        sal = _nueva_sal()
        ahora = _ahora()
        try:
            cur = con.execute(
                'INSERT INTO tblUsuarios (usu_nombreUs, usu_nombre, usu_apellido, usu_grado, '
                'usu_correo, usu_contrasenaHash, usu_sal, usu_creado, usu_actualizado) '
                'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                datos + (_hash(password, sal), sal, ahora, ahora))
        except sqlite3.IntegrityError:
            return None, 'Ese nombre de usuario o correo ya existe.'
        return cur.lastrowid, None


def obtener_usuario(usuario_id):
    with _db() as con:
        fila = con.execute('SELECT * FROM tblUsuarios WHERE id_usuario = ?',
                           (usuario_id,)).fetchone()
    return _usuario_publico(fila)


def listar_usuarios():
    with _db() as con:
        filas = con.execute('SELECT * FROM tblUsuarios ORDER BY id_usuario').fetchall()
    return [_usuario_publico(f) for f in filas]


def actualizar_usuario(usuario_id, nombre_usuario, nombre, apellido, grado, correo):
    datos = _limpiar(nombre_usuario, nombre, apellido, grado, correo)
    with _db() as con:
        if not con.execute('SELECT 1 FROM tblUsuarios WHERE id_usuario = ?',
                           (usuario_id,)).fetchone():
            return False, 'El usuario no existe.'
        error = _validar_datos(con, datos, excluir_id=usuario_id)
        if error:
            return False, error
        try:
            con.execute(
                'UPDATE tblUsuarios SET usu_nombreUs = ?, usu_nombre = ?, usu_apellido = ?, '
                'usu_grado = ?, usu_correo = ?, usu_actualizado = ? WHERE id_usuario = ?',
                datos + (_ahora(), usuario_id))
        except sqlite3.IntegrityError:
            return False, 'Ese nombre de usuario o correo ya existe.'
    return True, None


def _fila_clave(con, usuario_id):
    return con.execute('SELECT id_usuario, usu_contrasenaHash, usu_sal FROM tblUsuarios '
                       'WHERE id_usuario = ?', (usuario_id,)).fetchone()


def verificar_contrasena(usuario_id, password):
    with _db() as con:
        fila = _fila_clave(con, usuario_id)
    return fila is not None and _verificar(fila, password)


def cambiar_contrasena(usuario_id, actual, nueva):
    if not nueva:
        return False, 'La contraseña nueva no puede estar vacía.'
    with _db() as con:
        fila = _fila_clave(con, usuario_id)
        if fila is None:
            return False, 'El usuario no existe.'
        if not _verificar(fila, actual):
            return False, 'La contraseña actual no es correcta.'
        _guardar_clave(con, usuario_id, nueva)
    return True, None


def eliminar_usuario(usuario_id, password):
    with _db() as con:
        fila = _fila_clave(con, usuario_id)
        if fila is None:
            return False, 'El usuario no existe.'
        if not _verificar(fila, password):
            return False, 'La contraseña no es correcta.'
        for tabla in ('tblActividadEnCurso', 'tblActividadesCompletadas',
                      'tblCapitulosLeidos', 'tblSesiones', 'tblUsuarios'):
            con.execute(f'DELETE FROM {tabla} WHERE id_usuario = ?', (usuario_id,))
    return True, None


def validar_login(login, password):
    login = login.strip()
    if not login or not password:
        return None
    with _db() as con:
        fila = con.execute(
            'SELECT id_usuario, usu_contrasenaHash, usu_sal FROM tblUsuarios '
            "WHERE usu_estado = 'activo' AND (usu_nombreUs = ? OR usu_correo = ?)",
            (login, login)).fetchone()
        if fila is None or not _verificar(fila, password):
            return None
        if not fila['usu_sal']:
            _guardar_clave(con, fila['id_usuario'], password)
    return obtener_usuario(fila['id_usuario'])


def marcar_evaluacion_inicial(usuario_id, nivel):
    with _db() as con:
        con.execute('UPDATE tblUsuarios SET usu_evaluacionInicial = 1, usu_nivel = ?, '
                    'usu_actualizado = ? WHERE id_usuario = ?', (nivel, _ahora(), usuario_id))


def actualizar_nivel(usuario_id, nivel):
    with _db() as con:
        con.execute('UPDATE tblUsuarios SET usu_nivel = ?, usu_actualizado = ? '
                    'WHERE id_usuario = ?', (nivel, _ahora(), usuario_id))


def _entero(valor):
    return None if valor is None else round(valor)


def guardar_sesion(usuario_id, datos):
    with _db() as con:
        cur = con.execute(
            'INSERT INTO tblSesiones (id_usuario, ses_fecha, ses_tipo, ses_textoId, '
            'ses_puntajeGlobal, ses_nivel, ses_velocidad, ses_comprension, '
            'ses_interpretacion, ses_imaginacion, ses_concentracion, ses_retencion, '
            'ses_literal, ses_inferencial, ses_critica, ses_tiempoLectura, ses_ppm) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            (usuario_id, _ahora(), datos.get('tipo', 'inicial'), datos.get('texto_id'),
             round(datos['puntaje_global']), datos.get('nivel'),
             _entero(datos.get('velocidad')), _entero(datos.get('comprension')),
             _entero(datos.get('interpretacion')), _entero(datos.get('imaginacion')),
             _entero(datos.get('concentracion')), _entero(datos.get('retencion')),
             _entero(datos.get('literal')), _entero(datos.get('inferencial')),
             _entero(datos.get('critica')), datos.get('tiempo_lectura'),
             _entero(datos.get('ppm'))))
        return cur.lastrowid


def historial_completo(usuario_id):
    with _db() as con:
        filas = con.execute('SELECT * FROM tblSesiones WHERE id_usuario = ? '
                            'ORDER BY id_sesion', (usuario_id,)).fetchall()
    return [_a_app(f, SESIONES) for f in filas]


def _sesion_extremo(usuario_id, orden):
    with _db() as con:
        fila = con.execute(f'SELECT * FROM tblSesiones WHERE id_usuario = ? '
                           f'ORDER BY id_sesion {orden} LIMIT 1', (usuario_id,)).fetchone()
    return _a_app(fila, SESIONES)


def primera_sesion(usuario_id):
    return _sesion_extremo(usuario_id, 'ASC')


def ultima_sesion(usuario_id):
    return _sesion_extremo(usuario_id, 'DESC')


def estadisticas(usuario_id):
    with _db() as con:
        total = con.execute(
            'SELECT COUNT(*) FROM tblSesiones WHERE id_usuario = ?',
            (usuario_id,)).fetchone()[0]
        mejor = con.execute(
            'SELECT MAX(ses_puntajeGlobal) FROM tblSesiones WHERE id_usuario = ?',
            (usuario_id,)).fetchone()[0]
        fechas = {date.fromisoformat(f[0][:10]) for f in con.execute(
            'SELECT DISTINCT ses_fecha FROM tblSesiones WHERE id_usuario = ?',
            (usuario_id,))}
    return {'total': total, 'mejor': mejor or 0, 'racha': _racha(fechas)}


def _racha(fechas):
    hoy = date.today()
    inicio = hoy if hoy in fechas else hoy - timedelta(days=1)
    racha, d = 0, inicio
    while d in fechas:
        racha += 1
        d -= timedelta(days=1)
    return racha


def marcar_capitulo_leido(usuario_id, libro_id, capitulo):
    with _db() as con:
        con.execute('INSERT OR IGNORE INTO tblCapitulosLeidos (id_usuario, cap_libroId, '
                    'cap_capitulo, cap_fecha) VALUES (?, ?, ?, ?)',
                    (usuario_id, str(libro_id), capitulo, _ahora()))


def capitulos_leidos(usuario_id, libro_id):
    with _db() as con:
        filas = con.execute('SELECT cap_capitulo FROM tblCapitulosLeidos WHERE id_usuario = ? '
                            'AND cap_libroId = ? ORDER BY cap_capitulo',
                            (usuario_id, str(libro_id))).fetchall()
    return [f[0] for f in filas]


def lecturas_por_libro(usuario_id):
    with _db() as con:
        filas = con.execute('SELECT cap_libroId, COUNT(*), MAX(cap_fecha) '
                            'FROM tblCapitulosLeidos WHERE id_usuario = ? GROUP BY cap_libroId',
                            (usuario_id,)).fetchall()
    return {f[0]: {'leidos': f[1], 'ultima': f[2]} for f in filas}


def guardar_actividad_completada(usuario_id, actividad_id, libro_id, nivel,
                                 aciertos, total, respuesta):
    with _db() as con:
        cur = con.execute(
            'INSERT INTO tblActividadesCompletadas (id_usuario, aco_actividadId, aco_libroId, '
            'aco_nivel, aco_aciertos, aco_total, aco_respuesta, aco_fecha) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            (usuario_id, actividad_id, None if libro_id is None else str(libro_id),
             nivel, aciertos, total, json.dumps(respuesta, ensure_ascii=False),
             _ahora()))
        return cur.lastrowid


def _decodificar(fila, equivalencias, campo):
    d = _a_app(fila, equivalencias)
    d[campo] = json.loads(d[campo]) if d[campo] else None
    return d


def actividades_completadas(usuario_id):
    with _db() as con:
        filas = con.execute('SELECT * FROM tblActividadesCompletadas WHERE id_usuario = ? '
                            'ORDER BY id_actividadCompletada', (usuario_id,)).fetchall()
    return [_decodificar(f, COMPLETADAS, 'respuesta') for f in filas]


def contar_actividades_desde(usuario_id, nivel, fecha_iso):
    with _db() as con:
        return con.execute(
            'SELECT COUNT(DISTINCT aco_actividadId) FROM tblActividadesCompletadas '
            'WHERE id_usuario = ? AND aco_nivel = ? AND aco_fecha > ?',
            (usuario_id, nivel, fecha_iso or '')).fetchone()[0]


def actividades_completadas_desde(usuario_id, fecha_iso):
    with _db() as con:
        filas = con.execute('SELECT DISTINCT aco_actividadId FROM tblActividadesCompletadas '
                            'WHERE id_usuario = ? AND aco_fecha > ?',
                            (usuario_id, fecha_iso or '')).fetchall()
    return {f[0] for f in filas}


def obtener_actividad_en_curso(usuario_id):
    with _db() as con:
        fila = con.execute('SELECT * FROM tblActividadEnCurso WHERE id_usuario = ? '
                           'ORDER BY aec_actualizado DESC, rowid DESC LIMIT 1',
                           (usuario_id,)).fetchone()
    return _decodificar(fila, EN_CURSO, 'respuestas') if fila else None


def obtener_progreso_actividad(usuario_id, actividad_id):
    with _db() as con:
        fila = con.execute('SELECT * FROM tblActividadEnCurso WHERE id_usuario = ? '
                           'AND aec_actividadId = ?', (usuario_id, actividad_id)).fetchone()
    return _decodificar(fila, EN_CURSO, 'respuestas') if fila else None


def actividades_en_curso(usuario_id):
    with _db() as con:
        filas = con.execute('SELECT * FROM tblActividadEnCurso WHERE id_usuario = ? '
                            'ORDER BY aec_actualizado DESC, rowid DESC',
                            (usuario_id,)).fetchall()
    return {f['aec_actividadId']: _decodificar(f, EN_CURSO, 'respuestas') for f in filas}


def guardar_actividad_en_curso(usuario_id, actividad_id, paso, respuestas):
    with _db() as con:
        con.execute(
            'INSERT INTO tblActividadEnCurso (id_usuario, aec_actividadId, aec_paso, '
            'aec_respuestas, aec_actualizado) VALUES (?, ?, ?, ?, ?) '
            'ON CONFLICT(id_usuario, aec_actividadId) DO UPDATE SET aec_paso = excluded.aec_paso, '
            'aec_respuestas = excluded.aec_respuestas, '
            'aec_actualizado = excluded.aec_actualizado',
            (usuario_id, actividad_id, paso,
             json.dumps(respuestas, ensure_ascii=False), _ahora_fino()))


def borrar_actividad_en_curso(usuario_id, actividad_id=None):
    with _db() as con:
        if actividad_id is None:
            con.execute('DELETE FROM tblActividadEnCurso WHERE id_usuario = ?', (usuario_id,))
        else:
            con.execute('DELETE FROM tblActividadEnCurso WHERE id_usuario = ? '
                        'AND aec_actividadId = ?', (usuario_id, actividad_id))


def respaldar_db():
    if not os.path.isfile(DB_PATH):
        return None
    try:
        os.makedirs(BACKUP_DIR, exist_ok=True)
        marca = datetime.now().strftime('%Y%m%d_%H%M%S')
        destino = os.path.join(BACKUP_DIR, f'neuroread_{marca}.db')
        shutil.copy2(DB_PATH, destino)
        copias = sorted(glob.glob(os.path.join(BACKUP_DIR, 'neuroread_*.db')))
        for vieja in copias[:-BACKUPS_MAXIMOS]:
            os.remove(vieja)
        return destino
    except OSError:
        return None
