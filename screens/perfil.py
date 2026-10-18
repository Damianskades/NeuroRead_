from kivy.uix.screenmanager import Screen
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.modalview import ModalView
from kivy.factory import Factory
from kivy.metrics import dp
from kivy.app import App
from widgets import NeoCard, NeoBar, NeoIcon, NeoBadge, NeoButton
from screens.common import wrap_label, insignia_diferencia, ajustar_alto
from screens.ruta import nivel_actual
from screens.resultados import NOMBRES
from data import db
from data.libros import capitulos_por_libro
from data.logros import generar_logros
from data.niveles import nivel_de, por_clave
import session
import theme

MODULOS = [('VEL', 'velocidad'), ('COM', 'comprension'), ('INT', 'interpretacion'),
           ('IMA', 'imaginacion'), ('CON', 'concentracion'), ('RET', 'retencion')]
TIPOS = [('literal', 'Literal', theme.VERDE), ('critica', 'Crítica', theme.NARANJA),
         ('inferencial', 'Inferencial', theme.AZUL)]


def nivel_sesion(sesion):
    return por_clave(sesion.get('nivel')) or nivel_de(sesion['puntaje_global'])


def fila_barra(nombre, valor, color):
    fila = ajustar_alto(BoxLayout(orientation='vertical', spacing=dp(4)))
    arriba = ajustar_alto(BoxLayout(spacing=dp(8)))
    etiqueta = wrap_label(nombre, font_size='13sp', color=theme.TEXTO, bold=True)
    etiqueta.pos_hint = {'top': 1}
    numero = wrap_label(f'{round(valor)}%', font_size='13sp', color=color, bold=True,
                        halign='right')
    numero.size_hint_x = None
    numero.width = dp(48)
    numero.pos_hint = {'top': 1}
    arriba.add_widget(etiqueta)
    arriba.add_widget(numero)
    fila.add_widget(arriba)
    fila.add_widget(NeoBar(value=valor, max=100, fill=color, radius=dp(5),
                           size_hint_y=None, height=dp(11)))
    return fila


class ModalEliminar(ModalView):
    def __init__(self, **kw):
        kw.setdefault('size_hint', (None, None))
        kw.setdefault('size', (dp(340), dp(300)))
        kw.setdefault('background', '')
        kw.setdefault('background_color', theme.TRANSPARENTE)
        kw.setdefault('overlay_color', theme.VELO)
        kw.setdefault('auto_dismiss', False)
        super().__init__(**kw)
        tarjeta = NeoCard(orientation='vertical', surface=theme.TARJETA, radius=dp(18),
                          padding=[dp(20), dp(18)], spacing=dp(12))
        titulo = wrap_label('Eliminar cuenta', font_size='20sp', color=theme.ROJO)
        titulo.font_name = theme.F_DISPLAY
        tarjeta.add_widget(titulo)
        tarjeta.add_widget(wrap_label('Se borrarán tu perfil, tus evaluaciones y tu progreso. '
                                      'Esta acción no se puede deshacer.',
                                      font_size='13sp', color=theme.TEXTO))
        self.campo = Factory.CampoTexto(hint_text='Tu contraseña...', password=True,
                                        cursor_color=theme.ROJO)
        tarjeta.add_widget(self.campo)
        self.error = Factory.ErrorFormulario()
        tarjeta.add_widget(self.error)
        botones = BoxLayout(size_hint_y=None, height=dp(52), spacing=dp(12))
        eliminar = NeoButton(text='ELIMINAR', surface=theme.ROJO, color=theme.TEXTO,
                             font_size='14sp')
        eliminar.bind(on_press=lambda *a: self.confirmar())
        cancelar = NeoButton(text='CANCELAR', surface=theme.TARJETA_ALT, color=theme.TEXTO,
                             font_size='14sp')
        cancelar.bind(on_press=lambda *a: self.dismiss())
        botones.add_widget(eliminar)
        botones.add_widget(cancelar)
        tarjeta.add_widget(botones)
        tarjeta.bind(minimum_height=lambda w, h: setattr(self, 'height', h))
        self.add_widget(tarjeta)

    def confirmar(self):
        u = session.usuario
        if not u:
            self.dismiss()
            return
        if not self.campo.text:
            self.error.text = 'Escribe tu contraseña para confirmar.'
            return
        ok, error = db.eliminar_usuario(u['id'], self.campo.text)
        if not ok:
            self.error.text = error
            self.campo.text = ''
            return
        self.dismiss()
        App.get_running_app().cerrar_sesion()


