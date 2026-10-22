from kivy.uix.screenmanager import Screen
from kivy.app import App
from data.palabras_ricas import contar_riqueza
from data.validacion import analizar_redaccion
from screens.common import actualizar_contador, mostrar_aviso
import session

MIN_PALABRAS = 10


class ImaginacionScreen(Screen):
    def on_enter(self):
        self.ids.imag_input.text = ''
        mostrar_aviso(self.ids.imag_aviso, '')
        self.contar('')

    def contar(self, texto):
        actualizar_contador(self.ids.imag_count_lbl, texto, MIN_PALABRAS)
        r = contar_riqueza(texto)
        nivel = '--' if r == 0 else ('Básica' if r <= 2 else ('Media' if r <= 5 else 'Alta'))
        self.ids.imag_riqueza_lbl.text = f'Riqueza: {nivel}'

    def guardar(self):
        texto = self.ids.imag_input.text
        ok, msg, palabras = analizar_redaccion(texto, min_palabras=MIN_PALABRAS)
        if not ok:
            mostrar_aviso(self.ids.imag_aviso, msg)
            return
        riqueza = contar_riqueza(texto)
        puntaje = round(((min(palabras / 80, 1) + min(riqueza / 8, 1)) / 2) * 100)
        session.session['imaginacion'].update(
            {'puntaje': puntaje, 'palabras': palabras, 'riqueza': riqueza})
        App.get_running_app().ir_a('concentracion')
