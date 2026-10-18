import theme

NIVELES = [
    {
        'clave': 'EXPLORADOR',
        'nombre': 'EXPLORADOR',
        'minimo': 0,
        'maximo': 59,
        'color': theme.TURQUESA,
        'retroalimentacion': (
            'Estás comenzando a desarrollar tus habilidades de comprensión lectora. '
            'Necesitas practicar la identificación de información explícita, reconocer '
            'personajes y acontecimientos, comprender palabras por su contexto y ordenar '
            'las ideas principales. Cada lectura es una nueva oportunidad para avanzar.'),
        'recomendacion': (
            'Realiza lecturas breves, identifica personajes, lugares y hechos, ordena '
            'acontecimientos y responde preguntas literales con ayuda de pistas del texto.'),
        'objetivo': 'Reforzar comprensión literal, vocabulario y secuencia de acontecimientos.',
    },
    {
        'clave': 'CONSTRUCTOR',
        'nombre': 'CONSTRUCTOR',
        'minimo': 60,
        'maximo': 74,
        'color': theme.DORADO,
        'retroalimentacion': (
            'Estás consolidando tus habilidades lectoras. Puedes reconocer información '
            'importante, pero necesitas seguir practicando cómo relacionar ideas, explicar '
            'causas y consecuencias, identificar las intenciones de los personajes y '
            'elaborar resúmenes. Sigue practicando para ganar seguridad.'),
        'recomendacion': (
            'Lee un fragmento y responde preguntas sobre causas, consecuencias, motivos de '
            'los personajes y significado de expresiones. Después, elabora un resumen con '
            'tus propias palabras.'),
        'objetivo': 'Mejorar inferencias, relaciones entre ideas y elaboración de resúmenes.',
    },
    {
        'clave': 'ESTRATEGA',
        'nombre': 'ESTRATEGA',
        'minimo': 75,
        'maximo': 89,
        'color': theme.NARANJA,
        'retroalimentacion': (
            'Demuestras un buen manejo de las habilidades de comprensión lectora y puedes '
            'resolver retos de mayor complejidad. Tu siguiente desafío es interpretar '
            'información implícita, justificar tus respuestas con evidencias del texto, '
            'evaluar decisiones y construir opiniones fundamentadas.'),
        'recomendacion': (
            'Realiza actividades de inferencia, análisis de personajes, identificación de '
            'hechos y opiniones, y argumentación con evidencias textuales.'),
        'objetivo': 'Fortalecer argumentación, interpretación y evaluación de evidencias.',
    },
    {
        'clave': 'MAESTRO',
        'nombre': 'MAESTRO',
        'minimo': 90,
        'maximo': 100,
        'color': theme.VERDE,
        'retroalimentacion': (
            'Has demostrado un alto desempeño en esta evaluación. Ahora puedes profundizar '
            'en la interpretación, comparar perspectivas, evaluar críticamente las ideas y '
            'aplicar lo aprendido a nuevas situaciones. Recuerda que cada lectura presenta '
            'oportunidades para seguir desarrollándote.'),
        'recomendacion': (
            'Resuelve retos avanzados, compara interpretaciones, argumenta con evidencias y '
            'responde una nueva evaluación con preguntas diferentes para comprobar cómo '
            'aplicas tus habilidades.'),
        'objetivo': 'Profundizar el análisis, contrastar perspectivas y transferir aprendizajes.',
    },
]

HABILIDADES = {
    'literal': {
        'nombre': 'Localizar información',
        'color': theme.VERDE,
        'descripcion': 'Encuentra datos, personajes y hechos que el texto dice de forma explícita.',
    },
    'inferencial': {
        'nombre': 'Realizar inferencias',
        'color': theme.AZUL,
        'descripcion': 'Deduce lo que el texto no dice directamente usando las pistas del autor.',
    },
    'critica': {
        'nombre': 'Interpretar y evaluar el texto',
        'color': theme.NARANJA,
        'descripcion': 'Opina sobre el mensaje del texto y justifica tu postura con evidencias.',
    },
}


def clave_tipo(tipo):
    t = tipo.strip().lower()
    if t == 'literal':
        return 'literal'
    if t == 'inferencial':
        return 'inferencial'
    return 'critica'


def nivel_de(puntaje):
    for nivel in reversed(NIVELES):
        if puntaje >= nivel['minimo']:
            return nivel
    return NIVELES[0]


def por_clave(clave):
    for nivel in NIVELES:
        if nivel['clave'] == clave:
            return nivel
    return None


def indice(clave):
    for i, nivel in enumerate(NIVELES):
        if nivel['clave'] == clave:
            return i
    return -1


def siguiente_nivel(clave):
    i = indice(clave)
    if 0 <= i < len(NIVELES) - 1:
        return NIVELES[i + 1]
    return None


def puntos_para_siguiente(puntaje):
    siguiente = siguiente_nivel(nivel_de(puntaje)['clave'])
    if siguiente is None:
        return 0
    return max(siguiente['minimo'] - puntaje, 0)
