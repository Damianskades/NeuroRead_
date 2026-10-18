from kivy.uix.screenmanager import Screen
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.widget import Widget
from kivy.factory import Factory
from kivy.metrics import dp
from kivy.app import App
from widgets import NeoIcon, NeoBadge, NeoBar, NeoButton, NeoTag
from screens.common import wrap_label, ajustar_alto
from data import db
from data.actividades import de_nivel
from data.config import ACTIVIDADES_PARA_DESBLOQUEAR
from data.libros import LIBROS, libro_por_id
from data.niveles import HABILIDADES, nivel_de, por_clave
import session
import theme

FILTROS = ['todas', 'pendientes', 'completadas']
ORDEN_LIBROS = {l['id']: i for i, l in enumerate(LIBROS)}


def nivel_actual(usuario_id, usuario):
    ultima = db.ultima_sesion(usuario_id)
    if ultima:
        return nivel_de(ultima['puntaje_global']), ultima
    return por_clave(usuario.get('nivel')) or nivel_de(0), None


def estado_ruta(usuario):
    nivel, ultima = nivel_actual(usuario['id'], usuario)
    fecha = ultima['fecha'] if ultima else None
    completadas = db.actividades_completadas_desde(usuario['id'], fecha)
    progresos = db.actividades_en_curso(usuario['id'])
    recientes = {aid: i for i, aid in enumerate(progresos)}
    porcentajes = {k: (ultima.get(k) if ultima else None) for k in HABILIDADES}

    def clave(a):
        pct = porcentajes.get(a['habilidad'])
        return (101 if pct is None else pct, ORDEN_LIBROS[a['libro_id']], a['orden'])

    actividades = de_nivel(nivel['clave'])
    filas = []
    for a in actividades:
        if a['id'] in progresos:
            estado = 'en_curso'
        elif a['id'] in completadas:
            estado = 'completada'
        else:
            estado = 'pendiente'
        filas.append((a, estado))
    rango = {'en_curso': 0, 'pendiente': 1, 'completada': 2}
    filas.sort(key=lambda f: (rango[f[1]], recientes.get(f[0]['id'], 0)) + clave(f[0]))
    hechas = db.contar_actividades_desde(usuario['id'], nivel['clave'], fecha)
    return {'nivel': nivel, 'filas': filas, 'progresos': progresos,
            'hechas': min(hechas, ACTIVIDADES_PARA_DESBLOQUEAR)}