class PerfilScreen(Screen):
    mensaje_pendiente = ''

    def on_enter(self):
        self.actualizar()

    def actualizar(self):
        u = session.usuario
        if not u:
            return
        ids = self.ids
        ids.perfil_mensaje.text = self.mensaje_pendiente
        self.mensaje_pendiente = ''
        nivel, ultima = nivel_actual(u['id'], u)
        self._estudiante(u, nivel)
        self._estadisticas(u['id'])
        self._evolucion(u['id'], ultima)
        self._modulos(ultima)
        self._tipos(ultima)
        ids.perfil_recomendacion.text = nivel['recomendacion']
        self._logros(u['id'])
        ids.perfil_scroll.scroll_y = 1

    def _estudiante(self, u, nivel):
        ids = self.ids
        nombre = f"{u.get('nombre', '')} {u.get('apellido', '')}".strip()
        ids.perfil_inicial.text = (u.get('nombre') or u.get('nombre_usuario') or '?')[0].upper()
        ids.perfil_nombre.text = nombre or u.get('nombre_usuario', '')
        detalle = f"@{u.get('nombre_usuario', '')}"
        if u.get('grado'):
            detalle += f". {u['grado']}"
        ids.perfil_detalle.text = detalle
        ids.perfil_nivel.text = nivel['nombre']
        ids.perfil_nivel.surface = nivel['color']

    def _estadisticas(self, usuario_id):
        stats = db.estadisticas(usuario_id)
        self.ids.perfil_total.text = str(stats['total'])
        self.ids.perfil_racha.text = str(stats['racha'])
        self.ids.perfil_mejor.text = str(stats['mejor'])

    def _evolucion(self, usuario_id, ultima):
        ids = self.ids
        primera = db.primera_sesion(usuario_id)
        if not primera or not ultima:
            ids.perfil_inicial_pts.text = '--'
            ids.perfil_actual_pts.text = '--'
            ids.perfil_diferencia.text = 'SIN DATOS'
            ids.perfil_diferencia.surface = theme.TARJETA_ALT
            ids.perfil_diferencia.color = theme.TEXTO_SEC
            return
        ids.perfil_inicial_pts.text = str(primera['puntaje_global'])
        ids.perfil_inicial_pts.color = nivel_sesion(primera)['color']
        ids.perfil_actual_pts.text = str(ultima['puntaje_global'])
        ids.perfil_actual_pts.color = nivel_sesion(ultima)['color']
        texto, fondo, color = insignia_diferencia(ultima['puntaje_global'] - primera['puntaje_global'])
        ids.perfil_diferencia.text = texto
        ids.perfil_diferencia.surface = fondo
        ids.perfil_diferencia.color = color

    def _sin_datos(self, caja):
        caja.add_widget(wrap_label('Aún no hay datos. Completa una evaluación.',
                                   font_size='13sp', color=theme.TEXTO))

    def _modulos(self, ultima):
        caja = self.ids.perfil_modulos
        caja.clear_widgets()
        if not ultima:
            self._sin_datos(caja)
            return
        valores = [(NOMBRES[code], ultima.get(col) or 0, theme.MODULE_COLORS_CODE[code])
                   for code, col in MODULOS]
        for nombre, valor, color in sorted(valores, key=lambda v: -v[1]):
            caja.add_widget(fila_barra(nombre, valor, color))

    def _tipos(self, ultima):
        caja = self.ids.perfil_tipos
        caja.clear_widgets()
        valores = [(nombre, ultima.get(k), color) for k, nombre, color in TIPOS] if ultima else []
        valores = [v for v in valores if v[1] is not None]
        if not valores:
            self._sin_datos(caja)
            return
        for nombre, valor, color in sorted(valores, key=lambda v: -v[1]):
            caja.add_widget(fila_barra(nombre, valor, color))

    def _logros(self, usuario_id):
        caja = self.ids.perfil_logros
        caja.clear_widgets()
        for logro in generar_logros(usuario_id, capitulos_por_libro()):
            caja.add_widget(self._tarjeta_logro(logro))

    def _tarjeta_logro(self, logro):
        ok = logro['ok']
        card = ajustar_alto(NeoCard(orientation='horizontal', surface=theme.TARJETA, radius=dp(16),
                                    padding=[dp(12), dp(10)], spacing=dp(12), shadow_off=dp(3)))
        card.add_widget(NeoIcon(icon='trofeo', color_chip=theme.DORADO if ok else theme.TARJETA_ALT,
                                color_glifo=[] if ok else theme.TEXTO_SEC,
                                size=(dp(40), dp(40)), pos_hint={'top': 1}))
        textos = ajustar_alto(BoxLayout(orientation='vertical', spacing=dp(2), pos_hint={'top': 1}))
        textos.add_widget(wrap_label(logro['nombre'], font_size='13.5sp', bold=True,
                                     color=theme.TEXTO if ok else theme.TEXTO_SEC))
        textos.add_widget(wrap_label(logro['detalle'], font_size='13sp',
                                     color=theme.TEXTO if ok else theme.TEXTO_SEC))
        card.add_widget(textos)
        card.add_widget(NeoBadge(text='LOGRADO' if ok else 'BLOQUEADO',
                                 surface=theme.VERDE if ok else theme.TARJETA_ALT,
                                 color=theme.TEXTO_OSCURO if ok else theme.TEXTO_SEC,
                                 size_hint=(None, None), size=(dp(84), dp(22)),
                                 pos_hint={'top': 1}))
        return card

    def editar(self):
        App.get_running_app().ir_a('editar_perfil')

    def cerrar_sesion(self):
        App.get_running_app().cerrar_sesion()

    def eliminar_cuenta(self):
        ModalEliminar().open()
