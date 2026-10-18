from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from kivy.app import App

MENSAJES = {30: 'Seleccionando texto aleatorio...',
            60: 'Calibrando niveles de NeuroFocus...',
            88: '¡Todo listo!'}


class SplashScreen(Screen):
    _prog = 0
    _ev = None
    _ev_inicio = None
    _ev_salida = None

    def on_enter(self):
        self._ev_inicio = Clock.schedule_once(self._start, 0.1)

    def on_leave(self):
        for ev in (self._ev_inicio, self._ev, self._ev_salida):
            if ev:
                ev.cancel()
        self._ev = self._ev_inicio = self._ev_salida = None

    def _start(self, dt):
        self._prog = 0
        self.ids.splash_bar.value = 0
        self.ids.splash_msg.text = 'Cargando módulos cognitivos...'
        if self._ev:
            self._ev.cancel()
        self._ev = Clock.schedule_interval(self._tick, 0.025)

    def _tick(self, dt):
        self._prog += 1
        self.ids.splash_bar.value = self._prog
        if self._prog in MENSAJES:
            self.ids.splash_msg.text = MENSAJES[self._prog]
        if self._prog >= 100:
            self._ev = None
            self._ev_salida = Clock.schedule_once(
                lambda dt: App.get_running_app().ir_a('login'), 0.4)
            return False
