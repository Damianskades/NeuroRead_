from kivy.uix.screenmanager import Screen, FadeTransition
from kivy.properties import StringProperty

PESTANAS = ['inicio', 'ruta', 'evaluacion', 'libros', 'perfil']


class PestanaScreen(Screen):
    titulo = StringProperty('')


class PrincipalScreen(Screen):
    def on_kv_post(self, base_widget):
        self.ids.principal_sm.transition = FadeTransition(duration=0.15)
        self.ids.principal_barra.activar(self.ids.principal_sm.current)

    def ir_a_pestana(self, nombre):
        if nombre not in PESTANAS:
            return
        sm = self.ids.principal_sm
        if sm.current == nombre:
            pantalla = sm.current_screen
            if hasattr(pantalla, 'actualizar'):
                pantalla.actualizar()
        else:
            sm.current = nombre
        self.ids.principal_barra.activar(nombre)

    def mostrar_libro(self, libro_id):
        sm = self.ids.principal_sm
        detalle = sm.get_screen('libro_detalle')
        detalle.libro_id = libro_id
        if sm.current == 'libro_detalle':
            detalle.actualizar()
        else:
            sm.current = 'libro_detalle'
        self.ids.principal_barra.activar('libros')
