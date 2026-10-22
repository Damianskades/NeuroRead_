import re
from collections import Counter


def _tokens(texto):
    return re.findall(r"[a-záéíóúüñ]+", texto.lower())


def contar_palabras(texto):
    return len(_tokens(texto))


def analizar_redaccion(texto, min_palabras=10):
    tokens = _tokens(texto)
    total = len(tokens)
    if total == 0:
        return False, 'Escribe tu respuesta para continuar.', 0
    if total < min_palabras:
        return False, f'Escribe al menos {min_palabras} palabras ({total} escritas).', total
    unicas = set(tokens)
    ratio = len(unicas) / total
    palabra, repes = Counter(tokens).most_common(1)[0]
    if repes > max(4, int(total * 0.30)):
        return False, f'Repites demasiado la palabra {palabra}. Usa vocabulario variado.', total
    if ratio < 0.50:
        return False, 'Tu texto repite muchas palabras. Desarrolla ideas nuevas.', total
    bigrams = list(zip(tokens, tokens[1:]))
    if bigrams:
        frase, veces = Counter(bigrams).most_common(1)[0]
        if veces >= 3:
            return False, 'No repitas la misma frase. Expresa ideas diferentes.', total
    cortas = sum(1 for t in tokens if len(t) <= 2)
    if cortas / total > 0.55:
        return False, 'Usa palabras completas y oraciones con sentido.', total
    return True, '', total
