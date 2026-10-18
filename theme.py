import os
from kivy.utils import get_color_from_hex as H
from kivy.core.text import LabelBase

FONDO        = H('#211A14')
TARJETA      = H('#2E251D')
TARJETA_ALT  = H('#3A2F25')
BORDE        = H('#000000')

TEXTO        = H('#F2EAD9')
TEXTO_SEC    = H('#CFC4AC')
TEXTO_OSCURO = H('#412402')

DORADO       = H('#F5C84B')
VERDE        = H('#A4CE4E')
TURQUESA     = H('#2DD4BF')
AZUL         = H('#4A90D9')
NARANJA      = H('#F7941D')
MARINO       = H('#1B4F8C')
VIOLETA      = H('#B39DFF')
ROJO         = H('#E85C4A')

TRANSPARENTE = [0, 0, 0, 0]
VELO         = [0, 0, 0, 0.6]

MODULE_COLORS = {
    'velocidad':      DORADO,
    'comprension':    VERDE,
    'interpretacion': AZUL,
    'imaginacion':    TURQUESA,
    'concentracion':  NARANJA,
    'retencion':      VIOLETA,
    'resultados':     MARINO,
}

MODULE_COLORS_CODE = {
    'VEL': DORADO, 'COM': VERDE, 'INT': AZUL,
    'IMA': TURQUESA, 'CON': NARANJA, 'RET': VIOLETA,
}

_BASE = os.path.dirname(os.path.abspath(__file__))
_CARPETAS = [
    os.path.join(_BASE, 'assets', 'fonts'),
    'C:/Windows/Fonts',
    os.path.join(os.environ.get('LOCALAPPDATA', ''), 'Microsoft', 'Windows', 'Fonts'),
]

F_DISPLAY = 'Roboto'
F_BODY = 'Roboto'


def _buscar(nombre):
    for carpeta in _CARPETAS:
        for candidato in (nombre, nombre.lower()):
            ruta = os.path.join(carpeta, candidato)
            if os.path.isfile(ruta):
                return ruta
    return None


_gothic_reg = _buscar('GOTHIC.TTF')
_gothic_bold = _buscar('GOTHICB.TTF')

try:
    if _gothic_bold:
        LabelBase.register(name='NeoDisplay', fn_regular=_gothic_bold)
        F_DISPLAY = 'NeoDisplay'
    if _gothic_reg:
        LabelBase.register(name='NeoBody', fn_regular=_gothic_reg,
                           fn_bold=_gothic_bold or _gothic_reg)
        F_BODY = 'NeoBody'
except Exception:
    F_DISPLAY = 'Roboto'
    F_BODY = 'Roboto'


HINTING = 'normal'


def textura_nitida(textura):
    if textura is not None:
        textura.mag_filter = 'nearest'
        textura.min_filter = 'nearest'


def oscuro(color, factor=0.35):
    return [color[0] * factor, color[1] * factor, color[2] * factor, 1]
