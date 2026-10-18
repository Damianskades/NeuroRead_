from kivy.uix.screenmanager import Screen
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.anchorlayout import AnchorLayout
from kivy.uix.label import Label
from kivy.uix.widget import Widget
from kivy.properties import StringProperty
from kivy.factory import Factory
from kivy.metrics import dp
from kivy.app import App
from widgets import NeoCard, NeoIcon, NeoBadge, NeoBar, NeoButton
from screens.common import wrap_label, ajustar_alto
from screens.ruta import nivel_actual
from data import db
from data.libros import LIBROS, libro_por_id, buscar_actividad, actividades_de_nivel
import session
import theme


def plural(n, singular, varios):
    return f'{n} {singular if n == 1 else varios}'


def estado_libros(usuario_id):
    lecturas = db.lecturas_por_libro(usuario_id) if usuario_id else {}
    en_curso_id = None
    actividad = None
    if usuario_id:
        pendiente = db.obtener_actividad_en_curso(usuario_id)
        actividad = buscar_actividad(pendiente['actividad_id']) if pendiente else None
    if actividad:
        en_curso_id = actividad['libro_id']
    else:
        parciales = [(lecturas[l['id']]['ultima'], l['id']) for l in LIBROS
                     if 0 < lecturas.get(l['id'], {}).get('leidos', 0) < len(l['capitulos'])]
        if parciales:
            en_curso_id = max(parciales)[1]
    estados = {}
    for libro in LIBROS:
        leidos = db.capitulos_leidos(usuario_id, libro['id']) if usuario_id else []
        estados[libro['id']] = {'leidos': leidos, 'en_curso': libro['id'] == en_curso_id}
    return estados


def primer_pendiente(libro, leidos):
    for cap in libro['capitulos']:
        if cap['numero'] not in leidos:
            return cap['numero']
    return 1


def texto_progreso(libro, leidos):
    n = len(leidos)
    if n == 0:
        return 'Sin empezar'
    unidad = 'cuentos leídos' if libro['id'] == 'selva' else 'capítulos leídos'
    return f"{n} de {len(libro['capitulos'])} {unidad}"


def nivel_usuario():
    u = session.usuario
    return u.get('nivel') if u else None


def portada(libro, ancho, alto, icono):
    tapa = NeoCard(surface=libro['color'], radius=dp(10), shadow_off=dp(3),
                   size_hint=(None, None), size=(dp(ancho), dp(alto)))
    centro = AnchorLayout()
    centro.add_widget(NeoIcon(icon='libro', marco=False, color_glifo=theme.TEXTO_OSCURO,
                              size=(dp(icono), dp(icono))))
    tapa.add_widget(centro)
    return tapa


def titulo_label(texto, font_size, color=None):
    lbl = wrap_label(texto, font_size=font_size, color=color or theme.TEXTO)
    lbl.font_name = theme.F_DISPLAY
    return lbl


class LibrosScreen(Screen):
    def on_enter(self):
        self.actualizar()

    def actualizar(self):
        u = session.usuario
        estados = estado_libros(u['id'] if u else None)
        orden = sorted(LIBROS, key=lambda l: not estados[l['id']]['en_curso'])
        caja = self.ids.libros_lista
        caja.clear_widgets()
        for libro in orden:
            caja.add_widget(self._tarjeta(libro, estados[libro['id']]))

    def _tarjeta(self, libro, estado):
        leidos = estado['leidos']
        total = len(libro['capitulos'])
        card = ajustar_alto(Factory.TarjetaTocable(surface=theme.TARJETA, radius=dp(18),
                                                   padding=[dp(14), dp(14)], spacing=dp(14)))
        card.bind(on_press=lambda *a: App.get_running_app().abrir_libro(libro['id']))
        tapa = portada(libro, 84, 116, 32)
        tapa.pos_hint = {'top': 1}
        card.add_widget(tapa)

        derecha = ajustar_alto(BoxLayout(orientation='vertical', spacing=dp(5), pos_hint={'top': 1}))
        if estado['en_curso']:
            derecha.add_widget(self._insignia('EN CURSO', theme.DORADO, theme.TEXTO_OSCURO))
        elif not leidos:
            derecha.add_widget(self._insignia('NUEVO', theme.TARJETA_ALT, theme.TEXTO))
        derecha.add_widget(titulo_label(libro['titulo'], '16sp'))
        derecha.add_widget(wrap_label(f"{libro['autor']}. {libro['tipo']}",
                                      font_size='13sp', color=theme.TEXTO_SEC))
        derecha.add_widget(wrap_label(texto_progreso(libro, leidos), font_size='13sp',
                                      color=theme.TEXTO_SEC))
        derecha.add_widget(NeoBar(value=len(leidos), max=total, fill=libro['color'],
                                  radius=dp(5), size_hint_y=None, height=dp(10)))
        n_act = len(actividades_de_nivel(libro['id'], nivel_usuario()))
        derecha.add_widget(wrap_label(plural(n_act, 'actividad de tu nivel',
                                             'actividades de tu nivel'),
                                      font_size='13sp', color=libro['color'], bold=True))
        if not leidos:
            accion = 'EMPEZAR'
        elif len(leidos) < total:
            accion = 'CONTINUAR'
        else:
            accion = 'LEER'
        boton = NeoButton(text=accion, surface=libro['color'], color=theme.TEXTO_OSCURO,
                          font_size='13sp', size_hint_y=None, height=dp(40),
                          shadow_off=dp(3))
        boton.bind(on_press=lambda *a: self._accion(libro, leidos, accion))
        derecha.add_widget(Widget(size_hint_y=None, height=dp(2)))
        derecha.add_widget(boton)
        card.add_widget(derecha)
        return card

    def _insignia(self, texto, fondo, color):
        fila = BoxLayout(size_hint_y=None, height=dp(24))
        fila.add_widget(NeoBadge(text=texto, surface=fondo, color=color,
                                 size_hint=(None, None), size=(dp(86), dp(22)),
                                 pos_hint={'center_y': 0.5}))
        fila.add_widget(Widget())
        return fila

    def _accion(self, libro, leidos, accion):
        app = App.get_running_app()
        if accion == 'LEER':
            app.abrir_libro(libro['id'])
        else:
            app.abrir_lector(libro['id'], primer_pendiente(libro, leidos), 'libros')


