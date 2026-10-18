from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from kivy.app import App
from screens.common import option_chip, marcar_opciones, mezclar_opciones, poner_texto
from data.niveles import clave_tipo
import session
import theme

TIPO_COLOR = {'Literal': theme.VERDE, 'Inferencial': theme.AZUL,
              'Crítica': theme.NARANJA, 'Critica': theme.NARANJA}


class ComprensionScreen(Screen):
    _idx = _correctas = _lit = _inf = _crit = 0
    _chips = []
    _ans = 0
    _ev = None

    def on_enter(self):
        self._idx = self._correctas = self._lit = self._inf = self._crit = 0
        self._mostrar()

    def on_leave(self):
        if self._ev:
            self._ev.cancel()
            self._ev = None

    def _preguntas(self):
        return session.texto_activo['comprension_q']

    def _mostrar(self):
        preguntas = self._preguntas()
        if self._idx >= len(preguntas):
            self._fin()
            return
        q = preguntas[self._idx]
        poner_texto(self.ids.comp_pregunta, q['q'])
        self.ids.comp_tipo.text = q['tipo'].upper()
        self.ids.comp_tipo.surface = TIPO_COLOR.get(q['tipo'], theme.VERDE)
        self.ids.comp_bar.max = len(preguntas)
        self.ids.comp_bar.value = self._idx
        self.ids.comp_prog.text = f'Pregunta {self._idx + 1} de {len(preguntas)}'
        self.ids.comp_feedback.text = ''
        box = self.ids.comp_opciones
        box.clear_widgets()
        self._chips = []
        opciones, self._ans = mezclar_opciones(q['opts'], q['ans'])
        for i, opt in enumerate(opciones):
            chip = option_chip(f'{chr(65 + i)})  {opt}',
                               lambda b, idx=i: self._responder(idx))
            self._chips.append(chip)
            box.add_widget(chip)

    def _responder(self, idx):
        q = self._preguntas()[self._idx]
        ok = (self._ans == idx)
        marcar_opciones(self._chips, idx, self._ans)
        if ok:
            self._correctas += 1
            t = clave_tipo(q['tipo'])
            if t == 'literal':
                self._lit += 1
            elif t == 'inferencial':
                self._inf += 1
            else:
                self._crit += 1
            self.ids.comp_feedback.text = '¡Correcto!'
            self.ids.comp_feedback.color = theme.VERDE
        else:
            self.ids.comp_feedback.text = 'Incorrecto, observa la respuesta en verde'
            self.ids.comp_feedback.color = theme.ROJO
        self._idx += 1
        self._ev = Clock.schedule_once(lambda dt: self._mostrar(), 1.4)

    def _fin(self):
        session.registrar_comprension(self._correctas, {
            'literal': self._lit, 'inferencial': self._inf, 'critica': self._crit})
        self.ids.comp_bar.value = len(self._preguntas())
        App.get_running_app().ir_a('interpretacion')
