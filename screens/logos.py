import re
from kivy.uix.widget import Widget
from kivy.clock import Clock
from kivy.graphics import (Color, Rectangle, RoundedRectangle, Ellipse, Line, Mesh,
                           PushMatrix, PopMatrix, Scale, Translate, Rotate,
                           StencilPush, StencilUse, StencilUnUse, StencilPop)
from kivy.graphics.tesselator import Tesselator, WINDING_ODD, TYPE_POLYGONS
from kivy.core.text import Label as CoreLabel
from kivy.properties import NumericProperty, ListProperty, StringProperty
import theme

NEGRO = theme.BORDE
CREMA = theme.TEXTO
MAX_PASO = 0.1


def curva_css(x1, y1, x2, y2):
    def coordenada(u, a, b):
        return 3 * (1 - u) ** 2 * u * a + 3 * (1 - u) * u * u * b + u ** 3

    def curva(t):
        if t <= 0:
            return 0.0
        if t >= 1:
            return 1.0
        bajo, alto = 0.0, 1.0
        for _ in range(24):
            u = (bajo + alto) / 2
            if coordenada(u, x1, x2) < t:
                bajo = u
            else:
                alto = u
        return coordenada((bajo + alto) / 2, y1, y2)
    return curva


ENTRADA_SALIDA = curva_css(0.42, 0, 0.58, 1)
SALIDA = curva_css(0, 0, 0.58, 1)


def lineal(t):
    return min(max(t, 0.0), 1.0)


def mezclar(a, b, t):
    if isinstance(a, tuple):
        return tuple(x + (y - x) * t for x, y in zip(a, b))
    return a + (b - a) * t


def fotograma(claves, p, curva=ENTRADA_SALIDA):
    if p <= claves[0][0]:
        return claves[0][1]
    for (p0, v0), (p1, v1) in zip(claves, claves[1:]):
        if p <= p1:
            return mezclar(v0, v1, curva((p - p0) / (p1 - p0)) if p1 > p0 else 1)
    return claves[-1][1]


def _cubica(a, b, c, d, pasos):
    puntos = []
    for i in range(1, pasos + 1):
        u = i / pasos
        v = 1 - u
        puntos.append((v ** 3 * a[0] + 3 * v * v * u * b[0] + 3 * v * u * u * c[0] + u ** 3 * d[0],
                       v ** 3 * a[1] + 3 * v * v * u * b[1] + 3 * v * u * u * c[1] + u ** 3 * d[1]))
    return puntos


def _cuadratica(a, b, c, pasos):
    puntos = []
    for i in range(1, pasos + 1):
        u = i / pasos
        v = 1 - u
        puntos.append((v * v * a[0] + 2 * v * u * b[0] + u * u * c[0],
                       v * v * a[1] + 2 * v * u * b[1] + u * u * c[1]))
    return puntos


def trazo(d, pasos=32):
    fichas = re.findall(r'[MLHVCQZ]|-?[0-9.]+', d)
    puntos = []
    actual = (0.0, 0.0)
    orden = None
    i = 0
    while i < len(fichas):
        if fichas[i].isalpha():
            orden = fichas[i]
            i += 1
            if orden == 'Z':
                if puntos and puntos[-1] != puntos[0]:
                    puntos.append(puntos[0])
                continue
        valores = []
        cantidad = {'M': 2, 'L': 2, 'H': 1, 'V': 1, 'C': 6, 'Q': 4}[orden]
        for _ in range(cantidad):
            valores.append(float(fichas[i]))
            i += 1
        if orden == 'M':
            actual = (valores[0], valores[1])
            puntos.append(actual)
            orden = 'L'
            continue
        if orden == 'L':
            nuevos = [(valores[0], valores[1])]
        elif orden == 'H':
            nuevos = [(valores[0], actual[1])]
        elif orden == 'V':
            nuevos = [(actual[0], valores[0])]
        elif orden == 'C':
            nuevos = _cubica(actual, valores[0:2], valores[2:4], valores[4:6], pasos)
        else:
            nuevos = _cuadratica(actual, valores[0:2], valores[2:4], pasos)
        puntos.extend(nuevos)
        actual = nuevos[-1]
    return puntos


def medir(puntos):
    acumulado = [0.0]
    for (x0, y0), (x1, y1) in zip(puntos, puntos[1:]):
        acumulado.append(acumulado[-1] + ((x1 - x0) ** 2 + (y1 - y0) ** 2) ** 0.5)
    return acumulado


