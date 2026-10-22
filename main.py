import os
import sys
import traceback

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


def arrancar():
    os.environ.setdefault('KIVY_METRICS_FONTSCALE', '1.15')
    ajustar_ventana_windows()
    from app import NeuroReadApp
    NeuroReadApp().run()


def mostrar_error(texto):
    from kivy.app import App
    from kivy.core.window import Window
    from kivy.graphics import Color, Rectangle
    from kivy.metrics import dp, sp
    from kivy.uix.boxlayout import BoxLayout
    from kivy.uix.button import Button
    from kivy.uix.label import Label
    from kivy.uix.scrollview import ScrollView
    from kivy.uix.textinput import TextInput
    from kivy.utils import get_color_from_hex as H

    fondo = H('#211A14')
    claro = H('#F2EAD9')
    dorado = H('#F5C84B')
    oscuro = H('#412402')

    def etiqueta(contenido, tamano, negrita):
        lbl = Label(text=contenido, font_size=sp(tamano), bold=negrita, color=claro,
                    halign='left', valign='top', size_hint_y=None)
        lbl.bind(width=lambda w, v: setattr(w, 'text_size', (v, None)),
                 texture_size=lambda w, v: setattr(w, 'height', v[1]))
        return lbl

    class ErrorApp(App):
        title = 'NeuroRead'

        def build(self):
            for hijo in list(Window.children):
                Window.remove_widget(hijo)
            if sys.platform == 'win32' and 'NEUROREAD_VENTANA' in os.environ:
                try:
                    w, h, x, y = (int(v) for v in os.environ['NEUROREAD_VENTANA'].split(','))
                    Window.size = (w, h)
                    Window.left, Window.top = x, y
                except Exception:
                    pass
            Window.clearcolor = fondo
            raiz = BoxLayout(orientation='vertical', padding=[dp(20), dp(28), dp(20), dp(20)],
                             spacing=dp(14))
            with raiz.canvas.before:
                Color(*fondo)
                caja = Rectangle()
            raiz.bind(pos=lambda w, v: setattr(caja, 'pos', v),
                      size=lambda w, v: setattr(caja, 'size', v))
            raiz.add_widget(etiqueta('NeuroRead no pudo iniciar', 26, True))
            raiz.add_widget(etiqueta('Copia este texto para revisar el problema.', 14, False))
            desplazable = ScrollView(do_scroll_x=False, bar_width=dp(6))
            campo = TextInput(text=texto, readonly=True, font_size=sp(14), size_hint_y=None,
                              background_normal='', background_active='',
                              background_color=fondo, foreground_color=claro,
                              cursor_color=claro, selection_color=H('#F5C84B66'),
                              padding=[0, 0, 0, 0])
            campo.bind(minimum_height=lambda w, v: setattr(w, 'height', v))
            desplazable.add_widget(campo)
            raiz.add_widget(desplazable)
            boton = Button(text='COPIAR ERROR', bold=True, font_size=sp(16), size_hint_y=None,
                           height=dp(52), background_normal='', background_down='',
                           background_color=dorado, color=oscuro)
            boton.bind(on_release=self.copiar)
            raiz.add_widget(boton)
            self.boton = boton
            return raiz

        def on_start(self):
            Window.bind(on_keyboard=self.tecla)

        def tecla(self, ventana, tecla, *args):
            if tecla == 27:
                self.stop()
                return True
            return False

        def copiar(self, *a):
            try:
                from kivy.core.clipboard import Clipboard
                Clipboard.copy(texto)
                self.boton.text = 'ERROR COPIADO'
            except Exception:
                self.boton.text = 'NO SE PUDO COPIAR'

    ErrorApp().run()


if __name__ == '__main__':
    try:
        arrancar()
    except Exception:
        error = traceback.format_exc()
        print(error, file=sys.stderr)
        try:
            mostrar_error(error)
        except Exception:
            traceback.print_exc()
