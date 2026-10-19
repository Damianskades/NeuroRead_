import random
import re
from datetime import date
from kivy.uix.label import Label
from kivy.metrics import dp, sp
from widgets import NeoChip
import theme

DIAS = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
MESES = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto',
         'septiembre', 'octubre', 'noviembre', 'diciembre']


def fecha_larga(d):
    return f'{DIAS[d.weekday()]}, {d.day} de {MESES[d.month - 1]}'


def fecha_corta(iso):
    d = date.fromisoformat(iso[:10])
    return f'{d.day} de {MESES[d.month - 1]}'


def plural(n, singular, varios):
    return f'{n} {singular if n == 1 else varios}'


ESCALA_PORCENTAJE = 0.9
_MARCAS_PORCENTAJE = re.compile(r'\[size=([0-9.]+)\]|\[/size\]|%')


def porcentaje(texto, tamano=None):
    partes = []
    tamanos = []
    inicio = 0
    for m in _MARCAS_PORCENTAJE.finditer(texto):
        partes.append(texto[inicio:m.start()])
        inicio = m.end()
        marca = m.group(0)
        if marca != '%':
            if m.group(1):
                tamanos.append(float(m.group(1)))
            elif tamanos:
                tamanos.pop()
            partes.append(marca)
            continue
        abrir, cerrar = f'[font={theme.F_PORCENTAJE}]', '[/font]'
        if theme.PORCENTAJE_RESPALDO:
            abrir, cerrar = abrir + '[b]', '[/b]' + cerrar
        else:
            base = tamanos[-1] if tamanos else tamano
            if base:
                abrir, cerrar = abrir + f'[size={round(base * ESCALA_PORCENTAJE)}]', '[/size]' + cerrar
        partes.append(abrir + '%' + cerrar)
    partes.append(texto[inicio:])
    return ''.join(partes)


def poner_texto(etiqueta, texto):
    etiqueta.markup = True
    etiqueta.text = porcentaje(texto, etiqueta.font_size)


def mezclar_opciones(opts, ans):
    orden = list(range(len(opts)))
    random.shuffle(orden)
    return [opts[i] for i in orden], orden.index(ans)


def option_chip(texto, on_press):
    chip = NeoChip(
        text=texto, font_size='13.5sp', halign='left', valign='middle',
        font_name=theme.F_DISPLAY, bold=True,
        size_hint_y=None, height=dp(56),
        surface=theme.TARJETA_ALT, color=theme.TEXTO,
        padding=[dp(16), dp(12)],
    )
    chip.bind(width=lambda c, w: setattr(c, 'text_size', (w - dp(32), None)))
    chip.bind(texture_size=lambda c, ts:
              setattr(c, 'height', max(dp(56), ts[1] + dp(24))))
    chip.bind(on_press=on_press)
    return chip


def marcar_opciones(chips, elegido, correcto):
    for i, chip in enumerate(chips):
        chip.disabled = True
        if i == correcto:
            chip.surface = theme.VERDE
            chip.color = theme.TEXTO_OSCURO
            chip.bold = True
        elif i == elegido:
            chip.surface = theme.ROJO
            chip.color = theme.TEXTO
            chip.bold = True


def wrap_label(texto, font_size='13sp', color=None, bold=False, halign='left'):
    lbl = Label(
        text=texto, font_size=font_size,
        color=color or theme.TEXTO,
        halign=halign, valign='top',
        size_hint_y=None,
    )
    negrita = bold or lbl.font_size < sp(14)
    lbl.font_name = theme.F_DISPLAY if negrita else theme.F_BODY
    lbl.bold = negrita
    lbl.bind(width=lambda l, w: setattr(l, 'text_size', (w, None)))
    lbl.bind(texture_size=lambda l, ts: setattr(l, 'height', ts[1]))
    return lbl


def ajustar_alto(caja):
    caja.size_hint_y = None
    caja.bind(minimum_height=caja.setter('height'))
    return caja


def insignia_diferencia(d):
    puntos = 'PUNTO' if abs(d) == 1 else 'PUNTOS'
    if d > 0:
        return f'SUBISTE {d} {puntos}', theme.VERDE, theme.TEXTO_OSCURO
    if d < 0:
        return f'BAJASTE {-d} {puntos}', theme.ROJO, theme.TEXTO
    return 'SIN CAMBIOS', theme.TARJETA_ALT, theme.TEXTO