def punto_en(puntos, acumulado, distancia):
    if distancia <= 0:
        return puntos[0]
    for i in range(1, len(puntos)):
        if acumulado[i] >= distancia:
            tramo = acumulado[i] - acumulado[i - 1]
            t = (distancia - acumulado[i - 1]) / tramo if tramo else 0
            return mezclar(tuple(puntos[i - 1]), tuple(puntos[i]), t)
    return puntos[-1]


def recortar(puntos, acumulado, fraccion):
    limite = acumulado[-1] * fraccion
    if limite <= 0:
        return []
    salida = [puntos[0]]
    for i in range(1, len(puntos)):
        if acumulado[i] >= limite:
            salida.append(punto_en(puntos, acumulado, limite))
            return salida
        salida.append(puntos[i])
    return salida


def textura_texto(texto, tamano, color, contorno=0):
    opciones = dict(text=texto, font_size=max(tamano, 1), font_name=theme.F_DISPLAY, color=color)
    if contorno:
        opciones.update(outline_width=contorno, outline_color=NEGRO[:3])
    etiqueta = CoreLabel(**opciones)
    etiqueta.refresh()
    return etiqueta.texture, etiqueta.get_descent()


class LogoBase(Widget):
    VISTA = (200, 200)
    escala = NumericProperty(1)

    def __init__(self, **kw):
        self._ev = None
        self._t = 0.0
        self._escala = None
        super().__init__(**kw)
        self.bind(pos=self._rehacer, size=self._rehacer)
        self._rehacer()

    def on_escala(self, *a):
        if self._escala is not None:
            self._escala.x = self._escala.y = self.escala

    def _rehacer(self, *a):
        ancho, alto = self.VISTA
        self._s = min(self.width / ancho, self.height / alto)
        self._ox = self.x + (self.width - ancho * self._s) / 2
        self._oy = self.y + (self.height - alto * self._s) / 2
        self.canvas.clear()
        with self.canvas:
            PushMatrix()
            self._escala = Scale(self.escala, self.escala, 1, origin=self.center)
            self.dibujar()
            PopMatrix()
        self.posar(self._t)

    def iniciar(self, desde=0.0):
        self.detener()
        self.posar(desde)
        self._ev = Clock.schedule_interval(self._avanzar, 0)

    def detener(self):
        if self._ev is not None:
            self._ev.cancel()
            self._ev = None

    def animando(self):
        return self._ev is not None

    def _avanzar(self, dt):
        self.posar(self._t + min(dt, MAX_PASO))

    def posar(self, t):
        self._t = t

    def dibujar(self):
        pass

    def p(self, x, y):
        return self._ox + x * self._s, self._oy + (self.VISTA[1] - y) * self._s

    def pp(self, puntos):
        plano = []
        for x, y in puntos:
            plano.extend(self.p(x, y))
        return plano

    def caja(self, x, y, w, h):
        s = self._s
        return self._ox + x * s, self._oy + (self.VISTA[1] - y - h) * s, w * s, h * s

    def grosor(self, valor):
        ancho = valor * self._s / 2
        return 1.0001 if ancho == 1.0 else ancho

    def rect(self, x, y, w, h, relleno, r=0, borde=None, ancho_borde=0, alfa=1):
        px, py, pw, ph = self.caja(x, y, w, h)
        Color(*relleno[:3], alfa)
        if r:
            RoundedRectangle(pos=(px, py), size=(pw, ph), radius=[r * self._s])
        else:
            Rectangle(pos=(px, py), size=(pw, ph))
        if borde is not None:
            Color(*borde)
            if r:
                Line(rounded_rectangle=(px, py, pw, ph, r * self._s), width=self.grosor(ancho_borde))
            else:
                Line(rectangle=(px, py, pw, ph), width=self.grosor(ancho_borde), joint='miter')

    def circulo(self, cx, cy, r, relleno, borde=None, ancho_borde=0, alfa=1):
        x, y = self.p(cx, cy)
        radio = r * self._s
        Color(*relleno[:3], alfa)
        figura = Ellipse(pos=(x - radio, y - radio), size=(2 * radio, 2 * radio))
        linea = None
        if borde is not None:
            Color(*borde)
            linea = Line(circle=(x, y, radio), width=self.grosor(ancho_borde))
        return figura, linea

    def relleno(self, puntos, color):
        teselador = Tesselator()
        teselador.add_contour(self.pp(puntos[:-1] if puntos[0] == puntos[-1] else puntos))
        teselador.tesselate(WINDING_ODD, TYPE_POLYGONS)
        Color(*color)
        for vertices, indices in teselador.meshes:
            Mesh(vertices=vertices, indices=indices, mode='triangle_fan')

    def linea(self, puntos, ancho, color, cerrar=False, union='round', remate='round'):
        Color(*color)
        return Line(points=self.pp(puntos), width=self.grosor(ancho), close=cerrar,
                    joint=union, cap=remate)

    def texto(self, cadena, x, y, tamano, color, contorno=0):
        textura, descenso = textura_texto(cadena, tamano * self._s, color,
                                          round(contorno * self._s))
        borde = round(contorno * self._s)
        px, py = self.p(x, y)
        Color(1, 1, 1, 1)
        Rectangle(texture=textura, size=textura.size,
                  pos=(px - textura.width / 2, py + descenso - borde))

    def recortar_inicio(self, dibujo):
        StencilPush()
        dibujo()
        StencilUse()

    def recortar_fin(self, dibujo):
        StencilUnUse()
        dibujo()
        StencilPop()

    def cuadrado_hoja(self, color=CREMA):
        Color(*NEGRO)
        x, y, w, h = self.caja(18, 18, 172, 172)
        RoundedRectangle(pos=(x, y), size=(w, h), radius=[40 * self._s])
        self.rect(8, 8, 172, 172, color, r=40)

    def silueta_hoja(self):
        x, y, w, h = self.caja(8, 8, 172, 172)
        RoundedRectangle(pos=(x, y), size=(w, h), radius=[40 * self._s])

    def borde_hoja(self):
        Color(*NEGRO)
        x, y, w, h = self.caja(8, 8, 172, 172)
        Line(rounded_rectangle=(x, y, w, h, 40 * self._s), width=self.grosor(6))


