from data.textos import get_texto_aleatorio
from data.niveles import clave_tipo

texto_activo = None
puntaje_global = 0
usuario = None
guardada = False
tipo_evaluacion = 'inicial'
comparacion = None


def nueva_sesion():
    global texto_activo, guardada, tipo_evaluacion, comparacion
    anterior = texto_activo['id'] if texto_activo else None
    texto_activo = get_texto_aleatorio(anterior)
    guardada = False
    comparacion = None
    tipo_evaluacion = ('clasificatoria' if usuario and usuario.get('evaluacion_inicial')
                       else 'inicial')
    return _make_session()


def _preguntas_por_tipo():
    conteo = {'literal': 0, 'inferencial': 0, 'critica': 0}
    for q in texto_activo['comprension_q']:
        conteo[clave_tipo(q['tipo'])] += 1
    return conteo


def _make_session():
    return {
        'texto_id':      texto_activo['id'],
        'texto_titulo':  texto_activo['titulo'],
        'velocidad':     {'wpm': 0, 'tiempo_total': 0},
        'comprension':   {'correctas': 0, 'literal': 0, 'inferencial': 0, 'critica': 0,
                          'total': len(texto_activo['comprension_q']),
                          'por_tipo': _preguntas_por_tipo(),
                          'porcentajes': {'literal': None, 'inferencial': None,
                                          'critica': None}},
        'interpretacion': {'puntaje': 0, 'palabras_total': 0},
        'imaginacion':   {'puntaje': 0, 'palabras': 0, 'riqueza': 0},
        'concentracion': {'aciertos': 0, 'errores': 0, 'total': 0,
                          'tiempo_promedio': 0, 'rapidez': 0.0, 'nivel_max': 'FACIL',
                          'ultra_superado': False},
        'retencion':     {'correctas': 0,
                          'total': len(texto_activo['retencion_q'])},
    }


def registrar_comprension(correctas, aciertos_por_tipo):
    c = session['comprension']
    c['correctas'] = correctas
    c.update(aciertos_por_tipo)
    c['porcentajes'] = {
        k: (aciertos_por_tipo[k] / n * 100 if n else None)
        for k, n in c['por_tipo'].items()
    }


session = nueva_sesion()
