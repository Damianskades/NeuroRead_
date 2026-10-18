from kivy.uix.screenmanager import Screen
from kivy.uix.boxlayout import BoxLayout
from kivy.metrics import dp
from widgets import NeoCard, NeoBar
from screens.common import wrap_label, insignia_diferencia, ajustar_alto
from data import db
from data.niveles import nivel_de, por_clave, indice
import session
import theme

COLORES_MODULOS = theme.MODULE_COLORS_CODE

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
        rapidez = max(0.0, min((2.0 - c['tiempo_promedio']) / 2.0, 1.0))
        bono = 10 if c['ultra_superado'] else (6 if c['nivel_max'] == 'ULTRA' else 0)
        conc = min(acc * 70 + rapidez * 20 + bono, 100)
    ret = _proporcion(s['retencion']) * 100
    return {'VEL': vel, 'COM': comp, 'INT': inter,
            'IMA': imag, 'CON': conc, 'RET': ret}


class ResultadosScreen(Screen):
    def on_enter(self):
        self._calcular_y_mostrar()

    def _calcular_y_mostrar(self):
        s = session.session
        pct = calcular_porcentajes(s)
        total = round(sum(pct.values()) / len(pct))
        session.puntaje_global = total

        if session.usuario and not session.guardada:
            self._guardar(s, total, pct)
            session.guardada = True

        nivel = nivel_de(total)
        self.ids.res_score.text = f'{total}/100'
        self.ids.res_score.color = nivel['color']
        self.ids.res_nivel.text = nivel['nombre']
        self.ids.res_nivel.surface = nivel['color']
        self.ids.res_retro.text = nivel['retroalimentacion']
        self._mostrar_comparacion(session.comparacion)
        self.ids.res_titulo_texto.text = f'Texto evaluado: {s.get("texto_titulo", "")}'

        fortalezas = [HABILIDAD[k] for k, v in pct.items() if v >= 70]
        por_mejorar = [HABILIDAD[k] for k, v in pct.items() if v < 60]
        if not fortalezas:
            fortalezas = ['Sigue practicando, vas por buen camino']
        if not por_mejorar:
            por_mejorar = ['Todo en buen nivel, felicidades']
        self.ids.res_fortalezas.text = '\n'.join(fortalezas[:3])
        self.ids.res_por_mejorar.text = '\n'.join(por_mejorar[:3])

        c = s['concentracion']
        focus_extra = 'NeuroUltra superado' if c['ultra_superado'] else (
            'Llegó a NeuroUltra' if c['nivel_max'] == 'ULTRA' else
            f"Nivel máximo: {NOMBRE_NIVEL.get(c['nivel_max'], c['nivel_max'].title())}")
        datos = [
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
            ('RET', f"{s['retencion']['correctas']}/{s['retencion']['total']}",
             'Memoria diferida: recordar detalles minutos después de leer consolida el aprendizaje.'),
        ]

        box = self.ids.res_cards
        box.clear_widgets()
        for code, valor, detalle in datos:
            box.add_widget(self._make_card(code, valor, detalle, pct[code]))

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
        cambio = indice(nivel['clave']) - indice(nivel_previo['clave'])
        signo = (cambio > 0) - (cambio < 0)
        return {'anterior': anterior, 'nuevo': total,
                'diferencia': total - anterior,
                'mensaje': MENSAJES_COMPARACION[signo], 'signo': signo}

    def _mostrar_comparacion(self, comp):
        card = self.ids.res_comp_card
        card.opacity = 1 if comp else 0
        if not comp:
            return
        self.ids.res_comp_anterior.text = str(comp['anterior'])
        self.ids.res_comp_nuevo.text = str(comp['nuevo'])
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
        valor_lbl = wrap_label(valor, font_size='15sp', color=theme.TEXTO, halign='right')
        valor_lbl.font_name = theme.F_DISPLAY
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