HOJA_IZQUIERDA = 'M100 42 C80 32 50 30 28 36 L28 126 C50 120 80 122 100 132 Z'
HOJA_DERECHA = 'M100 42 C120 32 150 30 172 36 L172 126 C150 120 120 122 100 132 Z'
PLIEGUE_IZQUIERDO = 'M45 62 C55 52 70 54 72 66 C74 78 58 80 60 92 C62 104 80 102 84 112'
PLIEGUE_DERECHO = 'M155 62 C145 52 130 54 128 66 C126 78 142 80 140 92 C138 104 120 102 116 112'
RECORRIDO_CHISPA = (PLIEGUE_IZQUIERDO + ' L116 112 C120 102 138 104 140 92 C142 80 126 78 128 66 '
                    'C130 54 145 52 155 62')


class LogoLibroNeuronal(LogoBase):
    VISTA = (200, 164)
    CICLO_FLOTAR = 3.0
    CICLO_CHISPA = 2.6

    def dibujar(self):
        izquierda = trazo(HOJA_IZQUIERDA)
        derecha = trazo(HOJA_DERECHA)
        self._camino = trazo(RECORRIDO_CHISPA, 48)
        self._medidas = medir(self._camino)
        PushMatrix()
        self._flotar = Translate(0, 0)
        for hoja in (izquierda, derecha):
            self.relleno([(x + 6, y + 6) for x, y in hoja], NEGRO)
        for hoja in (izquierda, derecha):
            self.relleno(hoja, theme.DORADO)
            self.linea(hoja, 4, NEGRO, cerrar=True)
        self.linea([(100, 42), (100, 132)], 3, NEGRO)
        self.linea(trazo(PLIEGUE_IZQUIERDO), 3.5, theme.TEXTO_OSCURO)
        self.linea(trazo(PLIEGUE_DERECHO), 3.5, theme.TEXTO_OSCURO)
        self._halo, _ = self.circulo(45, 62, 9, theme.VERDE, alfa=0.35)
        self._chispa, self._aro = self.circulo(45, 62, 5, theme.VERDE, NEGRO, 2)
        PopMatrix()

    def posar(self, t):
        super().posar(t)
        s = self._s
        subida = fotograma([(0, 0), (0.5, -5), (1, 0)], (t % self.CICLO_FLOTAR) / self.CICLO_FLOTAR)
        self._flotar.y = -subida * s
        avance = (t % self.CICLO_CHISPA) / self.CICLO_CHISPA * self._medidas[-1]
        x, y = self.p(*punto_en(self._camino, self._medidas, avance))
        self._halo.pos = (x - 9 * s, y - 9 * s)
        self._chispa.pos = (x - 5 * s, y - 5 * s)
        self._aro.circle = (x, y, 5 * s)


OJO = 'M30 78 Q100 24 170 78 Q100 132 30 78 Z'


