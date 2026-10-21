from kivy.uix.screenmanager import Screen
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.metrics import dp, sp
from kivy.utils import get_hex_from_color
from widgets import NeoCard, NeoBar
from screens.common import wrap_label, insignia_diferencia, ajustar_alto, poner_texto, fecha_corta
from data import db
from data.niveles import nivel_de, por_clave, indice
from data.textos import BIBLIOTECA
import session
import theme

COLORES_MODULOS = theme.MODULE_COLORS_CODE
SALTO = chr(10)

NOMBRES = {
    'VEL': 'NeuroRead', 'COM': 'NeuroTest', 'INT': 'NeuroInsight',
    'IMA': 'NeuroCreative', 'CON': 'NeuroFocus', 'RET': 'NeuroMemory',
}

HABILIDAD = {
    'VEL': 'Velocidad lectora', 'COM': 'Comprensión',
    'INT': 'Interpretación', 'IMA': 'Creatividad',
    'CON': 'Concentración', 'RET': 'Memoria',
}

NOMBRE_NIVEL = {'FACIL': 'Fácil', 'NORMAL': 'Normal',
                'DIFICIL': 'Difícil', 'ULTRA': 'Ultra'}


def _proporcion(modulo):
    total = modulo.get('total', 0)
    return modulo['correctas'] / total if total else 0.0


MENSAJES_COMPARACION = {
    1: 'Subiste de nivel',
    0: 'Mantienes tu nivel',
    -1: 'Bajaste de nivel. Sigue practicando con tu ruta',
}


def calcular_porcentajes(s):
    prop_comp = _proporcion(s['comprension'])
    efectiva = s['velocidad']['wpm'] * prop_comp
    vel = min(efectiva / 240, 1.0) * 100
    comp = prop_comp * 100
    inter = s['interpretacion']['puntaje']
    imag = s['imaginacion']['puntaje']
    c = s['concentracion']
    if c['total'] == 0:
        conc = 0.0
    else:
        acc = c['aciertos'] / c['total']
        rapidez = max(0.0, min(c.get('rapidez', 0.0), 1.0))
        bono = 10 if c['ultra_superado'] else (6 if c['nivel_max'] == 'ULTRA' else 0)
        conc = min(acc * 70 + rapidez * 20 + bono, 100)
    ret = _proporcion(s['retencion']) * 100
    return {'VEL': vel, 'COM': comp, 'INT': inter,
            'IMA': imag, 'CON': conc, 'RET': ret}


CAMPOS_MODULO = {'VEL': 'velocidad', 'COM': 'comprension', 'INT': 'interpretacion',
                 'IMA': 'imaginacion', 'CON': 'concentracion', 'RET': 'retencion'}

DETALLE_RETENCION = 'Memoria diferida: recordar detalles minutos después de leer consolida el aprendizaje.'


def fortalezas_y_mejoras(pct):
    fortalezas = [HABILIDAD[k] for k, v in pct.items() if v >= 70]
    por_mejorar = [HABILIDAD[k] for k, v in pct.items() if v < 60]
    return (fortalezas[:3] or ['Sigue practicando, vas por buen camino'],
            por_mejorar[:3] or ['Todo en buen nivel, felicidades'])


def comparar(anterior, nivel_previo, total, nivel):
    cambio = indice(nivel['clave']) - indice(nivel_previo['clave'])
    signo = (cambio > 0) - (cambio < 0)
    return {'anterior': anterior, 'nuevo': total, 'diferencia': total - anterior,
            'mensaje': MENSAJES_COMPARACION[signo], 'signo': signo}


def _armar(total, nivel, pct, modulos, titulo, comparacion, encabezado):
    fortalezas, por_mejorar = fortalezas_y_mejoras(pct)
    return {'puntaje': total, 'nivel': nivel, 'pct': pct, 'modulos': modulos,
            'fortalezas': fortalezas, 'por_mejorar': por_mejorar, 'texto_titulo': titulo,
            'comparacion': comparacion, 'encabezado': encabezado}


