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
        'tiempo': 7,
        'color': theme.VERDE,
    },
    {
        'clave': 'NORMAL',
        'nombre': 'NIVEL NORMAL',
        'regla': 'Toca SÍ cuando la palabra sea un COLOR',
        'si': 'SÍ, ES COLOR',
        'no': 'NO ES',
        'tiempo': 7,
        'color': theme.DORADO,
    },
    {
        'clave': 'DIFICIL',
        'nombre': 'NIVEL DIFÍCIL',
        'regla': 'Toca SÍ cuando la palabra esté escrita CORRECTAMENTE',
        'si': 'SÍ, CORRECTA',
        'no': 'TIENE ERROR',
        'tiempo': 6,
        'color': theme.NARANJA,
    },
    {
        'clave': 'ULTRA',
        'nombre': 'NEUROULTRA',
        'regla': 'Toca SÍ solo si la palabra pertenece a la LECTURA de hoy',
        'si': 'SÍ, APARECE',
        'no': 'NO APARECE',
        'tiempo': 2,
        'color': theme.ROJO,
    },
]

PALABRAS_POR_NIVEL = 6
EVALUACIONES_SIN_REPETIR = 3

BANCOS = {
    'FACIL': {
        'si': [
            'Delfín', 'Colibrí', 'Ballena', 'Tortuga', 'Elefante', 'Ardilla', 'Conejo', 'Pingüino',
            'Búho', 'Loro', 'Tiburón', 'Hormiga', 'Abeja', 'Rana', 'Sapo', 'Caracol', 'Tucán',
            'Pelícano', 'Gaviota', 'Halcón', 'Cóndor', 'Vicuña', 'Armadillo', 'Mapache', 'Nutria',
            'Castor', 'Erizo', 'Hiena', 'Leopardo', 'Guepardo', 'Chimpancé', 'Gorila', 'Avestruz',
            'Escorpión', 'Cangrejo', 'Ciervo', 'Cisne', 'Grillo', 'Mosquito', 'Lombriz', 'Tapir',
            'Koala', 'Hipopótamo', 'Rinoceronte', 'Lagartija', 'Iguana', 'Lobo', 'Oso',
        ],
        'no': [
            'Orquídea', 'Montaña', 'Relámpago', 'Girasol', 'Roble', 'Cactus', 'Helecho', 'Bambú',
            'Tulipán', 'Pino', 'Cedro', 'Sauce', 'Musgo', 'Trigo', 'Volcán', 'Glaciar', 'Desierto',
            'Bosque', 'Playa', 'Isla', 'Río', 'Lago', 'Cascada', 'Valle', 'Pradera', 'Tormenta',
            'Arcoíris', 'Niebla', 'Huracán', 'Terremoto', 'Eclipse', 'Brújula', 'Lámpara', 'Mochila',
            'Tijeras', 'Escalera', 'Paraguas', 'Martillo', 'Linterna', 'Botella', 'Guitarra',
            'Castillo', 'Museo', 'Mercado', 'Faro', 'Plaza',
        ],
    },
    'NORMAL': {
        'si': [
            'Rojo', 'Azul', 'Verde', 'Amarillo', 'Negro', 'Blanco', 'Gris', 'Morado', 'Púrpura',
            'Marrón', 'Celeste', 'Magenta', 'Cian', 'Carmesí', 'Escarlata', 'Beige', 'Bermejo',
            'Pardo', 'Cárdeno', 'Rojizo', 'Azulado', 'Verdoso', 'Amarillento', 'Grisáceo',
            'Blanquecino', 'Negruzco', 'Azul marino', 'Verde claro', 'Gris oscuro', 'Azul cielo',
            'Rojo oscuro', 'Verde oscuro', 'Azul claro',
        ],
        'no': [
            'Trueno', 'Granizo', 'Nube', 'Viento', 'Brisa', 'Escuela', 'Cuchara', 'Tenedor',
            'Cortina', 'Teclado', 'Ventana', 'Puerta', 'Camino', 'Ciudad', 'Pueblo', 'Mesa', 'Silla',
            'Reloj', 'Espejo', 'Llave', 'Cuerda', 'Sombrero', 'Zapatilla', 'Pelota', 'Bandera',
            'Periódico', 'Carta', 'Libro', 'Tren', 'Barco', 'Cohete', 'Planeta', 'Estrella', 'Luna',
            'Trompeta', 'Violín', 'Tambor', 'Domingo', 'Verano', 'Invierno', 'Martes', 'Hospital',
            'Estadio',
        ],
    },
    'DIFICIL': {
        'si': [
            'Esperanza', 'Concentración', 'Vocabulario', 'Bicicleta', 'Gobierno', 'Excursión',
            'Herramienta', 'Exhibición', 'Vehículo', 'Hipótesis', 'Conciencia', 'Ejército',
            'Geografía', 'Biología', 'Jengibre', 'Hierba', 'Llovizna', 'Ayuntamiento', 'Cerebro',
            'Ciudadano', 'Cocinero', 'Desarrollo', 'Escalofrío', 'Explosión', 'Garabato',
            'Helicóptero', 'Horizonte', 'Inteligencia', 'Lenguaje', 'Majestuoso', 'Nostalgia',
            'Obstáculo', 'Proyecto', 'Silencio', 'Tecnología', 'Universidad', 'Valiente',
            'Zanahoria', 'Adolescente', 'Bienvenido', 'Columpio', 'Avellana',
        ],
        'no': [
            'Bibloteca', 'Imajinación', 'Exelente', 'Abión', 'Berdad', 'Nuve', 'Cavallo', 'Uevo',
            'Ielo', 'Aorro', 'Ormiga', 'Holer', 'Ermano', 'Almoada', 'Sapato', 'Ceresa', 'Cosina',
            'Pasiencia', 'Lápis', 'Asúcar', 'Siencia', 'Felisidad', 'Naris', 'Garage', 'Mensage',
            'Viage', 'Jeneral', 'Jigante', 'Extrangero', 'Yuvia', 'Ceboya', 'Caye', 'Pallaso',
            'Desalluno', 'Mounstro', 'Poblema', 'Instrución', 'Dicionario', 'Construción',
            'Bivir', 'Volígrafo', 'Escrivir', 'Becino', 'Uella',
        ],
    },
}


def elegir_items(clave, usadas, rng=random):
    banco = BANCOS[clave]
    propias = [u for u in usadas if u['nivel'] == clave]
    fechas = sorted({u['fecha'] for u in usadas}, reverse=True)[:EVALUACIONES_SIN_REPETIR]
    recientes = {u['palabra'] for u in propias if u['fecha'] in fechas}
    ultimo_uso = {}
    for u in propias:
        ultimo_uso[u['palabra']] = max(ultimo_uso.get(u['palabra'], ''), u['fecha'])

    def tomar(lista, cantidad):
        libres = [p for p in lista if p not in recientes]
        rng.shuffle(libres)
        repetidas = sorted((p for p in lista if p in recientes), key=lambda p: ultimo_uso.get(p, ''))
        return (libres + repetidas)[:cantidad]

    correctas = rng.choice((3, 4))
    items = [{'palabra': p, 'ok': True} for p in tomar(banco['si'], correctas)]
    items += [{'palabra': p, 'ok': False} for p in tomar(banco['no'], PALABRAS_POR_NIVEL - correctas)]
    rng.shuffle(items)
    return items


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
