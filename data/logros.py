from data import db
from data.niveles import indice

PPM_VELOCISTA = 200


def _subio_de_nivel(sesiones):
    niveles = [indice(s['nivel']) for s in sesiones if s.get('nivel')]
    return any(b > a for a, b in zip(niveles, niveles[1:]))


def _libro_completo(usuario_id, capitulos_por_libro):
    return any(total and len(db.capitulos_leidos(usuario_id, libro_id)) >= total
               for libro_id, total in capitulos_por_libro.items())


def generar_logros(usuario_id, capitulos_por_libro=None):
    sesiones = db.historial_completo(usuario_id) if usuario_id else []
    libros = capitulos_por_libro or {}
    return [
        {'nombre': 'Primera evaluación',
         'detalle': 'Completa tu evaluación inicial.',
         'ok': bool(sesiones)},
        {'nombre': 'Subiste de nivel',
         'detalle': 'Sube de nivel en una evaluación clasificatoria.',
         'ok': _subio_de_nivel(sesiones)},
        {'nombre': 'Velocista',
         'detalle': 'Lee a 200 palabras por minuto o más.',
         'ok': any((s.get('ppm') or 0) >= PPM_VELOCISTA for s in sesiones)},
        {'nombre': 'Memoria de acero',
         'detalle': 'Responde bien todas las preguntas de NeuroMemory.',
         'ok': any((s.get('retencion') or 0) >= 100 for s in sesiones)},
        {'nombre': 'Primer libro',
         'detalle': 'Lee todos los capítulos de un libro.',
         'ok': bool(usuario_id) and _libro_completo(usuario_id, libros)},
    ]
