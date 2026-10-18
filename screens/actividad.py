import random
from kivy.uix.screenmanager import Screen
from kivy.uix.boxlayout import BoxLayout
from kivy.factory import Factory
from kivy.metrics import dp
from kivy.app import App
from kivy.clock import Clock
from widgets import NeoChip, NeoButton
from screens.common import option_chip, marcar_opciones, wrap_label
from data import db
from data.actividades import por_id
from data.libros import libro_por_id
from data.niveles import HABILIDADES
from data.validacion import analizar_redaccion
import session
import theme


class ActividadScreen(Screen):
    _actividad = None
    _origen = 'ruta'
    _respuestas = []
    _respondido = False
    _chips = []
    _orden_elegido = []

    def on_kv_post(self, base_widget):
        ids = self.ids
        self._secciones = {'intro': ids.act_intro.__self__, 'paso': ids.act_paso.__self__,
                           'resumen': ids.act_resumen.__self__}
        for widget in self._secciones.values():
            widget.parent.remove_widget(widget)

    def abrir(self, actividad_id, origen='ruta'):
        self._actividad = por_id(actividad_id)
        self._origen = origen
        u = session.usuario
        progreso = db.obtener_progreso_actividad(u['id'], actividad_id) if u else None
        if progreso:
            self._respuestas = list(progreso['respuestas'] or [])
        else:
            self._respuestas = []
        self._mostrar_intro()

    def on_enter(self):
        if self._actividad and self.ids.act_contenido.children and \
                self.ids.act_contenido.children[0] is self._secciones['intro']:
            self._mostrar_intro()

    def _mostrar(self, nombre):
        caja = self.ids.act_contenido
        caja.clear_widgets()
        caja.add_widget(self._secciones[nombre])
        Clock.schedule_once(lambda dt: setattr(self.ids.act_scroll, 'scroll_y', 1), 0)

    def _leido(self):
        u = session.usuario
        a = self._actividad
        if not u:
            return False
        return a['capitulo_requerido'] in db.capitulos_leidos(u['id'], a['libro_id'])

    def _mostrar_intro(self):
        a = self._actividad
        if a is None:
            return
        libro = libro_por_id(a['libro_id'])
        habilidad = HABILIDADES[a['habilidad']]
        ids = self.ids
        ids.act_libro.text = libro['titulo'].upper()
        ids.act_libro.surface = libro['color']
        ids.act_titulo.text = a['titulo']
        ids.act_hab_nombre.text = habilidad['nombre']
        ids.act_hab_nombre.color = habilidad['color']
        ids.act_objetivo.text = a['objetivo']
        if self._leido():
            ids.act_bloqueo.text = ''
            ids.act_intro_btn.text = 'CONTINUAR' if self._respuestas else 'EMPEZAR'
            ids.act_intro_btn.surface = theme.VERDE
        else:
            ids.act_bloqueo.text = (f"Lee el capítulo {a['capitulo_requerido']} para "
                                    'desbloquear esta actividad')
            ids.act_intro_btn.text = 'LEER CAPÍTULO'
            ids.act_intro_btn.surface = theme.DORADO
        self._mostrar('intro')

    def accion_intro(self):
        a = self._actividad
        if not self._leido():
            App.get_running_app().abrir_lector(a['libro_id'], a['capitulo_requerido'],
                                               'actividad')
            return
        if len(self._respuestas) >= len(a['pasos']):
            self._finalizar()
            return
        self._mostrar('paso')
        self._cargar_paso()

    def _cargar_paso(self):
        a = self._actividad
        n = len(self._respuestas)
        paso = a['pasos'][n]
        ids = self.ids
        ids.act_paso_lbl.text = f"Paso {n + 1} de {len(a['pasos'])}"
        ids.act_paso_bar.max = len(a['pasos'])
        ids.act_paso_bar.value = n
        ids.act_feedback.text = ''
        self._respondido = False
        self._mostrar_siguiente(False)
        zona = ids.act_zona
        zona.clear_widgets()
        if paso['tipo'] == 'opcion':
            ids.act_enunciado.text = paso['pregunta']
            self._chips = []
            for i, texto in enumerate(paso['opciones']):
                chip = option_chip(f'{chr(65 + i)})  {texto}',
                                   lambda b, idx=i: self._responder_opcion(idx))
                self._chips.append(chip)
                zona.add_widget(chip)
        elif paso['tipo'] == 'ordenar':
            ids.act_enunciado.text = paso['instruccion']
            self._armar_ordenar(paso)
        else:
            ids.act_enunciado.text = paso['consigna']
            self._armar_escrita(paso)
        Clock.schedule_once(lambda dt: setattr(ids.act_scroll, 'scroll_y', 1), 0)

    def _mostrar_siguiente(self, visible):
        btn = self.ids.act_siguiente
        btn.opacity = 1 if visible else 0
        btn.disabled = not visible

    def _feedback(self, texto, ok):
        self.ids.act_feedback.text = texto
        self.ids.act_feedback.color = theme.VERDE if ok else theme.ROJO

    def _registrar(self, correcta, valor):
        a = self._actividad
        n = len(self._respuestas)
        self._respuestas.append({'paso': n, 'tipo': a['pasos'][n]['tipo'],
                                 'correcta': correcta, 'valor': valor})
        u = session.usuario
        if u:
            db.guardar_actividad_en_curso(u['id'], a['id'], len(self._respuestas),
                                          self._respuestas)
        self._respondido = True
        self.ids.act_paso_bar.value = len(self._respuestas)
        self._mostrar_siguiente(True)

    def _responder_opcion(self, idx):
        if self._respondido:
            return
        paso = self._actividad['pasos'][len(self._respuestas)]
        ok = idx == paso['correcta']
        marcar_opciones(self._chips, idx, paso['correcta'])
        if ok:
            self._feedback('¡Correcto!', True)
        else:
            self._feedback('Incorrecto. La respuesta correcta está en verde.', False)
        self._registrar(ok, idx)

    def _armar_ordenar(self, paso):
        zona = self.ids.act_zona
        self._orden_elegido = []
        elementos = list(paso['elementos'])
        mezcla = elementos[:]
        while len(mezcla) > 1 and mezcla == elementos:
            random.shuffle(mezcla)
        self._chips = []
        for texto in mezcla:
            chip = NeoChip(text=texto, font_size='13sp', font_name=theme.F_DISPLAY, bold=True,
                           halign='left', valign='middle',
                           size_hint_y=None, height=dp(56), padding=[dp(16), dp(10)])
            chip.texto_base = texto
            chip.bind(width=lambda c, w: setattr(c, 'text_size', (w - dp(32), None)))
            chip.bind(texture_size=lambda c, t: setattr(c, 'height', max(dp(56), t[1] + dp(22))))
            chip.bind(on_press=lambda c: self._elegir_orden(c))
            self._chips.append(chip)
            zona.add_widget(chip)
        botones = BoxLayout(size_hint_y=None, height=dp(52), spacing=dp(12))
        reiniciar = NeoButton(text='REINICIAR', surface=theme.TARJETA_ALT, color=theme.TEXTO,
                              font_size='14sp')
        reiniciar.bind(on_press=lambda *a: self._reiniciar_orden())
        comprobar = NeoButton(text='COMPROBAR', surface=theme.VERDE,
                              color=theme.TEXTO_OSCURO, font_size='14sp')
        comprobar.bind(on_press=lambda *a: self._comprobar_orden())
        botones.add_widget(reiniciar)
        botones.add_widget(comprobar)
        self._botones_orden = (reiniciar, comprobar)
        zona.add_widget(botones)

    def _elegir_orden(self, chip):
        if self._respondido or chip.texto_base in self._orden_elegido:
            return
        self._orden_elegido.append(chip.texto_base)
        chip.text = f'{len(self._orden_elegido)}. {chip.texto_base}'
        chip.surface = theme.DORADO
        chip.color = theme.TEXTO_OSCURO

    def _reiniciar_orden(self):
        if self._respondido:
            return
        self._orden_elegido = []
        self.ids.act_feedback.text = ''
        for chip in self._chips:
            chip.text = chip.texto_base
            chip.surface = theme.TARJETA_ALT
            chip.color = theme.TEXTO

    def _comprobar_orden(self):
        if self._respondido:
            return
        paso = self._actividad['pasos'][len(self._respuestas)]
        if len(self._orden_elegido) < len(paso['elementos']):
            self._feedback('Toca todos los elementos en el orden que creas correcto.', False)
            return
        ok = self._orden_elegido == paso['elementos']
        for chip in self._chips:
            chip.disabled = True
            bien = paso['elementos'].index(chip.texto_base) == \
                self._orden_elegido.index(chip.texto_base)
            chip.surface = theme.VERDE if bien else theme.ROJO
            chip.color = theme.TEXTO_OSCURO if bien else theme.TEXTO
        for b in self._botones_orden:
            b.disabled = True
            b.opacity = 0.5
        if ok:
            self._feedback('¡Correcto! El orden es el adecuado.', True)
        else:
            lineas = '\n'.join(f'{i + 1}. {t}' for i, t in enumerate(paso['elementos']))
            self._feedback(f'El orden no es correcto. El orden correcto es:\n{lineas}', False)
        self._registrar(ok, list(self._orden_elegido))

    def _armar_escrita(self, paso):
        zona = self.ids.act_zona
        campo = Factory.CampoTextoLargo(hint_text='Escribe tu respuesta aquí...')
        contador = wrap_label(f"0 palabras. Mínimo {paso['min_palabras']}.",
                              font_size='13sp', color=theme.TEXTO_SEC)

        def contar(inst, texto):
            n = len(texto.split())
            contador.text = f"{n} palabras. Mínimo {paso['min_palabras']}."
        campo.bind(text=contar)
        comprobar = NeoButton(text='COMPROBAR', surface=theme.VERDE,
                              color=theme.TEXTO_OSCURO, font_size='14sp',
                              size_hint_y=None, height=dp(52))
        comprobar.bind(on_press=lambda *a: self._comprobar_escrita(campo, comprobar))
        zona.add_widget(campo)
        zona.add_widget(contador)
        zona.add_widget(comprobar)

    def _comprobar_escrita(self, campo, boton):
        if self._respondido:
            return
        paso = self._actividad['pasos'][len(self._respuestas)]
        ok, msg, _ = analizar_redaccion(campo.text, min_palabras=paso['min_palabras'])
        if not ok:
            self._feedback(msg, False)
            return
        campo.readonly = True
        boton.disabled = True
        boton.opacity = 0.5
        self._feedback('Respuesta guardada.', True)
        self._registrar(True, campo.text.strip())

    def siguiente(self):
        if not self._respondido:
            return
        if len(self._respuestas) >= len(self._actividad['pasos']):
            self._finalizar()
        else:
            self._cargar_paso()

    def _finalizar(self):
        a = self._actividad
        aciertos = sum(1 for r in self._respuestas if r['correcta'])
        total = len(a['pasos'])
        u = session.usuario
        if u:
            db.guardar_actividad_completada(u['id'], a['id'], a['libro_id'], a['nivel'],
                                            aciertos, total, self._respuestas)
            db.borrar_actividad_en_curso(u['id'], a['id'])
        self._respuestas = []
        if aciertos == total:
            mensaje = 'Excelente trabajo. Respondiste todo correctamente.'
        elif aciertos * 2 >= total:
            mensaje = 'Buen trabajo. Revisa los pasos que fallaste para seguir mejorando.'
        else:
            mensaje = 'Sigue practicando. Vuelve a leer el texto y repite la actividad.'
        self.ids.act_resumen_txt.text = f'Aciertos: {aciertos} de {total}\n{mensaje}'
        self._mostrar('resumen')

    def volver(self):
        app = App.get_running_app()
        if self._origen == 'libro' and self._actividad:
            app.abrir_libro(self._actividad['libro_id'])
        else:
            app.ir_a_pestana(self._origen if self._origen in ('inicio', 'ruta') else 'ruta')

    def volver_a_ruta(self):
        App.get_running_app().ir_a_pestana('ruta')
