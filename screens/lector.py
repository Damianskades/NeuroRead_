from kivy.uix.screenmanager import Screen
from kivy.app import App
from kivy.clock import Clock
from screens.common import wrap_label
from data import db
from data.libros import libro_por_id, capitulo, parrafos_capitulo
import session
import theme


class LectorScreen(Screen):
    _libro_id = None
    _numero = 1
    _origen = 'detalle'
    _leido = False

    def abrir(self, libro_id, numero, origen='detalle'):
        self._libro_id = libro_id
        self._origen = origen
        self._cargar(numero)

    def _cargar(self, numero):
        libro = libro_por_id(self._libro_id)
        cap = capitulo(self._libro_id, numero)
        if libro is None or cap is None:
            return
        self._numero = numero
        ids = self.ids
        ids.lector_libro.text = libro['titulo'].upper()
        ids.lector_titulo.text = cap['titulo']
        caja = ids.lector_texto
        caja.clear_widgets()
        for parrafo in parrafos_capitulo(self._libro_id, numero):
            lbl = wrap_label(parrafo, font_size='15sp', color=theme.TEXTO)
            lbl.line_height = 1.5
            caja.add_widget(lbl)
        u = session.usuario
        leidos = db.capitulos_leidos(u['id'], self._libro_id) if u else []
        self._leido = numero in leidos
        self._actualizar_boton()
        Clock.schedule_once(lambda dt: setattr(ids.lector_scroll, 'scroll_y', 1), 0)

    def _es_ultimo(self):
        libro = libro_por_id(self._libro_id)
        return self._numero >= len(libro['capitulos'])

    def _actualizar_boton(self):
        btn = self.ids.lector_btn
        if not self._leido:
            btn.text = 'MARCAR COMO LEÍDO'
        elif self._es_ultimo():
            btn.text = 'VOLVER AL LIBRO'
        else:
            btn.text = 'SIGUIENTE CAPÍTULO'

    def accion(self):
        if not self._leido:
            u = session.usuario
            if u:
                db.marcar_capitulo_leido(u['id'], self._libro_id, self._numero)
            self._leido = True
            self._actualizar_boton()
        elif self._es_ultimo():
            App.get_running_app().abrir_libro(self._libro_id)
        else:
            self._cargar(self._numero + 1)

    def volver(self):
        app = App.get_running_app()
        if self._origen == 'actividad':
            app.ir_a('actividad')
        elif self._origen == 'libros':
            app.ir_a_pestana('libros')
        else:
            app.abrir_libro(self._libro_id)
