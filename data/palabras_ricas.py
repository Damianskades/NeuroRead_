import re
import unicodedata

PALABRAS_RICAS = [
    'color', 'luz', 'sombra', 'sonido', 'aroma', 'textura', 'calor', 'frío',
    'olor', 'sabor', 'tacto', 'ruido', 'brillo', 'oscuridad', 'humedad',
    'verde', 'azul', 'dorado', 'oscuro', 'brillante', 'suave', 'rugoso',
    'enorme', 'diminuto', 'transparente', 'opaco', 'luminoso', 'tenue',
    'silencio', 'murmullo', 'susurro', 'estruendo', 'melodía', 'eco',
    'crujido', 'zumbido', 'trueno', 'canto', 'lamento',
    'imaginé', 'visualicé', 'sentí', 'escuché', 'vi', 'percibí',
    'observé', 'contemplé', 'noté', 'vislumbré', 'distinguí',
    'probablemente', 'quizás', 'hipótesis', 'creo', 'pienso', 'supongo',
    'tal vez', 'imagino', 'posiblemente', 'a lo mejor',
    'pudiera', 'podría', 'debería', 'sería', 'parece',
    'tristeza', 'alegría', 'nostalgia', 'esperanza', 'miedo', 'ternura',
    'angustia', 'paz', 'inquietud', 'asombro', 'admiración', 'melancolía',
]


def _normalizar(texto):
    n = unicodedata.normalize('NFD', texto.lower())
    return ''.join(c for c in n if unicodedata.category(c) != 'Mn')


def _palabras(texto):
    return re.findall(r'[a-z0-9]+', _normalizar(texto))


_RICAS = [' '.join(_palabras(w)) for w in PALABRAS_RICAS]


def contar_riqueza(texto):
    tokens = _palabras(texto)
    unicas = set(tokens)
    frase = ' ' + ' '.join(tokens) + ' '
    total = 0
    for w in _RICAS:
        if ' ' in w:
            if f' {w} ' in frase:
                total += 1
        elif w in unicas:
            total += 1
    return total