def datos_sesion_actual(s):
    pct = calcular_porcentajes(s)
    total = round(sum(pct.values()) / len(pct))
    c = s['concentracion']
    focus_extra = 'NeuroUltra superado' if c['ultra_superado'] else (
        'Llegó a NeuroUltra' if c['nivel_max'] == 'ULTRA' else
        f"Nivel máximo: {NOMBRE_NIVEL.get(c['nivel_max'], c['nivel_max'].title())}")
    modulos = [
        ('VEL', f"{s['velocidad']['wpm']} PPM",
         f"Leíste el texto en {s['velocidad']['tiempo_total']}s. Un lector adulto promedio está entre 180 y 240 PPM."),
        ('COM', f"{s['comprension']['correctas']}/{s['comprension']['total']}",
         f"Literal: {s['comprension']['literal']}, inferencial: {s['comprension']['inferencial']}, crítica: {s['comprension']['critica']}"),
        ('INT', f"{round(pct['INT'])}%",
         f"Redactaste {s['interpretacion']['palabras_total']} palabras analizando emoción e intención del autor."),
        ('IMA', f"{round(pct['IMA'])}%",
         f"{s['imaginacion']['palabras']} palabras con {s['imaginacion']['riqueza']} descriptores sensoriales detectados."),
        ('CON', f"{c['aciertos']}/{c['total']}",
         f"{focus_extra}. Tiempo de reacción promedio: {c['tiempo_promedio']}s. Errores: {c['errores']}"),
        ('RET', f"{s['retencion']['correctas']}/{s['retencion']['total']}", DETALLE_RETENCION),
    ]
    return _armar(total, nivel_de(total), pct, modulos, s.get('texto_titulo', ''), None, None)


def _por_ciento(valor):
    return '--' if valor is None else f'{round(valor)}%'


def datos_sesion_guardada(sesion, previa):
    pct = {code: float(sesion.get(campo) or 0) for code, campo in CAMPOS_MODULO.items()}
    total = sesion['puntaje_global']
    nivel = por_clave(sesion.get('nivel')) or nivel_de(total)
    ppm, tiempo = sesion.get('ppm'), sesion.get('tiempo_lectura')
    velocidad = f'{ppm} PPM' if ppm is not None else _por_ciento(pct['VEL'])
    lectura = (f'Leíste el texto en {round(tiempo, 1):g}s. Un lector adulto promedio está entre 180 y 240 PPM.'
               if tiempo is not None else
               f"Obtuviste {_por_ciento(pct['VEL'])} en velocidad lectora.")
    modulos = [
        ('VEL', velocidad, lectura),
        ('COM', _por_ciento(pct['COM']),
         f"Literal: {_por_ciento(sesion.get('literal'))}, inferencial: {_por_ciento(sesion.get('inferencial'))}, "
         f"crítica: {_por_ciento(sesion.get('critica'))}"),
        ('INT', _por_ciento(pct['INT']),
         f"Obtuviste {_por_ciento(pct['INT'])} al analizar la emoción y la intención del autor."),
        ('IMA', _por_ciento(pct['IMA']),
         f"Obtuviste {_por_ciento(pct['IMA'])} en imaginación, creatividad y visualización."),
        ('CON', _por_ciento(pct['CON']),
         f"Obtuviste {_por_ciento(pct['CON'])} en atención y tiempo de reacción."),
        ('RET', _por_ciento(pct['RET']), DETALLE_RETENCION),
    ]
    comparacion = None
    if previa is not None:
        nivel_previo = por_clave(previa.get('nivel')) or nivel_de(previa['puntaje_global'])
        comparacion = comparar(previa['puntaje_global'], nivel_previo, total, nivel)
    texto = next((t['titulo'] for t in BIBLIOTECA if t['id'] == sesion.get('texto_id')), '')
    tipo = 'Evaluación inicial' if sesion.get('tipo') == 'inicial' else 'Clasificatoria'
    return _armar(total, nivel, pct, modulos, texto, comparacion, f"{tipo}, {fecha_corta(sesion['fecha'])}")