class LogoOjoLector(LogoBase):
    CICLO = 4.0

    def dibujar(self):
        ojo = trazo(OJO)
        PushMatrix()
        self._parpadeo = Scale(1, 1, 1, origin=self.p(100, 78))
        self.relleno([(x + 6, y + 6) for x, y in ojo], NEGRO)
        self.relleno(ojo, CREMA)

        def silueta():
            self.relleno(ojo, NEGRO)
        self.recortar_inicio(silueta)
        PushMatrix()
        self._leer = Translate(0, 0)
        self.circulo(100, 78, 21, theme.TURQUESA, NEGRO, 4)
        self.circulo(100, 78, 9, NEGRO)
        self.circulo(105, 73, 3.5, CREMA)
        PopMatrix()
        self.recortar_fin(silueta)
        self.linea(ojo, 5, NEGRO, cerrar=True)
        PopMatrix()
        self.rect(44, 148, 112, 9, theme.DORADO, r=4.5, borde=NEGRO, ancho_borde=2.5)
        self.rect(44, 166, 80, 9, theme.VERDE, r=4.5, borde=NEGRO, ancho_borde=2.5)

    def posar(self, t):
        super().posar(t)
        p = (t % self.CICLO) / self.CICLO
        self._leer.x = fotograma([(0, -22), (0.38, 22), (0.46, -22), (0.8, 10), (1, -22)], p) * self._s
        self._parpadeo.y = fotograma([(0, 1), (0.88, 1), (0.92, 0.08), (0.96, 1), (1, 1)], p)


class LogoSubrayado(LogoBase):
    CICLO = 3.2

    def dibujar(self):
        self.cuadrado_hoja()
        self.recortar_inicio(self.silueta_hoja)
        self.rect(38.75, 0, 2.5, 200, theme.ROJO)
        PushMatrix()
        self._subrayar = Scale(0, 1, 1, origin=self.p(30, 99))
        self.rect(30, 86, 150, 26, theme.VERDE)
        PopMatrix()
        for x, y, w, h, r in ((52, 40, 112, 9, 4.5), (52, 64, 86, 9, 4.5), (52, 94, 120, 10, 5),
                              (52, 124, 100, 9, 4.5), (52, 148, 60, 9, 4.5)):
            self.rect(x, y, w, h, NEGRO, r=r)
        PushMatrix()
        self._plumon = Translate(0, 0)
        Rotate(angle=-38, origin=self.p(40, 120))
        self.rect(38, 126, 22, 70, NEGRO, r=5)
        self.rect(34, 122, 22, 70, theme.TURQUESA, r=5, borde=NEGRO, ancho_borde=4)
        self.rect(34, 150, 22, 10, CREMA, borde=NEGRO, ancho_borde=3)
        punta = trazo('M37 122 L41 108 H49 L53 122 Z')
        self.relleno(punta, theme.VERDE)
        self.linea(punta, 4, NEGRO, cerrar=True)
        PopMatrix()
        self.recortar_fin(self.silueta_hoja)
        self.borde_hoja()

    def posar(self, t):
        super().posar(t)
        p = (t % self.CICLO) / self.CICLO
        self._subrayar.x = fotograma([(0, 0), (0.08, 0), (0.45, 1), (0.88, 1), (0.96, 0), (1, 0)], p)
        x, y = fotograma([(0, (-21, -15)), (0.08, (-21, -15)), (0.45, (125, -15)),
                          (0.6, (150, -60)), (0.88, (150, -60)), (1, (-21, -15))], p)
        self._plumon.x = x * self._s
        self._plumon.y = -y * self._s


CIRCULO_NOTA = ('M60 108 C58 72 98 58 128 66 C160 74 170 108 150 136 C130 160 78 158 62 132 '
                'C54 118 58 98 74 84')
VISTO_NOTA = 'M138 166 L148 176 L168 152'


class LogoNota20(LogoBase):
    CICLO = 3.4

    def dibujar(self):
        self.cuadrado_hoja()
        self.recortar_inicio(self.silueta_hoja)
        for y in range(36, 200, 20):
            self.rect(0, y - 0.75, 200, 1.5, theme.AZUL, alfa=0.45)
        self.rect(28.75, 0, 2.5, 200, theme.ROJO)
        self.rect(40, 22, 56, 7, NEGRO, r=3.5, alfa=0.7)
        self.texto('20', 111, 139, 74, NEGRO)
        self.texto('20', 107, 135, 74, theme.ROJO, contorno=1.75)
        self._circulo = trazo(CIRCULO_NOTA)
        self._medida_circulo = medir(self._circulo)
        self._visto = trazo(VISTO_NOTA)
        self._medida_visto = medir(self._visto)
        self._linea_circulo = self.linea([], 6, theme.ROJO)
        self._linea_visto = self.linea([], 6, theme.ROJO)
        self.recortar_fin(self.silueta_hoja)
        self.borde_hoja()

    def posar(self, t):
        super().posar(t)
        p = (t % self.CICLO) / self.CICLO
        circulo = 1 - fotograma([(0, 1), (0.1, 1), (0.45, 0), (0.9, 0), (1, 1)], p)
        visto = 1 - fotograma([(0, 1), (0.48, 1), (0.6, 0), (0.9, 0), (1, 1)], p)
        for linea, puntos, medida, fraccion in (
                (self._linea_circulo, self._circulo, self._medida_circulo, circulo),
                (self._linea_visto, self._visto, self._medida_visto, visto)):
            parte = recortar(puntos, medida, fraccion)
            linea.points = self.pp(parte) if len(parte) > 1 else []


