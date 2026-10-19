from kivy.uix.screenmanager import Screen
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.behaviors import ButtonBehavior
from kivy.uix.widget import Widget
from kivy.graphics import Color, Rectangle
from kivy.metrics import dp
from kivy.app import App
from kivy.utils import get_hex_from_color
from widgets import NeoBadge, NeoIcon
from screens.common import wrap_label, ajustar_alto, fecha_corta, plural, poner_texto
from screens.ruta import nivel_actual
from data import db
from data.config import ACTIVIDADES_PARA_DESBLOQUEAR
from data.niveles import nivel_de, por_clave
import session
import theme


class FilaTocable(ButtonBehavior, BoxLayout):
    pass


class Separador(Widget):
    def __init__(self, **kw):
        kw.setdefault('size_hint_y', None)
        kw.setdefault('height', dp(2))
        super().__init__(**kw)
        with self.canvas:
            Color(*theme.TARJETA_ALT)
            self._rect = Rectangle(pos=self.pos, size=self.size)
        self.bind(pos=self._mover, size=self._mover)

    def _mover(self, *a):
        self._rect.pos = self.pos
        self._rect.size = self.size


class EvaluacionScreen(Screen):
    def on_kv_post(self, base_widget):
        ids = self.ids
        self._boton_bloqueado = ids.eval_boton_bloqueado.__self__
        self._enlace_ruta = ids.eval_enlace_ruta.__self__
        self._boton_empezar = ids.eval_boton_empezar.__self__
        ids.eval_acciones.clear_widgets()

    def on_enter(self):
        self.actualizar()

    def actualizar(self):
        u = session.usuario
        if not u:
            return
        nivel, ultima = nivel_actual(u['id'], u)
        fecha = ultima['fecha'] if ultima else None
        hechas = min(db.contar_actividades_desde(u['id'], nivel['clave'], fecha),
                     ACTIVIDADES_PARA_DESBLOQUEAR)
        self._estado(hechas)
        self._historial(u['id'])

    def _estado(self, hechas):
        meta = ACTIVIDADES_PARA_DESBLOQUEAR
        faltan = meta - hechas
        ids = self.ids
        bloqueada = faltan > 0
        ids.eval_estado.text = 'Bloqueada' if bloqueada else 'Disponible'
        ids.eval_icono.icon = 'candado' if bloqueada else 'evaluacion'
        ids.eval_icono.color_chip = theme.VIOLETA if bloqueada else theme.DORADO
        ids.eval_barra.max = meta
        ids.eval_barra.value = hechas
        claro = get_hex_from_color(theme.TEXTO)
        ids.eval_texto.text = (
            f"Completa [b][color={claro}]{plural(faltan, 'actividad más', 'actividades más')}"
            '[/color][/b] de tu ruta para desbloquearla' if bloqueada else
            'Ya completaste las actividades de tu ruta. Puedes rendir tu evaluación '
            'clasificatoria.')
        caja = ids.eval_acciones
        caja.clear_widgets()
        if bloqueada:
            caja.add_widget(self._boton_bloqueado)
            caja.add_widget(self._enlace_ruta)
        else:
            caja.add_widget(self._boton_empezar)
        ids.eval_barra.opacity = 1 if bloqueada else 0
        ids.eval_barra.height = dp(14) if bloqueada else 0

    def _historial(self, usuario_id):
        caja = self.ids.eval_historial
        caja.clear_widgets()
        sesiones = list(reversed(db.historial_completo(usuario_id)))
        if not sesiones:
            caja.add_widget(wrap_label('Aún no tienes evaluaciones.', font_size='13sp',
                                       color=theme.TEXTO))
            return
        for i, s in enumerate(sesiones):
            if i:
                caja.add_widget(Separador())
            caja.add_widget(self._fila(s))

    def _fila(self, s):
        nivel = por_clave(s.get('nivel')) or nivel_de(s['puntaje_global'])
        fila = ajustar_alto(FilaTocable(spacing=dp(10), padding=[0, dp(6)]))
        fila.bind(on_press=lambda *a: App.get_running_app().abrir_neuroscore(s['id'], 'evaluacion'))
        izquierda = ajustar_alto(BoxLayout(orientation='vertical', spacing=dp(2),
                                           pos_hint={'center_y': 0.5}))
        tipo = 'Evaluación inicial' if s.get('tipo') == 'inicial' else 'Clasificatoria'
        izquierda.add_widget(wrap_label(tipo, font_size='14sp', color=theme.TEXTO, bold=True))
        izquierda.add_widget(wrap_label(fecha_corta(s['fecha']), font_size='13sp',
                                        color=theme.TEXTO_SEC))
        fila.add_widget(izquierda)
        puntaje = wrap_label('', font_size='20sp', color=nivel['color'], halign='right')
        puntaje.font_name = theme.F_DISPLAY
        puntaje.bold = False
        puntaje.size_hint_x = None
        puntaje.width = dp(62)
        puntaje.pos_hint = {'center_y': 0.5}
        poner_texto(puntaje, f"{s['puntaje_global']}%")
        fila.add_widget(puntaje)
        fila.add_widget(NeoBadge(text=nivel['nombre'], surface=nivel['color'],
                                 size_hint=(None, None), size=(dp(104), dp(24)),
                                 pos_hint={'center_y': 0.5}))
        fila.add_widget(NeoIcon(icon='volver', marco=False, girado=True, color_glifo=theme.TEXTO_SEC,
                                size=(dp(18), dp(18)), pos_hint={'center_y': 0.5}))
        return fila

    def ir_a_ruta(self):
        App.get_running_app().ir_a_pestana('ruta')

    def empezar(self):
        session.session = session.nueva_sesion()
        session.tipo_evaluacion = 'clasificatoria'
        App.get_running_app().ir_a('bienvenida_evaluacion')
