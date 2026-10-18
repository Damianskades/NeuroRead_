from kivy.uix.screenmanager import Screen
from kivy.app import App
from screens.registro import (SelectorGrado, validar_datos, validar_clave_nueva,
                              limpiar_nombre)
from data import db
import session
import theme

CLAVES = ['edit_clave_actual', 'edit_clave_nueva', 'edit_clave_nueva2']


class EditarPerfilScreen(SelectorGrado, Screen):
    def on_kv_post(self, base_widget):
        self.crear_chips_grado(self.ids.edit_grados)

    def on_enter(self):
        u = session.usuario
        if not u:
            return
        ids = self.ids
        ids.edit_usuario.text = u.get('nombre_usuario') or ''
        ids.edit_nombre.text = u.get('nombre') or ''
        ids.edit_apellido.text = u.get('apellido') or ''
        ids.edit_correo.text = u.get('correo') or ''
        for campo in CLAVES:
            ids[campo].text = ''
        ids.edit_error.text = ''
        self.elegir_grado(u.get('grado'))
        ids.edit_scroll.scroll_y = 1

    def _error(self, mensaje):
        self.ids.edit_error.text = mensaje
        self.ids.edit_error.color = theme.ROJO

    def guardar(self):
        u = session.usuario
        if not u:
            return
        ids = self.ids
        usuario = ids.edit_usuario.text.strip()
        nombre = limpiar_nombre(ids.edit_nombre.text)
        apellido = limpiar_nombre(ids.edit_apellido.text)
        correo = ids.edit_correo.text.strip()
        actual = ids.edit_clave_actual.text
        nueva = ids.edit_clave_nueva.text
        nueva2 = ids.edit_clave_nueva2.text
        cambia_clave = bool(actual or nueva or nueva2)
        error = validar_datos(usuario, nombre, apellido, self._grado, correo)
        if error is None and cambia_clave:
            if not (actual and nueva and nueva2):
                error = 'Para cambiar la contraseña completa los tres campos.'
            else:
                error = validar_clave_nueva(nueva, nueva2)
            if error is None and not db.verificar_contrasena(u['id'], actual):
                error = 'La contraseña actual no es correcta.'
        if error:
            self._error(error)
            return
        ok, error = db.actualizar_usuario(u['id'], usuario, nombre, apellido, self._grado,
                                          correo)
        if ok and cambia_clave:
            ok, error = db.cambiar_contrasena(u['id'], actual, nueva)
        if not ok:
            self._error(error)
            return
        session.usuario = db.obtener_usuario(u['id']) or u
        app = App.get_running_app()
        perfil = app.root.get_screen('principal').ids.principal_sm.get_screen('perfil')
        perfil.mensaje_pendiente = 'Cambios guardados'
        app.ir_a_pestana('perfil')

    def cancelar(self):
        App.get_running_app().ir_a_pestana('perfil')
