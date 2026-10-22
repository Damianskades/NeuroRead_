import re
from kivy.uix.screenmanager import Screen
from kivy.app import App
from kivy.metrics import dp
from widgets import NeoChip
from screens.common import mostrar_aviso
from data import db
from data.config import GRADOS
import session
import theme

RE_USUARIO = re.compile(r'^[A-Za-z0-9_]{3,20}$')
RE_NOMBRE = re.compile(r'^[A-Za-zÁÉÍÓÚáéíóúÜüÑñ ]+$')
RE_CORREO = re.compile(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
CLAVE_MINIMA = 6

CAMPOS = ['reg_usuario', 'reg_nombre', 'reg_apellido', 'reg_correo',
          'reg_clave', 'reg_clave2']


def validar_datos(usuario, nombre, apellido, grado, correo):
    if not all([usuario, nombre, apellido, grado, correo]):
        return 'Completa todos los campos y elige tu grado escolar.'
    if not RE_USUARIO.match(usuario):
        return ('El nombre de usuario debe tener de 3 a 20 caracteres: letras sin '
                'tilde, números o guion bajo.')
    if not RE_NOMBRE.match(nombre):
        return 'El nombre solo puede tener letras, espacios y tildes.'
    if not RE_NOMBRE.match(apellido):
        return 'El apellido solo puede tener letras, espacios y tildes.'
    if not RE_CORREO.match(correo):
        return 'Escribe un correo válido, por ejemplo nombre@correo.com.'
    return None


def validar_clave_nueva(clave, clave2):
    if len(clave) < CLAVE_MINIMA:
        return f'La contraseña debe tener al menos {CLAVE_MINIMA} caracteres.'
    if clave != clave2:
        return 'Las contraseñas no coinciden.'
    return None


def validar_registro(usuario, nombre, apellido, grado, correo, clave, clave2):
    if not all([usuario, nombre, apellido, grado, correo, clave, clave2]):
        return 'Completa todos los campos y elige tu grado escolar.'
    return (validar_datos(usuario, nombre, apellido, grado, correo)
            or validar_clave_nueva(clave, clave2))


def limpiar_nombre(texto):
    return ' '.join(texto.split())


class SelectorGrado:
    _grado = None
    _chips = {}

    def crear_chips_grado(self, caja):
        self._chips = {}
        for grado in GRADOS:
            chip = NeoChip(text=grado, font_size='13sp', font_name=theme.F_DISPLAY, bold=True,
                           halign='center',
                           valign='middle', size_hint_y=None, height=dp(48),
                           padding=[dp(8), dp(4)])
            chip.bind(size=lambda c, s: setattr(c, 'text_size', (s[0] - dp(16), None)))
            chip.bind(on_press=lambda c, g=grado: self.elegir_grado(g))
            self._chips[grado] = chip
            caja.add_widget(chip)

    def elegir_grado(self, grado):
        self._grado = grado if grado in self._chips else None
        for nombre, chip in self._chips.items():
            elegido = nombre == self._grado
            chip.surface = theme.DORADO if elegido else theme.TARJETA_ALT
            chip.color = theme.TEXTO_OSCURO if elegido else theme.TEXTO
            chip.bold = elegido


class RegistroScreen(SelectorGrado, Screen):
    def on_kv_post(self, base_widget):
        self.crear_chips_grado(self.ids.reg_grados)

    def on_enter(self):
        for campo in CAMPOS:
            self.ids[campo].text = ''
        self.ids.reg_error.text = ''
        self.elegir_grado(None)
        self.ids.reg_scroll.scroll_y = 1

    def crear(self):
        ids = self.ids
        usuario = ids.reg_usuario.text.strip()
        nombre = limpiar_nombre(ids.reg_nombre.text)
        apellido = limpiar_nombre(ids.reg_apellido.text)
        correo = ids.reg_correo.text.strip()
        clave = ids.reg_clave.text
        clave2 = ids.reg_clave2.text
        error = validar_registro(usuario, nombre, apellido, self._grado, correo,
                                 clave, clave2)
        if error is None:
            nuevo_id, error = db.crear_usuario(usuario, nombre, apellido, self._grado,
                                               correo, clave)
        if error:
            ids.reg_error.color = theme.ROJO
            mostrar_aviso(ids.reg_error, error, ids.reg_scroll)
            return
        ids.reg_error.text = ''
        session.usuario = db.obtener_usuario(nuevo_id)
        session.session = session.nueva_sesion()
        App.get_running_app().ir_a('bienvenida_evaluacion')