class LibroDetalleScreen(Screen):
    libro_id = StringProperty('selva')

    def on_enter(self):
        self.actualizar()

    def actualizar(self):
        libro = libro_por_id(self.libro_id)
        if libro is None:
            return
        u = session.usuario
        leidos = db.capitulos_leidos(u['id'], libro['id']) if u else []
        ids = self.ids
        ids.det_portada.surface = libro['color']
        ids.det_titulo.text = libro['titulo']
        autor = libro['autor']
        if libro.get('traductor'):
            autor += f". Traducción de {libro['traductor']}"
        ids.det_autor.text = autor
        ids.det_tipo.text = f"{libro['tipo']}. {texto_progreso(libro, leidos)}"
        caja = ids.det_capitulos
        caja.clear_widgets()
        for cap in libro['capitulos']:
            caja.add_widget(self._tarjeta_capitulo(libro, cap, cap['numero'] in leidos))
        self._llenar_actividades(libro, u)
        ids.det_scroll.scroll_y = 1

    def _llenar_actividades(self, libro, u):
        caja = self.ids.det_actividades
        caja.clear_widgets()
        if not u:
            caja.add_widget(wrap_label('Disponibles próximamente', font_size='13sp',
                                       color=theme.TEXTO_SEC))
            return
        nivel, ultima = nivel_actual(u['id'], u)
        fecha = ultima['fecha'] if ultima else None
        completadas = db.actividades_completadas_desde(u['id'], fecha)
        progresos = db.actividades_en_curso(u['id'])
        for a in actividades_de_nivel(libro['id'], nivel['clave']):
            if a['id'] in progresos:
                estado = ('EN CURSO', theme.DORADO, theme.TEXTO_OSCURO)
            elif a['id'] in completadas:
                estado = ('COMPLETADA', theme.VERDE, theme.TEXTO_OSCURO)
            else:
                estado = ('PENDIENTE', theme.TARJETA_ALT, theme.TEXTO_SEC)
            caja.add_widget(self._tarjeta_actividad(a, estado))

    def _tarjeta_actividad(self, a, estado):
        card = ajustar_alto(Factory.TarjetaTocable(surface=theme.TARJETA, radius=dp(16),
                                                   padding=[dp(14), dp(10)], spacing=dp(12),
                                                   shadow_off=dp(3)))
        card.bind(on_press=lambda *x: App.get_running_app().abrir_actividad(a['id'], 'libro'))
        textos = ajustar_alto(BoxLayout(orientation='vertical', spacing=dp(2), pos_hint={'top': 1}))
        textos.add_widget(wrap_label(a['titulo'], font_size='13.5sp', bold=True))
        textos.add_widget(wrap_label(f"Capítulo {a['capitulo_requerido']}", font_size='13sp',
                                     color=theme.TEXTO_SEC))
        card.add_widget(textos)
        texto, fondo, color = estado
        card.add_widget(NeoBadge(text=texto, surface=fondo, color=color,
                                 size_hint=(None, None), size=(dp(92), dp(22)),
                                 pos_hint={'top': 1}))
        return card

    def _tarjeta_capitulo(self, libro, cap, leido):
        card = ajustar_alto(Factory.TarjetaTocable(surface=theme.TARJETA, radius=dp(16),
                                                   padding=[dp(12), dp(10)], spacing=dp(12),
                                                   shadow_off=dp(3)))
        card.bind(on_press=lambda *a: App.get_running_app().abrir_lector(
            libro['id'], cap['numero'], 'detalle'))
        numero = NeoCard(surface=theme.TARJETA_ALT, radius=dp(10), shadow_off=0,
                         size_hint=(None, None), size=(dp(40), dp(40)),
                         pos_hint={'top': 1})
        numero.add_widget(Label(text=str(cap['numero']), font_name=theme.F_DISPLAY,
                                font_size='15sp', color=libro['color']))
        card.add_widget(numero)
        titulo = wrap_label(cap['titulo'], font_size='13sp', color=theme.TEXTO, bold=True)
        titulo.pos_hint = {'top': 1}
        card.add_widget(titulo)
        card.add_widget(NeoBadge(text='LEÍDO' if leido else 'PENDIENTE',
                                 surface=theme.VERDE if leido else theme.TARJETA_ALT,
                                 color=theme.TEXTO_OSCURO if leido else theme.TEXTO_SEC,
                                 size_hint=(None, None), size=(dp(84), dp(24)),
                                 pos_hint={'top': 1}))
        return card

    def volver(self):
        App.get_running_app().ir_a_pestana('libros')
