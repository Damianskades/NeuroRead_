from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import FadeTransition
from kivy.core.window import Window
from kivy.metrics import dp

import widgets
import theme
from ui.kv_string import KV
from screens import (
    SplashScreen, LoginScreen, RegistroScreen, PrincipalScreen, PestanaScreen,
    InicioScreen, LibrosScreen, LibroDetalleScreen, LectorScreen, RutaScreen,
    ActividadScreen, EvaluacionScreen,
    BienvenidaEvaluacionScreen, VelocidadScreen, ComprensionScreen,
    InterpretacionScreen, ImaginacionScreen, ConcentracionScreen,
    RetencionScreen, ResultadosScreen, PerfilScreen, EditarPerfilScreen
)
from data.palabras_ricas import contar_riqueza
from data import db
import session

try:
    Window.size = (round(dp(390)), round(dp(844)))
except Exception:
    Window.size = (390, 844)
Window.clearcolor = theme.FONDO


class NeuroReadApp(App):
    title = 'NeuroRead'

    def build(self):
        db.respaldar_db()
        db.init_db()
        return Builder.load_string(KV)

    def login_entrar(self):
        self.root.get_screen('login').entrar()

    def cerrar_sesion(self):
        session.usuario = None
        session.session = session.nueva_sesion()
        self.ir_a('login')

    def ir_a(self, name):
        self.root.transition = FadeTransition(duration=0.28)
        self.root.current = name

    def ir_a_pestana(self, nombre):
        self.root.get_screen('principal').ir_a_pestana(nombre)
        self.ir_a('principal')

    def abrir_libro(self, libro_id):
        self.root.get_screen('principal').mostrar_libro(libro_id)
        self.ir_a('principal')

    def abrir_lector(self, libro_id, numero, origen='detalle'):
        self.root.get_screen('lector').abrir(libro_id, numero, origen)
        self.ir_a('lector')

    def abrir_actividad(self, actividad_id, origen='ruta'):
        self.root.get_screen('actividad').abrir(actividad_id, origen)
        self.ir_a('actividad')

    def vel_empezar(self):
        self.root.get_screen('velocidad').empezar()

    def vel_terminar(self):
        self.root.get_screen('velocidad').terminar()

    def inter_count(self, text):
        s = self.root.get_screen('interpretacion')
        n = len(text.split()) if text.strip() else 0
        s.ids.inter_count_lbl.text = f'{n} palabras'
        s.ids.inter_count_lbl.color = theme.VERDE if n >= 10 else theme.NARANJA

    def inter_siguiente(self):
        self.root.get_screen('interpretacion').siguiente()

    def imag_count(self, text):
        s = self.root.get_screen('imaginacion')
        words = len(text.split()) if text.strip() else 0
        r = contar_riqueza(text)
        s.ids.imag_count_lbl.text = f'{words} palabras'
        s.ids.imag_count_lbl.color = theme.VERDE if words >= 10 else theme.TURQUESA
        nivel = '--' if r == 0 else ('Básica' if r <= 2 else ('Media' if r <= 5 else 'Alta'))
        s.ids.imag_riqueza_lbl.text = f'Riqueza: {nivel}'

    def imag_guardar(self):
        self.root.get_screen('imaginacion').guardar()

    def conc_responder(self, es_si):
        self.root.get_screen('concentracion').responder(es_si)

    def conc_continuar(self):
        self.root.get_screen('concentracion').continuar()
