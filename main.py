import os
import sys

ANCHO_DISENO = 390
ALTO_DISENO = 844
BARRA_TITULO = 40
DENSIDAD_MINIMA = 0.75
DENSIDAD_MAXIMA = 3


def medidas_ventana(area):
    izquierda, arriba, ancho, alto = area
    densidad = (alto * 0.9 - BARRA_TITULO) / ALTO_DISENO
    densidad = min(densidad, ancho * 0.9 / ANCHO_DISENO)
    densidad = round(min(max(densidad, DENSIDAD_MINIMA), DENSIDAD_MAXIMA), 4)
    w, h = round(ANCHO_DISENO * densidad), round(ALTO_DISENO * densidad)
    x = izquierda + max((ancho - w) // 2, 0)
    y = arriba + max((alto - h - BARRA_TITULO) // 2, 0) + BARRA_TITULO
    return densidad, w, h, x, y


def _area_trabajo(ctypes):
    rect = (ctypes.c_long * 4)()
    if not ctypes.windll.user32.SystemParametersInfoW(48, 0, ctypes.byref(rect), 0):
        raise OSError
    izquierda, arriba, derecha, abajo = rect
    return izquierda, arriba, derecha - izquierda, abajo - arriba


def _factor_windows(ctypes):
    try:
        dpi = ctypes.windll.user32.GetDpiForSystem()
    except Exception:
        hdc = ctypes.windll.user32.GetDC(0)
        dpi = ctypes.windll.gdi32.GetDeviceCaps(hdc, 88)
        ctypes.windll.user32.ReleaseDC(0, hdc)
    return round(dpi / 96, 2) if dpi else 0


def ajustar_ventana_windows():
    if sys.platform != 'win32':
        return
    try:
        import ctypes
        try:
            if ctypes.windll.shcore.SetProcessDpiAwareness(2) not in (0, -2147024891):
                raise OSError
        except Exception:
            ctypes.windll.user32.SetProcessDPIAware()
        try:
            densidad, w, h, x, y = medidas_ventana(_area_trabajo(ctypes))
            os.environ['KIVY_METRICS_DENSITY'] = str(densidad)
            os.environ['NEUROREAD_VENTANA'] = f'{w},{h},{x},{y}'
        except Exception:
            factor = _factor_windows(ctypes)
            if factor > 0:
                os.environ['KIVY_METRICS_DENSITY'] = str(factor)
    except Exception:
        pass


os.environ.setdefault('KIVY_METRICS_FONTSCALE', '1.15')
ajustar_ventana_windows()

from app import NeuroReadApp

if __name__ == '__main__':
    NeuroReadApp().run()
