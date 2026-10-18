from kivy.uix.screenmanager import Screen
from kivy.app import App
from data import db
import session
import theme


class LoginScreen(Screen):
    def on_enter(self):
        self.ids.login_error.text = ''
        self.ids.login_user.text = ''
        self.ids.login_pass.text = ''

    def entrar(self):
        nombre = self.ids.login_user.text.strip()
        clave = self.ids.login_pass.text
        if not nombre or not clave:
            self._error('Completa usuario y contraseña para entrar.')
            return
        usuario = db.validar_login(nombre, clave)
        if usuario is None:
            self._error('Usuario o contraseña incorrectos. Intenta de nuevo.')
            self.ids.login_pass.text = ''
            return
        session.usuario = usuario
        session.session = session.nueva_sesion()
        app = App.get_running_app()
        if usuario.get('evaluacion_inicial'):
            app.ir_a_pestana('inicio')
        else:
            app.ir_a('bienvenida_evaluacion')

    def _error(self, msg):
        self.ids.login_error.text = msg
        self.ids.login_error.color = theme.ROJO
