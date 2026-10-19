from datetime import date
from kivy.uix.screenmanager import Screen
from kivy.app import App
from kivy.metrics import dp, sp
from kivy.utils import get_hex_from_color
from screens.common import fecha_larga, plural, poner_texto
from data import db
from data.config import ACTIVIDADES_PARA_DESBLOQUEAR
from data.libros import libro_por_id, buscar_actividad, actividades_de_nivel
from data.niveles import (nivel_de, por_clave, siguiente_nivel, puntos_para_siguiente,
                          HABILIDADES, NIVELES)
import session
import theme


def habilidad_mas_baja(sesion):
    valores = [(sesion.get(k), k) for k in HABILIDADES if sesion and sesion.get(k) is not None]
    if not valores:
        return 'literal'
    return min(valores, key=lambda v: v[0])[1]


def actividades_faltantes(usuario_id, nivel, fecha):
    hechas = db.contar_actividades_desde(usuario_id, nivel, fecha)
    return max(ACTIVIDADES_PARA_DESBLOQUEAR - hechas, 0)


class InicioScreen(Screen):
    _actividad_en_curso = None
    _ultima_sesion = None

    def on_enter(self):
        self.actualizar()

    def actualizar(self):
        u = session.usuario
        if not u:
            return
        ultima = db.ultima_sesion(u['id'])
        puntaje = ultima['puntaje_global'] if ultima else 0
        nivel = nivel_de(puntaje) if ultima else (por_clave(u.get('nivel')) or nivel_de(0))
        self._encabezado(u)
        self._nivel(puntaje, nivel)
        self._neuroscore(ultima, nivel)
        self._objetivo(ultima)
        self._en_curso(u['id'])
        self._clasificatoria(u['id'], nivel, ultima)

    def _encabezado(self, u):
        self.ids.ini_fecha.text = fecha_larga(date.today())
        self.ids.ini_hola.text = f"Hola, {u['nombre']}"
        racha = db.estadisticas(u['id'])['racha']
        self.ids.ini_racha.text = plural(racha, 'día', 'días')

    def _nivel(self, puntaje, nivel):
        col = nivel['color']
        self.ids.ini_nivel.text = nivel['nombre']
        self.ids.ini_nivel.surface = col
        gris = get_hex_from_color(theme.TEXTO_SEC)
        poner_texto(self.ids.ini_puntaje, f'{puntaje}[size={int(sp(18))}][color={gris}]%[/color][/size]')
        self.ids.ini_puntaje.color = col
        barra = self.ids.ini_barra
        barra.value = puntaje
        barra.fill = col
        barra.marcas = [n['minimo'] for n in NIVELES if n['minimo'] > 0]
        siguiente = siguiente_nivel(nivel['clave'])
        if siguiente is None:
            barra.meta = -1
            self.ids.ini_faltan.text = 'Alcanzaste el nivel más alto'
            return
        barra.meta = siguiente['minimo']
        barra.color_meta = siguiente['color']
        faltan = puntos_para_siguiente(puntaje)
        claro = get_hex_from_color(theme.TEXTO)
        poner_texto(self.ids.ini_faltan,
                    f"Te faltan [b][color={claro}]{plural(faltan, 'punto', 'puntos')}[/color][/b] "
                    f"para llegar a\n{siguiente['nombre']} ({siguiente['minimo']}%)")

    def _neuroscore(self, ultima, nivel):
        enlace = self.ids.ini_neuroscore
        self._ultima_sesion = ultima['id'] if ultima else None
        visible = ultima is not None
        enlace.color = nivel['color']
        enlace.opacity = 1 if visible else 0
        enlace.disabled = not visible
        enlace.height = dp(48) if visible else 0

    def ver_neuroscore(self):
        if self._ultima_sesion is not None:
            App.get_running_app().abrir_neuroscore(self._ultima_sesion, 'inicio')

    def _objetivo(self, ultima):
        habilidad = HABILIDADES[habilidad_mas_baja(ultima)]
        self.ids.ini_obj_nombre.text = habilidad['nombre']
        self.ids.ini_obj_desc.text = habilidad['descripcion']

    def _en_curso(self, usuario_id):
        en_curso = db.obtener_actividad_en_curso(usuario_id)
        actividad = buscar_actividad(en_curso['actividad_id']) if en_curso else None
        libro = libro_por_id(actividad['libro_id']) if actividad else None
        self._actividad_en_curso = actividad['id'] if actividad else None
        ids = self.ids
        if libro is None:
            ids.ini_libro_portada.surface = theme.DORADO
            ids.ini_libro_icono.icon = 'ruta'
            ids.ini_libro_titulo.text = 'Empieza tu ruta'
            ids.ini_libro_detalle.text = 'Elige un libro y completa actividades para avanzar.'
            ids.ini_libro_barra.opacity = 0
            ids.ini_libro_btn.text = 'EMPEZAR'
            return
        ids.ini_libro_portada.surface = libro['color']
        ids.ini_libro_icono.icon = 'libro'
        ids.ini_libro_titulo.text = libro['titulo']
        del_libro = actividades_de_nivel(actividad['libro_id'], actividad['nivel'])
        ids.ini_libro_detalle.text = (f"Capítulo {actividad['capitulo_requerido']}, actividad "
                                      f"{actividad['orden']} de {len(del_libro)}")
        ids.ini_libro_barra.opacity = 1
        ids.ini_libro_barra.max = len(actividad['pasos'])
        ids.ini_libro_barra.value = min(en_curso.get('paso') or 0, len(actividad['pasos']))
        ids.ini_libro_barra.fill = libro['color']
        ids.ini_libro_btn.text = 'CONTINUAR'

    def _clasificatoria(self, usuario_id, nivel, ultima):
        fecha = ultima['fecha'] if ultima else None
        faltan = actividades_faltantes(usuario_id, nivel['clave'], fecha)
        ids = self.ids
        if faltan:
            ids.ini_clas_icono.icon = 'candado'
            ids.ini_clas_icono.color_glifo = theme.VIOLETA
            ids.ini_clas_texto.text = (f"Completa {plural(faltan, 'actividad', 'actividades')} "
                                       'más para desbloquearla')
        else:
            ids.ini_clas_icono.icon = 'evaluacion'
            ids.ini_clas_icono.color_glifo = theme.DORADO
            ids.ini_clas_texto.text = 'Ya puedes rendir tu evaluación'

    def continuar(self):
        app = App.get_running_app()
        if self._actividad_en_curso:
            app.abrir_actividad(self._actividad_en_curso, 'inicio')
        else:
            app.ir_a_pestana('ruta')

    def abrir_evaluacion(self):
        App.get_running_app().ir_a_pestana('evaluacion')
