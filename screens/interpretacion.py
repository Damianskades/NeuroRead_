from kivy.uix.screenmanager import Screen
from kivy.app import App
from data.validacion import analizar_redaccion
import session
import theme


class InterpretacionScreen(Screen):
    _idx = _palabras_total = 0
    _puntaje = 0.0

    def on_enter(self):
        self._idx = self._palabras_total = 0
        self._puntaje = 0.0
        self._mostrar()

    def _preguntas(self):
        return session.texto_activo['interpretacion_q']

    def _mostrar(self):
        preguntas = self._preguntas()
        if self._idx >= len(preguntas):
            self._fin()
            return
        self.ids.inter_pregunta.text = preguntas[self._idx]
        self.ids.inter_bar.max = len(preguntas)
        self.ids.inter_bar.value = self._idx
        self.ids.inter_prog.text = f'Pregunta {self._idx + 1} de {len(preguntas)}'
        self.ids.inter_input.text = ''
        self.ids.inter_count_lbl.text = '0 palabras'
        self.ids.inter_count_lbl.color = theme.NARANJA

    def siguiente(self):
        texto = self.ids.inter_input.text
        ok, msg, palabras = analizar_redaccion(texto, min_palabras=10)
        if not ok:
            self.ids.inter_count_lbl.text = msg
            self.ids.inter_count_lbl.color = theme.ROJO
            return
        self._palabras_total += palabras
        self._puntaje += min(palabras / 30, 1.0)
        self._idx += 1
        self._mostrar()

    def _fin(self):
        n = len(self._preguntas())
        session.session['interpretacion']['puntaje'] = round((self._puntaje / n) * 100)
        session.session['interpretacion']['palabras_total'] = self._palabras_total
        App.get_running_app().ir_a('imaginacion')
