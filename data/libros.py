import os
import theme
from data import actividades as _actividades

CARPETA = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'libros')


def _capitulos(titulos):
    return [{'numero': i + 1, 'titulo': t, 'archivo': f'{i + 1:02d}.txt'}
            for i, t in enumerate(titulos)]


LIBROS = [
    {
        'id': 'selva',
        'titulo': 'Cuentos de la selva',
        'autor': 'Horacio Quiroga',
        'tipo': 'Cuentos',
        'color': theme.VERDE,
        'fuente': 'https://es.wikisource.org/wiki/Cuentos_de_la_selva',
        'capitulos': _capitulos([
            'La tortuga gigante',
            'Las medias de los flamencos',
            'El loro pelado',
            'La guerra de los yacarés',
            'La gama ciega',
            'Historia de dos cachorros de coatí y de dos cachorros de hombre',
            'El Paso del Yabebirí',
            'La abeja haragana',
        ]),
    },
    {
        'id': 'isla',
        'titulo': 'La isla del tesoro',
        'autor': 'Robert Louis Stevenson',
        'traductor': 'Manuel Caballero',
        'tipo': 'Novela',
        'color': theme.TURQUESA,
        'fuente': 'https://es.wikisource.org/wiki/La_isla_del_tesoro_(Manuel_Caballero)',
        'capitulos': _capitulos([
            'EL VIEJO LOBO MARINO EN LA POSADA DEL “ALMIRANTE BENBOW”',
            '“BLACK DOG” APARECE Y DESAPARECE',
            'EL DISCO NEGRO',
            'EL COFRE DEL MUERTO',
            'DEL FIN QUE TUVO EL MENDIGO CIEGO',
            'LOS PAPELES DEL CAPITÁN',
            'SALGO PARA BRÍSTOL',
            'LA TABERNA DE “EL VIGÍA.”',
            'PÓLVORA Y ARMAS',
            'EL VIAJE',
            'LO QUE OÍ DESDE EL BARRIL',
            'CONSEJO DE GUERRA',
            'CÓMO EMPEZÓ LA AVENTURA',
            'EL PRIMER GOLPE',
            'EL HOMBRE DE LA ISLA',
            'EL DOCTOR PROSIGUE LA NARRACIÓN Y REFIERE CÓMO FUÉ ABANDONADO EL BUQUE',
            'EL DOCTOR, CONTINUANDO LA NARRACIÓN, DESCRIBE EL ÚLTIMO VIAJE DEL SERENÍ',
            'EN QUE CUENTA EL DOCTOR CÓMO CONCLUYÓ EL PRIMER DÍA DE PELEA',
            'EL NARRADOR PRIMERO TOMA OTRA VEZ LA PALABRA—LA GUARNICIÓN DE LA ESTACADA',
            'LA EMBAJADA DE SILVER',
            'EL ATAQUE',
            'DE CUAL FUÉ EL PRINCIPIO DE MI AVENTURA',
            'EL REFLUJO CORRE',
            'EL VIAJE DEL “CORACLE”',
            '¡ABAJO LA BANDERA DEL PIRATA!',
            'ISRAEL HANDS',
            '“¡PIEZAS DE Á OCHO!”',
            'EL CAMPO ENEMIGO',
            'OTRA VEZ EL DISCO NEGRO',
            'BAJO PALABRA',
            'EN BUSCA DEL TESORO—EL DIRECTORIO DE FLINT',
            'LA VOZ DEL ALMA EN PENA',
            'LA CAÍDA DE UN CAUDILLO',
            'SE CUENTA EL FIN DE ESTA VERDADERA HISTORIA',
        ]),
    },
    {
        'id': 'principe',
        'titulo': 'El príncipe feliz',
        'autor': 'Oscar Wilde',
        'tipo': 'Cuento',
        'color': theme.VIOLETA,
        'fuente': 'https://es.wikisource.org/wiki/El_pr%C3%ADncipe_feliz',
        'capitulos': _capitulos(['El príncipe feliz']),
    },
]

def libro_por_id(libro_id):
    for libro in LIBROS:
        if libro['id'] == libro_id:
            return libro
    return None


def capitulo(libro_id, numero):
    libro = libro_por_id(libro_id)
    if libro is None:
        return None
    for cap in libro['capitulos']:
        if cap['numero'] == numero:
            return cap
    return None


def leer_capitulo(libro_id, numero):
    cap = capitulo(libro_id, numero)
    if cap is None:
        return ''
    ruta = os.path.join(CARPETA, libro_id, cap['archivo'])
    with open(ruta, encoding='utf-8') as f:
        return f.read().strip()


def parrafos_capitulo(libro_id, numero):
    return [p for p in leer_capitulo(libro_id, numero).split('\n\n') if p.strip()]


def capitulos_por_libro():
    return {libro['id']: len(libro['capitulos']) for libro in LIBROS}


def buscar_actividad(actividad_id):
    return _actividades.por_id(actividad_id)


def actividades_de_nivel(libro_id, nivel):
    return _actividades.de_libro_nivel(libro_id, nivel)
