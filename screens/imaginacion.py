from kivy.uix.screenmanager import Screen
from kivy.app import App
from data.palabras_ricas import contar_riqueza
from data.validacion import analizar_redaccion
import session
import theme


class ImaginacionScreen(Screen):
    def on_enter(self):
        self.ids.imag_input.text = ''
        self.ids.imag_count_lbl.text = '0 palabras'
        self.ids.imag_count_lbl.color = theme.TURQUESA
        self.ids.imag_riqueza_lbl.text = 'Riqueza: --'

    def guardar(self):
        texto = self.ids.imag_input.text
        ok, msg, palabras = analizar_redaccion(texto, min_palabras=10)
        if not ok:
            self.ids.imag_count_lbl.text = msg
            self.ids.imag_count_lbl.color = theme.ROJO
            return
        riqueza = contar_riqueza(texto)
        puntaje = round(((min(palabras / 80, 1) + min(riqueza / 8, 1)) / 2) * 100)
        session.session['imaginacion'].update(
            {'puntaje': puntaje, 'palabras': palabras, 'riqueza': riqueza})
        App.get_running_app().ir_a('concentracion')
