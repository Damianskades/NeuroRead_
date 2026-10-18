import random
import re
import unicodedata
import theme

NIVELES = [
    {
        'clave': 'FACIL',
        'nombre': 'NIVEL FÁCIL',
        'regla': 'Toca SÍ cuando la palabra sea un ANIMAL',
        'si': 'SÍ, ES ANIMAL',
        'no': 'NO ES',
        'tiempo': 0,
        'color': theme.VERDE,
        'items': [
            {'palabra': 'Delfín',    'ok': True},
            {'palabra': 'Orquídea',  'ok': False},
            {'palabra': 'Jaguar',    'ok': True},
            {'palabra': 'Montaña',   'ok': False},
            {'palabra': 'Colibrí',   'ok': True},
            {'palabra': 'Relámpago', 'ok': False},
        ],
    },
    {
        'clave': 'NORMAL',
        'nombre': 'NIVEL NORMAL',
        'regla': 'Toca SÍ cuando la palabra sea un COLOR',
        'si': 'SÍ, ES COLOR',
        'no': 'NO ES',
        'tiempo': 4,
        'color': theme.DORADO,
        'items': [
            {'palabra': 'Turquesa', 'ok': True},
            {'palabra': 'Trueno',   'ok': False},
            {'palabra': 'Naranja',  'ok': True},
            {'palabra': 'Granizo',  'ok': False},
            {'palabra': 'Violeta',  'ok': True},
            {'palabra': 'Carmesí',  'ok': True},
        ],
    },
    {
        'clave': 'DIFICIL',
        'nombre': 'NIVEL DIFÍCIL',
        'regla': 'Toca SÍ cuando la palabra esté escrita CORRECTAMENTE',
        'si': 'SÍ, CORRECTA',
        'no': 'TIENE ERROR',
        'tiempo': 3,
        'color': theme.NARANJA,
        'items': [
            {'palabra': 'Bibloteca',   'ok': False},
            {'palabra': 'Esperanza',   'ok': True},
            {'palabra': 'Concentración', 'ok': True},
            {'palabra': 'Imajinación', 'ok': False},
            {'palabra': 'Murciélago',  'ok': True},
            {'palabra': 'Exelente',    'ok': False},
        ],
    },
    {
        'clave': 'ULTRA',
        'nombre': 'NEUROULTRA',
        'regla': 'Toca SÍ solo si la palabra pertenece a la LECTURA de hoy',
        'si': 'SÍ, APARECE',
        'no': 'NO APARECE',
        'tiempo': 2,
        'color': theme.ROJO,
        'items': [],
    },
]

ULTRA_DISTRACTORES = ['Volcán', 'Brújula', 'Cometa', 'Laberinto',
                      'Pergamino', 'Molino', 'Glaciar', 'Tambor']


COMUNES = {'tienen', 'estaba', 'habian', 'habia', 'cuando', 'porque', 'durante',
           'mientras', 'aunque', 'entonces', 'tambien', 'siempre', 'algunos',
           'algunas', 'nosotros', 'ustedes', 'ellos', 'ellas', 'despues',
           'antes', 'sobre', 'entre', 'hasta', 'desde', 'donde', 'quienes',
           'primero', 'segundo', 'mañana', 'gobierno', 'momento', 'historia'}


def base(p):
    n = unicodedata.normalize('NFD', p.lower())
    return ''.join(c for c in n if unicodedata.category(c) != 'Mn')


COMUNES_BASE = {base(c) for c in COMUNES}


def construir_ultra(texto):
    palabras = re.findall(r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]{7,}", texto)
    vistas, propias = set(), []
    for p in palabras:
        k = base(p)
        if k not in vistas and k not in COMUNES_BASE:
            vistas.add(k)
            propias.append(p.capitalize())
    rng = random.Random(len(texto))
    rng.shuffle(propias)
    propias = propias[:3] if len(propias) >= 3 else propias
    ajenas = [d for d in ULTRA_DISTRACTORES if base(d) not in vistas]
    rng.shuffle(ajenas)
    items = [{'palabra': p, 'ok': True} for p in propias]
    items += [{'palabra': a, 'ok': False} for a in ajenas[:6 - len(items)]]
    rng.shuffle(items)
    return items