class ResultadosScreen(Screen):
    modo = 'nuevo'
    sesion_id = None
    origen = 'inicio'

    def consultar(self, sesion_id, origen):
        self.modo = 'consulta'
        self.sesion_id = sesion_id
        self.origen = origen

    def on_enter(self):
        datos = self._datos_consulta() if self.modo == 'consulta' else self._datos_nuevos()
        if datos is not None:
            self._dibujar(datos)
        self.ids.res_scroll.scroll_y = 1

    def on_leave(self):
        self.modo = 'nuevo'
        self.sesion_id = None

    def salir(self):
        App.get_running_app().ir_a_pestana(self.origen if self.modo == 'consulta' else 'inicio')

    def _datos_nuevos(self):
        s = session.session
        datos = datos_sesion_actual(s)
        session.puntaje_global = datos['puntaje']
        if session.usuario and not session.guardada:
            self._guardar(s, datos['puntaje'], datos['pct'])
            session.guardada = True
        datos['comparacion'] = session.comparacion
        return datos

    def _datos_consulta(self):
        u = session.usuario
        if not u:
            return None
        sesiones = db.historial_completo(u['id'])
        for i, sesion in enumerate(sesiones):
            if sesion['id'] == self.sesion_id:
                return datos_sesion_guardada(sesion, sesiones[i - 1] if i else None)
        return None

    def _dibujar(self, datos):
        ids = self.ids
        nivel = datos['nivel']
        consulta = datos['encabezado'] is not None
        ids.res_consulta.text = datos['encabezado'] or ''
        gris = get_hex_from_color(theme.TEXTO_SEC)
        poner_texto(ids.res_score, f"{datos['puntaje']}[size={int(sp(18))}][color={gris}]%[/color][/size]")
        ids.res_score.color = nivel['color']
        ids.res_nivel.text = nivel['nombre']
        ids.res_nivel.surface = nivel['color']
        poner_texto(ids.res_rango, f"{nivel['nombre']} va de {nivel['minimo']}% a {nivel['maximo']}%")
        ids.res_retro.text = nivel['retroalimentacion']
        self._mostrar_comparacion(datos['comparacion'])
        ids.res_titulo_texto.text = f"Texto evaluado: {datos['texto_titulo']}"
        ids.res_fortalezas.text = SALTO.join(datos['fortalezas'])
        ids.res_por_mejorar.text = SALTO.join(datos['por_mejorar'])
        ids.res_boton.text = 'VOLVER' if consulta else 'IR A INICIO'
        box = ids.res_cards
        box.clear_widgets()
        for code, valor, detalle in datos['modulos']:
            box.add_widget(self._make_card(code, valor, detalle, datos['pct'][code]))

    def _guardar(self, s, total, pct):
        u = session.usuario
        tipo = session.tipo_evaluacion
        nivel = nivel_de(total)
        if tipo == 'clasificatoria':
            session.comparacion = self._comparar(u, total, nivel)
        datos = {
            'tipo': tipo,
            'texto_id': s.get('texto_id'),
            'puntaje_global': total,
            'nivel': nivel['clave'],
            'velocidad': pct['VEL'], 'comprension': pct['COM'],
            'interpretacion': pct['INT'], 'imaginacion': pct['IMA'],
            'concentracion': pct['CON'], 'retencion': pct['RET'],
            'tiempo_lectura': s['velocidad']['tiempo_total'],
            'ppm': s['velocidad']['wpm'],
        }
        datos.update(s['comprension']['porcentajes'])
        db.guardar_sesion(u['id'], datos)
        if tipo == 'inicial':
            db.marcar_evaluacion_inicial(u['id'], nivel['clave'])
        else:
            db.actualizar_nivel(u['id'], nivel['clave'])
        session.usuario = db.obtener_usuario(u['id']) or u

    def _comparar(self, u, total, nivel):
        previa = db.ultima_sesion(u['id'])
        if previa is None:
            return None
        anterior = previa['puntaje_global']
        nivel_previo = por_clave(u.get('nivel')) or nivel_de(anterior)
        return comparar(anterior, nivel_previo, total, nivel)

    def _mostrar_comparacion(self, comp):
        card = self.ids.res_comp_card
        card.opacity = 1 if comp else 0
        if not comp:
            return
        poner_texto(self.ids.res_comp_anterior, f"{comp['anterior']}%")
        poner_texto(self.ids.res_comp_nuevo, f"{comp['nuevo']}%")
        texto, fondo, color = insignia_diferencia(comp['diferencia'])
        self.ids.res_comp_dif.text = texto
        self.ids.res_comp_dif.surface = fondo
        self.ids.res_comp_dif.color = color
        self.ids.res_comp_msg.text = comp['mensaje']
        self.ids.res_comp_msg.color = {1: theme.VERDE, 0: theme.DORADO,
                                       -1: theme.ROJO}[comp['signo']]

    def _make_card(self, code, valor, detalle, porcentaje):
        col = COLORES_MODULOS[code]
        card = ajustar_alto(NeoCard(orientation='vertical', padding=[dp(16), dp(12)], spacing=dp(8)))

        hdr = ajustar_alto(BoxLayout(spacing=dp(8)))
        titulo = wrap_label(NOMBRES[code], font_size='14.5sp', color=col)
        titulo.font_name = theme.F_DISPLAY
        titulo.pos_hint = {'top': 1}
        valor_lbl = wrap_label('', font_size='15sp', color=theme.TEXTO, halign='right')
        valor_lbl.font_name = theme.F_DISPLAY
        poner_texto(valor_lbl, valor)
        valor_lbl.size_hint_x = None
        valor_lbl.width = dp(120)
        valor_lbl.pos_hint = {'top': 1}
        hdr.add_widget(titulo)
        hdr.add_widget(valor_lbl)
        card.add_widget(hdr)

        card.add_widget(NeoBar(value=porcentaje, max=100, fill=col,
                               size_hint_y=None, height=dp(12)))

        card.add_widget(wrap_label(detalle, font_size='13sp', color=theme.TEXTO))
        return card