class LogoNConPuntos(LogoBase):
    CICLO = 3.6
    POSE_FINAL = 2.16

    def libro(self, x, y, alto, color, rayas):
        self.rect(x + 5, y + 5, 34, alto, NEGRO, r=6)
        self.rect(x, y, 34, alto, color, r=6, borde=NEGRO, ancho_borde=5)
        for raya in rayas:
            self.linea([(x + 7, raya), (x + 27, raya)], 3.5, NEGRO)

    def dibujar(self):
        Color(*NEGRO)
        x, y, w, h = self.caja(18, 18, 172, 172)
        RoundedRectangle(pos=(x, y), size=(w, h), radius=[40 * self._s])
        self.rect(8, 8, 172, 172, theme.DORADO, r=40, borde=NEGRO, ancho_borde=6)
        PushMatrix()
        self._caer = Rotate(angle=0, origin=self.p(94, 156))
        Rotate(angle=27, origin=self.p(94, 96))
        self.libro(77, 34, 122, CREMA, (54, 136))
        PopMatrix()
        self.libro(36, 42, 114, theme.TURQUESA, (60, 138))
        self.libro(118, 42, 114, theme.VERDE, (60, 138))
        self.linea([(28, 160), (162, 160)], 7, NEGRO)
        PushMatrix()
        self._puntos = Scale(0, 0, 1, origin=self.p(163, 20))
        self.rect(136, 6, 62, 32, NEGRO, r=16)
        self.rect(132, 2, 62, 32, theme.ROJO, r=16, borde=NEGRO, ancho_borde=4)
        self.texto('+10', 163, 24, 17, CREMA)
        PopMatrix()

    def posar(self, t):
        super().posar(t)
        p = (t % self.CICLO) / self.CICLO
        self._caer.angle = -fotograma([(0, 27), (0.2, -4), (0.28, 3), (0.34, 0), (0.9, 0), (1, 27)], p)
        k = fotograma([(0, 0), (0.34, 0), (0.42, 1.2), (0.48, 1), (0.86, 1), (0.94, 0), (1, 0)], p)
        self._puntos.x = self._puntos.y = k


class TextoEspaciado(Widget):
    partes = ListProperty([])
    tamano = NumericProperty(13)
    espacio = NumericProperty(0)
    desfase = NumericProperty(0)
    interlineado = NumericProperty(0)

    def __init__(self, **kw):
        self._letras = []
        self._natural = 0
        super().__init__(**kw)
        self.bind(partes=self._rehacer, tamano=self._rehacer, espacio=self._rehacer,
                  interlineado=self._rehacer, pos=self._colocar, size=self._colocar, desfase=self._colocar)
        self._rehacer()

    def _rehacer(self, *a):
        self.canvas.clear()
        self._letras = []
        cadena = ''.join(texto for texto, _ in self.partes)
        if not cadena:
            return
        medidor = CoreLabel(text=cadena, font_size=self.tamano, font_name=theme.F_DISPLAY)
        avances = [medidor.get_extents(cadena[:i])[0] if i else 0 for i in range(len(cadena) + 1)]
        self._total = avances[-1] + self.espacio * len(cadena)
        indice = 0
        with self.canvas:
            Color(1, 1, 1, 1)
            for texto, color in self.partes:
                for letra in texto:
                    if letra != ' ':
                        textura, _ = textura_texto(letra, self.tamano, color)
                        figura = Rectangle(texture=textura, size=textura.size)
                        self._letras.append((figura, avances[indice] + self.espacio * indice))
                    indice += 1
        self._natural = medidor.get_extents(cadena)[1]
        self.height = self.tamano * self.interlineado if self.interlineado else self._natural
        self._colocar()

    def _colocar(self, *a):
        x0 = self.center_x - getattr(self, '_total', 0) / 2
        y0 = self.y + (self.height - self._natural) / 2 + self.desfase
        for figura, x in self._letras:
            figura.pos = (round(x0 + x), round(y0))
