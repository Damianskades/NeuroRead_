import time
from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from kivy.app import App
import session

PPM_MAXIMO = 800


class VelocidadScreen(Screen):
    _ev = _t0 = None
    _run = False
    _ev_salida = None

    def on_enter(self):
        texto = session.texto_activo['texto'] if session.texto_activo else ''
        palabras = len(texto.split())
        self.ids.vel_texto_label.text = texto
        self.ids.vel_palabras.text = f'{palabras} palabras'
        self._preparar('Listo para leer')

    def on_leave(self):
        if self._ev:
            Clock.unschedule(self._ev)
            self._ev = None
        if self._ev_salida:
            self._ev_salida.cancel()
            self._ev_salida = None

    def _preparar(self, estado):
        if self._ev:
            Clock.unschedule(self._ev)
            self._ev = None
        self._run = False
        self._t0 = None
        self.ids.vel_timer.text = '0.0 s'
        self.ids.vel_estado.text = estado
        self.ids.vel_btn_start.disabled = False
        self.ids.vel_btn_start.opacity = 1.0
        self.ids.vel_btn_stop.disabled = True
        self.ids.vel_btn_stop.opacity = 0.35

    def empezar(self):
        self._t0 = time.time()
        self._run = True
        self.ids.vel_btn_start.disabled = True
        self.ids.vel_btn_start.opacity = 0.35
        self.ids.vel_btn_stop.disabled = False
        self.ids.vel_btn_stop.opacity = 1.0
        self.ids.vel_estado.text = 'Leyendo...'
        if self._ev:
            Clock.unschedule(self._ev)
        self._ev = Clock.schedule_interval(self._tick, 0.1)

    def _tick(self, dt):
        self.ids.vel_timer.text = f'{time.time() - self._t0:.1f} s'

    def terminar(self):
        if not self._run:
            return
        elapsed = max(time.time() - self._t0, 0.1)
        if self._ev:
            Clock.unschedule(self._ev)
        self._run = False
        word_count = len(session.texto_activo['texto'].split())
        wpm = round((word_count / elapsed) * 60)
        if wpm > PPM_MAXIMO:
            self._preparar('Lectura demasiado rápida. Vuelve a intentarlo '
                           'leyendo con atención.')
            return
        session.session['velocidad']['wpm'] = wpm
        session.session['velocidad']['tiempo_total'] = round(elapsed, 1)
        self.ids.vel_timer.text = f'{elapsed:.1f} s'
        self.ids.vel_estado.text = f'{wpm} PPM registradas'
        self._ev_salida = Clock.schedule_once(
            lambda dt: App.get_running_app().ir_a('comprension'), 1.4)
