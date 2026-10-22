import os
import sys
import zlib
import struct

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, RAIZ)
os.chdir(RAIZ)
os.environ.setdefault('KIVY_NO_ARGS', '1')

from kivy.config import Config
Config.set('graphics', 'width', '600')
Config.set('graphics', 'height', '760')
Config.set('graphics', 'resizable', False)

from kivy.app import App
from kivy.core.window import Window
from kivy.uix.widget import Widget
from kivy.clock import Clock
from kivy.graphics import Callback
from kivy.graphics.opengl import (glBlendFunc, glBlendFuncSeparate, GL_ONE, GL_SRC_ALPHA,
                                  GL_ONE_MINUS_SRC_ALPHA)
import theme
from screens.logos import LogoNConPuntos, TextoEspaciado

MUESTREO = 4
ICONO = os.path.join(RAIZ, 'assets', 'icon.png')
PRESPLASH = os.path.join(RAIZ, 'assets', 'presplash.png')
ANCHO_PRESPLASH, ALTO_PRESPLASH = 600, 760
LOGO_PRESPLASH = 400
PROPORCION = LOGO_PRESPLASH / 240


def reducir(datos, ancho, alto, factor):
    salida = bytearray(ancho * alto * 4)
    ancho_grande = ancho * factor
    muestras = factor * factor
    for y in range(alto):
        filas = [datos[(y * factor + k) * ancho_grande * 4:(y * factor + k + 1) * ancho_grande * 4]
                 for k in range(factor)]
        for x in range(ancho):
            r = g = b = a = 0
            for fila in filas:
                for i in range(x * factor * 4, (x + 1) * factor * 4, 4):
                    alfa = fila[i + 3]
                    r += fila[i] * alfa
                    g += fila[i + 1] * alfa
                    b += fila[i + 2] * alfa
                    a += alfa
            j = (y * ancho + x) * 4
            if a:
                salida[j] = round(r / a)
                salida[j + 1] = round(g / a)
                salida[j + 2] = round(b / a)
                salida[j + 3] = round(a / muestras)
    return bytes(salida)


def guardar_png(ruta, datos, ancho, alto):
    def bloque(tipo, contenido):
        return (struct.pack('>I', len(contenido)) + tipo + contenido
                + struct.pack('>I', zlib.crc32(tipo + contenido) & 0xffffffff))
    crudo = b''.join(b'\x00' + datos[y * ancho * 4:(y + 1) * ancho * 4] for y in range(alto))
    with open(ruta, 'wb') as archivo:
        archivo.write(b'\x89PNG\r\n\x1a\n')
        archivo.write(bloque(b'IHDR', struct.pack('>IIBBBBB', ancho, alto, 8, 6, 0, 0, 0)))
        archivo.write(bloque(b'IDAT', zlib.compress(crudo, 9)))
        archivo.write(bloque(b'IEND', b''))


def _alfa_compuesto(*a):
    glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_ALPHA)


def _alfa_normal(*a):
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)


def exportar(widget, ruta):
    ancho, alto = int(widget.width), int(widget.height)
    antes = Callback(_alfa_compuesto)
    despues = Callback(_alfa_normal)
    widget.canvas.before.insert(0, antes)
    widget.canvas.after.add(despues)
    imagen = widget.export_as_image(scale=MUESTREO)
    widget.canvas.before.remove(antes)
    widget.canvas.after.remove(despues)
    datos = imagen.texture.pixels
    guardar_png(ruta, reducir(datos, ancho, alto, MUESTREO), ancho, alto)
    print('Guardado', os.path.relpath(ruta, RAIZ), ancho, 'x', alto)


class ExportarIconos(App):
    title = 'Exportar iconos'

    def build(self):
        Window.clearcolor = theme.FONDO
        raiz = Widget()
        self.icono = Widget(size=(512, 512), pos=(0, 0))
        logo = LogoNConPuntos(size=(512, 512), pos=(0, 0))
        logo.posar(LogoNConPuntos.POSE_FINAL)
        self.icono.add_widget(logo)

        self.presplash = Widget(size=(ANCHO_PRESPLASH, ALTO_PRESPLASH), pos=(0, 0))
        tamano = round(36 * PROPORCION)
        separacion = round(26 * PROPORCION)
        abajo = (ALTO_PRESPLASH - (LOGO_PRESPLASH + separacion + tamano)) / 2
        logo_grande = LogoNConPuntos(size=(LOGO_PRESPLASH, LOGO_PRESPLASH),
                                     pos=((ANCHO_PRESPLASH - LOGO_PRESPLASH) / 2,
                                          abajo + tamano + separacion))
        logo_grande.posar(LogoNConPuntos.POSE_FINAL)
        nombre = TextoEspaciado(partes=[('NEURO', theme.TEXTO), ('READ', theme.VERDE)],
                                tamano=tamano, espacio=PROPORCION, interlineado=1,
                                size=(ANCHO_PRESPLASH, tamano), pos=(0, abajo))
        self.presplash.add_widget(logo_grande)
        self.presplash.add_widget(nombre)
        raiz.add_widget(self.presplash)
        Clock.schedule_once(self.exportar_todo, 0.5)
        return raiz

    def exportar_todo(self, dt):
        exportar(self.icono, ICONO)
        exportar(self.presplash, PRESPLASH)
        self.stop()


if __name__ == '__main__':
    ExportarIconos().run()