class RutaScreen(Screen):
    filtro = 'todas'

    def on_enter(self):
        self.actualizar()

    def actualizar(self):
        u = session.usuario
        if not u:
            return
        datos = estado_ruta(u)
        self._datos = datos
        nivel = datos['nivel']
        meta = ACTIVIDADES_PARA_DESBLOQUEAR
        ids = self.ids
        ids.ruta_frase.text = (f"Actividades de nivel {nivel['nombre']} para subir tu puntaje. "
                               'Empieza por las que trabajan tus habilidades más bajas.')
        ids.ruta_progreso.text = f"{datos['hechas']} de {meta}"
        ids.ruta_barra.max = meta
        ids.ruta_barra.value = datos['hechas']
        ids.ruta_meta.text = (f'Completa {meta} actividades para desbloquear la evaluación '
                              'clasificatoria y pasar de nivel.')
        self._pintar_filtros()
        self._llenar_lista()

    def elegir_filtro(self, nombre):
        self.filtro = nombre
        self._pintar_filtros()
        self._llenar_lista()

    def _pintar_filtros(self):
        for nombre in FILTROS:
            chip = self.ids[f'ruta_filtro_{nombre}']
            activo = nombre == self.filtro
            chip.surface = theme.DORADO if activo else theme.TARJETA_ALT
            chip.color = theme.TEXTO_OSCURO if activo else theme.TEXTO
            chip.shadow_off = dp(2) if activo else 0
            chip._redraw()

    def _llenar_lista(self):
        caja = self.ids.ruta_lista
        caja.clear_widgets()
        filas = self._datos['filas']
        if self.filtro == 'pendientes':
            filas = [f for f in filas if f[1] != 'completada']
        elif self.filtro == 'completadas':
            filas = [f for f in filas if f[1] == 'completada']
        if not filas:
            caja.add_widget(wrap_label('No hay actividades en esta lista.', font_size='13sp',
                                       color=theme.TEXTO))
            return
        for actividad, estado in filas:
            caja.add_widget(self._tarjeta(actividad, estado))

    def _tarjeta(self, a, estado):
        libro = libro_por_id(a['libro_id'])
        habilidad = HABILIDADES[a['habilidad']]
        en_curso = estado == 'en_curso'
        card = Factory.TarjetaTocable(orientation='vertical', surface=theme.TARJETA,
                                      radius=dp(16), padding=[dp(14), dp(12)],
                                      spacing=dp(8),
                                      border_w=dp(3) if en_curso else dp(2))
        ajustar_alto(card)
        card.bind(on_press=lambda *x: App.get_running_app().abrir_actividad(a['id'], 'ruta'))
        if estado == 'completada':
            card.opacity = 0.8

        fila = ajustar_alto(BoxLayout(spacing=dp(12)))
        icono, chip = {'en_curso': ('play', theme.DORADO),
                       'pendiente': ('ruta', theme.TARJETA_ALT),
                       'completada': ('check', theme.VERDE)}[estado]
        fila.add_widget(NeoIcon(icon=icono, color_chip=chip, size=(dp(36), dp(36)),
                                radius=dp(10),
                                color_glifo=theme.TEXTO if estado == 'pendiente' else [],
                                pos_hint={'top': 1}))
        textos = ajustar_alto(BoxLayout(orientation='vertical', spacing=dp(3), pos_hint={'top': 1}))
        titulo = wrap_label(a['titulo'], font_size='15sp', bold=True)
        titulo.font_name = theme.F_DISPLAY
        textos.add_widget(titulo)
        textos.add_widget(wrap_label(f"{libro['titulo']}, capítulo {a['capitulo_requerido']}",
                                     font_size='13sp', color=theme.TEXTO_SEC))
        fila.add_widget(textos)
        texto_badge, fondo, color = {
            'en_curso': ('EN CURSO', theme.DORADO, theme.TEXTO_OSCURO),
            'pendiente': ('PENDIENTE', theme.TARJETA_ALT, theme.TEXTO_SEC),
            'completada': ('COMPLETADA', theme.VERDE, theme.TEXTO_OSCURO)}[estado]
        fila.add_widget(NeoBadge(text=texto_badge, surface=fondo, color=color,
                                 size_hint=(None, None), size=(dp(92), dp(22)),
                                 pos_hint={'top': 1}))
        card.add_widget(fila)

        etiqueta = ajustar_alto(BoxLayout())
        etiqueta.add_widget(NeoTag(text=habilidad['nombre'], color_borde=habilidad['color']))
        etiqueta.add_widget(Widget())
        card.add_widget(etiqueta)

        extra = []
        if en_curso:
            pendiente = self._datos['progresos'][a['id']]
            total = len(a['pasos'])
            hechos = min(pendiente.get('paso') or 0, total)
            paso_lbl = wrap_label(f'Paso {min(hechos + 1, total)} de {total}',
                                  font_size='13sp', color=theme.TEXTO_SEC)
            barra = NeoBar(value=hechos, max=total, fill=theme.DORADO, radius=dp(5),
                           size_hint_y=None, height=dp(10))
            boton = NeoButton(text='CONTINUAR', surface=theme.VERDE, color=theme.TEXTO_OSCURO,
                              font_size='14sp', size_hint_y=None, height=dp(50))
            boton.bind(on_press=lambda *x: App.get_running_app().abrir_actividad(a['id'],
                                                                                'ruta'))
            for w in (paso_lbl, barra, boton):
                card.add_widget(w)
        return card
