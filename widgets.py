import os
import random
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.widget import Widget
from kivy.uix.behaviors import ButtonBehavior
from kivy.graphics import Color, RoundedRectangle, Line, Ellipse, Rectangle
from kivy.core.image import Image as CoreImage
from kivy.properties import (ListProperty, NumericProperty, StringProperty,
                             BooleanProperty)
from kivy.metrics import dp
from kivy.factory import Factory
import theme


def _paint(widget, surface, radius, shadow_off, border_w, shift=0, borde=None):
    widget.canvas.before.clear()
    x, y = widget.pos
    w, h = widget.size
    cur_off = max(shadow_off - shift, 0)
    with widget.canvas.before:
        if shadow_off > 0:
            Color(*theme.BORDE)
            RoundedRectangle(pos=(x + cur_off, y - cur_off), size=(w, h),
                             radius=[radius])
        Color(*surface)
        RoundedRectangle(pos=(x + shift, y - shift), size=(w, h),
                         radius=[radius])
        if border_w > 0:
            Color(*(borde or theme.BORDE))
            Line(rounded_rectangle=(x + shift, y - shift, w, h, radius),
                 width=border_w)


class NeoCard(BoxLayout):
    surface = ListProperty(theme.TARJETA)
    radius = NumericProperty(dp(16))
    shadow_off = NumericProperty(dp(4))
    border_w = NumericProperty(dp(2))

    def __init__(self, **kw):
        super().__init__(**kw)
        self.bind(pos=self._redraw, size=self._redraw,
                  surface=self._redraw, radius=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        _paint(self, self.surface, self.radius, self.shadow_off, self.border_w)


class NeoButton(ButtonBehavior, Label):
    surface = ListProperty(theme.DORADO)
    radius = NumericProperty(dp(14))
    shadow_off = NumericProperty(dp(5))
    border_w = NumericProperty(dp(2))
    color_borde = ListProperty(theme.BORDE)

    def __init__(self, **kw):
        kw.setdefault('color', theme.TEXTO_OSCURO)
        kw.setdefault('font_name', theme.F_DISPLAY)
        super().__init__(**kw)
        self.bind(pos=self._redraw, size=self._redraw, surface=self._redraw,
                  state=self._redraw, color_borde=self._redraw, shadow_off=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        shift = dp(3) if self.state == 'down' and self.shadow_off else 0
        _paint(self, self.surface, self.radius, self.shadow_off,
               self.border_w, shift=shift, borde=self.color_borde)


class NeoChip(ButtonBehavior, Label):
    surface = ListProperty(theme.TARJETA_ALT)
    radius = NumericProperty(dp(14))
    shadow_off = NumericProperty(dp(3))
    border_w = NumericProperty(dp(2))

    def __init__(self, **kw):
        kw.setdefault('color', theme.TEXTO)
        kw.setdefault('font_name', theme.F_BODY)
        super().__init__(**kw)
        self.disabled_color = self.color
        self.bind(color=lambda w, c: setattr(w, 'disabled_color', c))
        self.bind(pos=self._redraw, size=self._redraw,
                  surface=self._redraw, state=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        shift = dp(2) if self.state == 'down' else 0
        _paint(self, self.surface, self.radius, self.shadow_off,
               self.border_w, shift=shift)


class NeoBadge(Label):
    surface = ListProperty(theme.DORADO)
    radius = NumericProperty(dp(9))

    def __init__(self, **kw):
        kw.setdefault('color', theme.TEXTO_OSCURO)
        kw.setdefault('font_size', '11sp')
        kw.setdefault('font_name', theme.F_DISPLAY)
        kw.setdefault('bold', True)
        super().__init__(**kw)
        self.bind(pos=self._redraw, size=self._redraw, surface=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        self.canvas.before.clear()
        x, y = self.pos
        w, h = self.size
        r = self.radius
        with self.canvas.before:
            Color(*theme.BORDE)
            RoundedRectangle(pos=(x + dp(2), y - dp(2)), size=(w, h), radius=[r])
            Color(*self.surface)
            RoundedRectangle(pos=(x, y), size=(w, h), radius=[r])
            Color(*theme.BORDE)
            Line(rounded_rectangle=(x, y, w, h, r), width=dp(1.5))


class NeoBar(Widget):
    value = NumericProperty(0)
    max = NumericProperty(100)
    fill = ListProperty(theme.DORADO)
    radius = NumericProperty(dp(7))
    marcas = ListProperty([])
    meta = NumericProperty(-1)
    color_meta = ListProperty(theme.DORADO)

    def __init__(self, **kw):
        super().__init__(**kw)
        self.bind(pos=self._redraw, size=self._redraw,
                  value=self._redraw, max=self._redraw, fill=self._redraw,
                  marcas=self._redraw, meta=self._redraw, color_meta=self._redraw)
        self._redraw()

    def _marcas(self, x, y, w, h):
        self.canvas.after.clear()
        if self.max == 0:
            return
        ancho = dp(2)
        with self.canvas.after:
            for m in self.marcas:
                if m == self.meta:
                    continue
                Color(*theme.TEXTO_SEC)
                Rectangle(pos=(round(x + w * m / self.max - ancho / 2), y), size=(ancho, h))
            if self.meta in self.marcas:
                Color(*self.color_meta)
                Rectangle(pos=(round(x + w * self.meta / self.max - ancho / 2), y - dp(4)),
                          size=(ancho, h + dp(8)))

    def _redraw(self, *a):
        self.canvas.before.clear()
        x, y = self.pos
        w, h = self.size
        r = self.radius
        frac = 0 if self.max == 0 else max(0.0, min(self.value / self.max, 1.0))
        with self.canvas.before:
            Color(*theme.BORDE)
            RoundedRectangle(pos=(x + dp(3), y - dp(3)), size=(w, h), radius=[r])
            Color(*theme.TARJETA_ALT)
            RoundedRectangle(pos=(x, y), size=(w, h), radius=[r])
            if frac > 0:
                Color(*self.fill)
                RoundedRectangle(pos=(x, y), size=(max(w * frac, h), h),
                                 radius=[r])
            Color(*theme.BORDE)
            Line(rounded_rectangle=(x, y, w, h, r), width=dp(2))
        self._marcas(x, y, w, h)


CARPETA_ICONOS = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'assets', 'icons')
EQUIVALENCIAS_ICONOS = {
    'book': 'libro', 'eye': 'ojo', 'bolt': 'rayo', 'brain': 'cerebro',
    'gauge': 'medidor', 'timer': 'reloj', 'spark': 'chispa', 'trophy': 'trofeo',
    'target': 'objetivo', 'chart': 'grafico', 'lock': 'candado', 'user': 'perfil',
    'home': 'inicio', 'close': 'cerrar', 'back': 'volver', 'flame': 'llama',
    'bulb': 'bombilla',
}
_TEXTURAS = {}


def textura_icono(nombre):
    nombre = EQUIVALENCIAS_ICONOS.get(nombre, nombre)
    if nombre not in _TEXTURAS:
        ruta = os.path.join(CARPETA_ICONOS, nombre + '.png')
        textura = None
        if os.path.isfile(ruta):
            try:
                textura = CoreImage(ruta, mipmap=True).texture
                textura.mag_filter = 'linear'
                textura.min_filter = 'linear_mipmap_linear'
            except Exception:
                textura = None
        _TEXTURAS[nombre] = textura
    return _TEXTURAS[nombre]


class NeoIcon(Widget):
    color_chip = ListProperty(theme.DORADO)
    color_glifo = ListProperty([])
    icon = StringProperty('libro')
    radius = NumericProperty(dp(12))
    marco = BooleanProperty(True)

    def __init__(self, **kw):
        super().__init__(**kw)
        self.size_hint = (None, None)
        if 'size' not in kw:
            self.size = (dp(46), dp(46))
        self.bind(pos=self._redraw, size=self._redraw, color_chip=self._redraw,
                  color_glifo=self._redraw, icon=self._redraw, marco=self._redraw,
                  radius=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        self.canvas.before.clear()
        x, y = self.pos
        w, h = self.size
        r = self.radius
        glifo = self.color_glifo or theme.oscuro(self.color_chip, 0.28)
        textura = textura_icono(self.icon)
        with self.canvas.before:
            if self.marco:
                Color(*theme.BORDE)
                RoundedRectangle(pos=(x + dp(3), y - dp(3)), size=(w, h), radius=[r])
                Color(*self.color_chip)
                RoundedRectangle(pos=(x, y), size=(w, h), radius=[r])
                Color(*theme.BORDE)
                Line(rounded_rectangle=(x, y, w, h, r), width=dp(2))
            if textura is None:
                return
            lado = min(w, h) * (0.6 if self.marco else 1.0)
            tw, th = textura.size
            escala = lado / max(tw, th)
            iw, ih = round(tw * escala), round(th * escala)
            Color(*glifo)
            Rectangle(texture=textura, size=(iw, ih),
                      pos=(round(x + (w - iw) / 2), round(y + (h - ih) / 2)))


class NeoDeco(Widget):
    tint = ListProperty(theme.DORADO)
    seed = NumericProperty(7)

    def __init__(self, **kw):
        super().__init__(**kw)
        self.bind(pos=self._redraw, size=self._redraw, tint=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        self.canvas.before.clear()
        rng = random.Random(int(self.seed))
        x, y = self.pos
        w, h = self.size
        if w < dp(40) or h < dp(10):
            return
        with self.canvas.before:
            for i in range(6):
                px = x + rng.uniform(0.04, 0.96) * w
                py = y + rng.uniform(0.2, 0.8) * h
                kind = rng.random()
                a = rng.uniform(0.28, 0.55)
                Color(self.tint[0], self.tint[1], self.tint[2], a)
                if kind < 0.5:
                    r = dp(rng.uniform(4, 7))
                    Line(points=[px - r, py, px + r, py], width=dp(1.6))
                    Line(points=[px, py - r, px, py + r], width=dp(1.6))
                elif kind < 0.8:
                    r = dp(rng.uniform(2, 3.4))
                    Ellipse(pos=(px - r, py - r), size=(r * 2, r * 2))
                else:
                    r = dp(rng.uniform(3.5, 5.5))
                    Line(circle=(px, py, r), width=dp(1.4))


class NeoTabBar(BoxLayout):
    def __init__(self, **kw):
        kw.setdefault('padding', [dp(8), dp(10), dp(8), dp(14)])
        kw.setdefault('spacing', dp(4))
        kw.setdefault('size_hint_y', None)
        kw.setdefault('height', dp(80))
        super().__init__(**kw)
        self.bind(pos=self._redraw, size=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        self.canvas.before.clear()
        x, y = self.pos
        w, h = self.size
        with self.canvas.before:
            Color(*theme.TARJETA)
            RoundedRectangle(pos=(x, y), size=(w, h), radius=[0])
            Color(*theme.BORDE)
            Line(points=[x, y + h - dp(2), x + w, y + h - dp(2)], width=dp(2))

    def activar(self, pestana):
        for tab in self.children:
            if isinstance(tab, NeoTab):
                tab.activo = tab.pestana == pestana


class NeoTab(ButtonBehavior, BoxLayout):
    pestana = StringProperty('')
    texto = StringProperty('')
    icono = StringProperty('inicio')
    activo = BooleanProperty(False)
    radius = NumericProperty(dp(12))

    def __init__(self, **kw):
        kw.setdefault('orientation', 'vertical')
        kw.setdefault('padding', [dp(2), dp(7), dp(2), dp(5)])
        kw.setdefault('spacing', dp(3))
        super().__init__(**kw)
        self._icono = NeoIcon(icon=self.icono, marco=False, size=(dp(22), dp(22)),
                              pos_hint={'center_x': 0.5})
        self._texto = Label(text=self.texto, font_name=theme.F_DISPLAY, bold=True,
                            font_size='11sp', halign='center', valign='middle')
        self._texto.bind(size=lambda l, t: setattr(l, 'text_size', t))
        self.add_widget(self._icono)
        self.add_widget(self._texto)
        self.bind(pos=self._redraw, size=self._redraw, activo=self._redraw,
                  state=self._redraw, icono=self._redraw, texto=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        color = theme.TEXTO_OSCURO if self.activo else theme.TEXTO_SEC
        self._icono.icon = self.icono
        self._icono.color_glifo = color
        self._texto.text = self.texto
        self._texto.color = color
        self.canvas.before.clear()
        if not self.activo:
            return
        shift = dp(2) if self.state == 'down' else 0
        _paint(self, theme.DORADO, self.radius, dp(3), dp(2), shift=shift)


class NeoBotonIcono(ButtonBehavior, BoxLayout):
    texto = StringProperty('')
    icono = StringProperty('volver')
    surface = ListProperty(theme.TARJETA_ALT)
    color_texto = ListProperty(theme.TEXTO)
    radius = NumericProperty(dp(12))

    def __init__(self, **kw):
        kw.setdefault('orientation', 'horizontal')
        kw.setdefault('padding', [dp(10), dp(6), dp(14), dp(6)])
        kw.setdefault('spacing', dp(6))
        kw.setdefault('size_hint', (None, None))
        kw.setdefault('size', (dp(118), dp(48)))
        super().__init__(**kw)
        self._icono = NeoIcon(icon=self.icono, marco=False, size=(dp(22), dp(22)),
                              pos_hint={'center_y': 0.5})
        self._texto = Label(text=self.texto, font_name=theme.F_DISPLAY,
                            font_size='13sp', halign='left', valign='middle')
        self._texto.bind(size=lambda l, t: setattr(l, 'text_size', t))
        self.add_widget(self._icono)
        self.add_widget(self._texto)
        self.bind(pos=self._redraw, size=self._redraw, state=self._redraw,
                  surface=self._redraw, texto=self._redraw, icono=self._redraw,
                  color_texto=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        self._icono.icon = self.icono
        self._icono.color_glifo = self.color_texto
        self._texto.text = self.texto
        self._texto.color = self.color_texto
        shift = dp(2) if self.state == 'down' else 0
        _paint(self, self.surface, self.radius, dp(3), dp(2), shift=shift)


class NeoTag(Label):
    color_borde = ListProperty(theme.VERDE)
    radius = NumericProperty(dp(8))

    def __init__(self, **kw):
        kw.setdefault('font_name', theme.F_DISPLAY)
        kw.setdefault('font_size', '13sp')
        kw.setdefault('bold', True)
        kw.setdefault('size_hint', (None, None))
        kw.setdefault('height', dp(26))
        super().__init__(**kw)
        self.color = self.color_borde
        self.bind(texture_size=lambda l, t: setattr(l, 'width', t[0] + dp(20)))
        self.bind(pos=self._redraw, size=self._redraw, color_borde=self._redraw)
        self._redraw()

    def _redraw(self, *a):
        self.color = self.color_borde
        self.canvas.before.clear()
        x, y = self.pos
        w, h = self.size
        with self.canvas.before:
            Color(*theme.TARJETA)
            RoundedRectangle(pos=(x, y), size=(w, h), radius=[self.radius])
            Color(*self.color_borde)
            Line(rounded_rectangle=(x, y, w, h, self.radius), width=dp(1.5))


for _cls in (NeoCard, NeoButton, NeoChip, NeoIcon, NeoBadge, NeoBar, NeoDeco,
             NeoTabBar, NeoTab, NeoBotonIcono, NeoTag):
    Factory.register(_cls.__name__, cls=_cls)
