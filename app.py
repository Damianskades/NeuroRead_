import os
from kivy.utils import platform
from kivy.config import Config
if platform == 'win':
    Config.set('graphics', 'resizable', False)

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import FadeTransition
from kivy.core.window import Window
from kivy.metrics import dp

import widgets
import theme
from ui.kv_string import KV
from screens import (
    SplashScreen, LoginScreen, RegistroScreen, PrincipalScreen,
    InicioScreen, LibrosScreen, LibroDetalleScreen, LectorScreen, RutaScreen,
    ActividadScreen, EvaluacionScreen,
    BienvenidaEvaluacionScreen, VelocidadScreen, ComprensionScreen,
    InterpretacionScreen, ImaginacionScreen, ConcentracionScreen,
    RetencionScreen, ResultadosScreen, PerfilScreen, EditarPerfilScreen
)
from screens.common import ModalSalir
from data.palabras_ricas import contar_riqueza
from data import db
import session

PANTALLAS_EVALUACION = {'splash', 'bienvenida_evaluacion', 'velocidad', 'comprension',
                        'interpretacion', 'imaginacion', 'concentracion', 'retencion'}


def ajustar_ventana():
    try:
        w, h, x, y = (int(v) for v in os.environ['NEUROREAD_VENTANA'].split(','))
        Window.size = (w, h)
        Window.left = x
        Window.top = y
    except Exception:
        try:
            Window.size = (round(dp(390)), round(dp(844)))
        except Exception:
            Window.size = (390, 844)


if platform == 'win':
    ajustar_ventana()
Window.clearcolor = theme.FONDO


class NeuroReadApp(App):
    title = 'NeuroRead'

    _modal_salir = None

    def build(self):
        db.respaldar_db()
        db.init_db()
        return Builder.load_string(KV)

    def on_start(self):
        if platform == 'android':
            Window.softinput_mode = 'below_target'
            Window.bind(on_keyboard=self.tecla)

    def on_pause(self):
        pantalla = self.root.current_screen if self.root else None
        if hasattr(pantalla, 'al_pausar'):
            pantalla.al_pausar()
        return True

    def on_resume(self):
        pass

    def tecla(self, ventana, tecla, *args):
        if tecla != 27:
            return False
        self.atras()
        return True

    def atras(self):
        if self._modal_salir is not None:
            self._modal_salir.dismiss()
            return
        actual = self.root.current
        if actual in ('login', 'registro'):
            self.stop()
        elif actual in PANTALLAS_EVALUACION:
            return
        elif actual in ('lector', 'actividad'):
            self.root.get_screen(actual).volver()
        elif actual == 'editar_perfil':
            self.root.get_screen(actual).cancelar()
        elif actual == 'resultados':
            self.root.get_screen(actual).salir()
        elif actual == 'principal':
            interna = self.root.get_screen('principal').ids.principal_sm
            if interna.current == 'libro_detalle':
                interna.get_screen('libro_detalle').volver()
            elif interna.current != 'inicio':
                self.ir_a_pestana('inicio')
            else:
                self._preguntar_salida()

    def _preguntar_salida(self):
        modal = ModalSalir(self.stop)
        modal.bind(on_dismiss=lambda *a: setattr(self, '_modal_salir', None))
        self._modal_salir = modal
        modal.open()

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

    def abrir_neuroscore(self, sesion_id, origen):
        self.root.get_screen('resultados').consultar(sesion_id, origen)
        self.ir_a('resultados')

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
