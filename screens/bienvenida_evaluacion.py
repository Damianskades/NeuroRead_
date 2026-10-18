from kivy.uix.screenmanager import Screen
import session

TEXTOS = {
    'inicial': ('Evaluación inicial',
                'Esta evaluación de dificultad moderada mide tu punto de partida. '
                'Al terminar conocerás tu nivel.'),
    'clasificatoria': ('Evaluación clasificatoria',
                       'Demuestra lo que avanzaste. Tu nivel se actualizará según tu '
                       'nuevo puntaje.'),
}


class BienvenidaEvaluacionScreen(Screen):
    def on_enter(self):
        titulo, texto = TEXTOS.get(session.tipo_evaluacion, TEXTOS['inicial'])
        lectura = session.texto_activo['titulo'] if session.texto_activo else ''
        self.ids.home_eval_titulo.text = titulo
        self.ids.home_intro.text = texto
        self.ids.home_texto_titulo.text = f'Texto de hoy: {lectura}'
