from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from kivy.app import App
from kivy.metrics import dp
from screens.common import option_chip, marcar_opciones, mezclar_opciones, poner_texto
import session
import theme


class RetencionScreen(Screen):
    _idx = _ok = _countdown = 0
    _ev = None
    _ev_siguiente = None
    _chips = []
    _ans = 0

    def on_enter(self):
        self._idx = self._ok = 0
        self._countdown = 30
        self.ids.ret_countdown.text = '30'
        self.ids.ret_prog.text = 'Preparando test de memoria...'
        self.ids.ret_wait_card.opacity = 1
        self.ids.ret_wait_card.height = dp(196)
        self.ids.ret_q_card.opacity = 0
        self.ids.ret_opts_box.opacity = 0
        self.ids.ret_opts_box.clear_widgets()
        self.ids.ret_feedback.text = ''
        if self._ev:
            Clock.unschedule(self._ev)
        self._ev = Clock.schedule_interval(self._tick, 1.0)

    def on_leave(self):
        if self._ev:
            Clock.unschedule(self._ev)
            self._ev = None
        if self._ev_siguiente:
            self._ev_siguiente.cancel()
            self._ev_siguiente = None

    def _preguntas(self):
        return session.texto_activo['retencion_q']

    def _tick(self, dt):
        self._countdown -= 1
        self.ids.ret_countdown.text = str(self._countdown)
        if self._countdown <= 0:
            Clock.unschedule(self._ev)
            self._iniciar()

    def _iniciar(self):
        self.ids.ret_wait_card.opacity = 0
        self.ids.ret_wait_card.size_hint_y = None
        self.ids.ret_wait_card.height = 0
        self.ids.ret_q_card.opacity = 1
        self.ids.ret_opts_box.opacity = 1
        self._mostrar()

    def _mostrar(self):
        preguntas = self._preguntas()
        if self._idx >= len(preguntas):
            self._fin()
            return
        q = preguntas[self._idx]
        poner_texto(self.ids.ret_pregunta, q['q'])
        self.ids.ret_bar.max = len(preguntas)
        self.ids.ret_bar.value = self._idx
        self.ids.ret_prog.text = f'Pregunta {self._idx + 1} de {len(preguntas)}'
        self.ids.ret_feedback.text = ''
        box = self.ids.ret_opts_box
        box.clear_widgets()
        self._chips = []
        opciones, self._ans = mezclar_opciones(q['opts'], q['ans'])
        for i, opt in enumerate(opciones):
            chip = option_chip(f'{chr(65 + i)})  {opt}',
                               lambda b, idx=i: self._responder(idx))
            self._chips.append(chip)
            box.add_widget(chip)

    def _responder(self, idx):
        ok = (self._ans == idx)
        marcar_opciones(self._chips, idx, self._ans)
        if ok:
            self._ok += 1
            self.ids.ret_feedback.text = '¡Correcto!'
            self.ids.ret_feedback.color = theme.VERDE
        else:
            self.ids.ret_feedback.text = 'Incorrecto, la respuesta correcta está en verde'
            self.ids.ret_feedback.color = theme.ROJO
        self._idx += 1
        self._ev_siguiente = Clock.schedule_once(lambda dt: self._mostrar(), 1.4)

    def _fin(self):
        session.session['retencion']['correctas'] = self._ok
        self.ids.ret_bar.value = len(self._preguntas())
        App.get_running_app().ir_a('resultados')
