from kivy.uix.screenmanager import Screen
from kivy.uix.widget import Widget
from kivy.clock import Clock
from kivy.app import App
from kivy.graphics import (Color, Rectangle, RoundedRectangle, StencilPush, StencilUse,
                           StencilUnUse, StencilPop)
from kivy.metrics import dp
from kivy.properties import NumericProperty
from screens.logos import fotograma, SALIDA, MAX_PASO
import theme

DURACION = 5.6
LOGOS_DE_PASO = [('splash_libro', 0.0), ('splash_ojo', 1.0), ('splash_subrayado', 2.0),
                 ('splash_nota', 3.0)]
PASAR_OPACIDAD = [(0, 0), (0.3, 1), (0.72, 1), (1.0, 0)]
PASAR_ESCALA = [(0, 0.2), (0.3, 1.05), (0.42, 1), (0.72, 1), (1.0, 0.2)]
LLEGADA = 3.96
LLEGAR_OPACIDAD = [(0, 0), (0.36, 1)]
LLEGAR_ESCALA = [(0, 0.2), (0.36, 1.1), (0.6, 1)]
NOMBRE_INICIO = 4.44
NOMBRE_DURACION = 0.48
NOMBRE_SUBIDA = 10


class BarraCarga(Widget):
    progreso = NumericProperty(0)

    def __init__(self, **kw):
        super().__init__(**kw)
        self.bind(pos=self._dibujar, size=self._dibujar, progreso=self._llenar)
        self._dibujar()

    def _interior(self):
        borde = dp(2)
        return self.x + borde, self.y + borde, self.width - 2 * borde, self.height - 2 * borde

    def _dibujar(self, *a):
        self.canvas.clear()
        x, y, w, h = self._interior()
        with self.canvas:
            Color(*theme.BORDE)
            RoundedRectangle(pos=self.pos, size=self.size, radius=[dp(6)])
            Color(*theme.TARJETA_ALT)
            RoundedRectangle(pos=(x, y), size=(w, h), radius=[dp(4)])
            StencilPush()
            RoundedRectangle(pos=(x, y), size=(w, h), radius=[dp(4)])
            StencilUse()
            Color(*theme.DORADO)
            self._relleno = Rectangle(pos=(x, y), size=(0, h))
            StencilUnUse()
            RoundedRectangle(pos=(x, y), size=(w, h), radius=[dp(4)])
            StencilPop()
        self._llenar()

    def _llenar(self, *a):
        x, y, w, h = self._interior()
        self._relleno.size = (w * min(max(self.progreso, 0), 1), h)


class SplashScreen(Screen):
    _t = 0.0
    _ev = None
    _ev_inicio = None
    _terminado = False

    def on_enter(self):
        self._t = 0.0
        self._terminado = False
        self._detener_reloj()
        self._ev_inicio = Clock.schedule_once(self._comenzar, 0)

    def _comenzar(self, dt):
        self._ev_inicio = None
        self._pintar()
        self._ev = Clock.schedule_interval(self._avanzar, 0)

    def _detener_reloj(self):
        for ev in (self._ev_inicio, self._ev):
            if ev is not None:
                ev.cancel()
        self._ev_inicio = self._ev = None

    def on_leave(self):
        self._detener_reloj()
        for logo in self._logos():
            logo.detener()

    def on_touch_down(self, touch):
        if self.collide_point(*touch.pos) and not self._terminado and 'splash_n' in self.ids:
            self._t = DURACION
            self._pintar()
            self._salir()
        return True

    def _logos(self):
        ids = self.ids
        return [ids.splash_libro, ids.splash_ojo, ids.splash_subrayado, ids.splash_nota,
                ids.splash_n]

    def _avanzar(self, dt):
        self._t += min(dt, MAX_PASO)
        self._pintar()
        if self._t >= DURACION:
            self._salir()

    def _salir(self):
        if self._terminado:
            return
        self._terminado = True
        self._detener_reloj()
        App.get_running_app().ir_a('login')

    def _mostrar(self, logo, opacidad, escala):
        logo.opacity = opacidad
        logo.escala = escala
        if opacidad > 0 and not logo.animando():
            logo.iniciar(self._t)
        elif opacidad <= 0 and logo.animando():
            logo.detener()

    def _pintar(self):
        t = self._t
        ids = self.ids
        for nombre, inicio in LOGOS_DE_PASO:
            local = t - inicio
            if 0 <= local <= 1.0:
                self._mostrar(ids[nombre], fotograma(PASAR_OPACIDAD, local),
                              fotograma(PASAR_ESCALA, local))
            else:
                self._mostrar(ids[nombre], 0, 0.2)
        local = t - LLEGADA
        if local >= 0:
            self._mostrar(ids.splash_n, fotograma(LLEGAR_OPACIDAD, local, SALIDA),
                          fotograma(LLEGAR_ESCALA, local, SALIDA))
        else:
            self._mostrar(ids.splash_n, 0, 0.2)
        avance = SALIDA(min(max((t - NOMBRE_INICIO) / NOMBRE_DURACION, 0), 1))
        for etiqueta in (ids.splash_nombre, ids.splash_lema):
            etiqueta.opacity = avance
            etiqueta.desfase = -dp(NOMBRE_SUBIDA) * (1 - avance)
        ids.splash_barra.progreso = min(t / DURACION, 1)
