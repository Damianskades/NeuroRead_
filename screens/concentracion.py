import time
from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from kivy.app import App
from kivy.core.window import Window
from data import db
from data.focus import NIVELES, construir_ultra, elegir_items
import session
import theme

APROBAR = 4
PREP_SEG = 6


def aviso_tiempo(nivel):
    return f"{nivel['regla']}  (tienes {nivel['tiempo']:g} s por palabra)"


class ConcentracionScreen(Screen):
    _nivel_idx = 0
    _idx = 0
    _ok_nivel = _err_nivel = 0
    _ok_total = _err_total = 0
    _tiempos = []
    _rapidez = []
    _elegidas = {}
    _t0 = None
    _deadline = None
    _ev_timer = None
    _items = []
    _siguiente_nivel = None
    _ultra_superado = False
    _nivel_max = 'FACIL'
    _ev_prep = None
    _ev_pendiente = None
    _prep_fin = 0

    def on_enter(self):
        self._nivel_idx = 0
        self._ok_total = self._err_total = 0
        self._tiempos = []
        self._rapidez = []
        self._ultra_superado = False
        self._nivel_max = 'FACIL'
        self._elegir_palabras()
        self._ocultar_interstitial()
        self._ocultar_prep()
        Window.bind(focus=self._cambio_foco, on_minimize=self._salio)
        self._programar(lambda dt: self._cargar_nivel(0), 0.1)

    def on_leave(self):
        Window.unbind(focus=self._cambio_foco, on_minimize=self._salio)
        self._detener_timer()
        self._borrar_limite()
        self._t0 = None
        if self._ev_pendiente:
            self._ev_pendiente.cancel()
            self._ev_pendiente = None
        self._detener_prep()

    def _elegir_palabras(self):
        u = session.usuario
        usadas = db.palabras_usadas(u['id']) if u else []
        self._elegidas = {n['clave']: elegir_items(n['clave'], usadas)
                          for n in NIVELES if n['clave'] != 'ULTRA'}

    def _guardar_palabras(self):
        u = session.usuario
        if not u:
            return
        db.guardar_palabras_usadas(u['id'], [(clave, item['palabra'])
                                             for clave, items in self._elegidas.items()
                                             for item in items])

    def _cambio_foco(self, ventana, enfocada):
        if not enfocada:
            self._salio()

    def _salio(self, *a):
        if self._t0 is not None:
            self.responder(None, salida=True)

    def al_pausar(self):
        self._salio()

    def _programar(self, funcion, espera):
        if self._ev_pendiente:
            self._ev_pendiente.cancel()
        self._ev_pendiente = Clock.schedule_once(funcion, espera)

    def _nivel(self):
        return NIVELES[self._nivel_idx]

    def _cargar_nivel(self, idx):
        self._nivel_idx = idx
        self._idx = 0
        self._ok_nivel = self._err_nivel = 0
        nivel = self._nivel()
        self._nivel_max = nivel['clave']
        if nivel['clave'] == 'ULTRA':
            texto = session.texto_activo['texto'] if session.texto_activo else ''
            self._items = construir_ultra(texto)
        else:
            self._items = list(self._elegidas[nivel['clave']])
        self.ids.conc_nivel_badge.text = nivel['nombre']
        self.ids.conc_nivel_badge.surface = nivel['color']
        self.ids.conc_regla.text = aviso_tiempo(nivel)
        self.ids.conc_si.text = nivel['si']
        self.ids.conc_no.text = nivel['no']
        self.ids.conc_bar.max = len(self._items)
        self.ids.conc_bar.value = 0
        self.ids.conc_bar.fill = nivel['color']
        self.ids.conc_timerbar.opacity = 1
        self.ids.conc_timerbar.value = 0
        self._actualizar_marcadores()
        self._programar(lambda dt: self._mostrar(), 0.2)

    def _actualizar_marcadores(self):
        self.ids.conc_aciertos.text = f'Aciertos: {self._ok_total}'
        self.ids.conc_errores.text = f'Errores: {self._err_total}'

    def _mostrar(self):
        if self._idx >= len(self._items):
            self._fin_nivel()
            return
        item = self._items[self._idx]
        self.ids.conc_palabra.text = item['palabra']
        self.ids.conc_prog.text = f'Palabra {self._idx + 1} de {len(self._items)}'
        self.ids.conc_bar.value = self._idx
        self.ids.conc_feedback.text = ''
        self.ids.conc_si.disabled = False
        self.ids.conc_no.disabled = False
        self._detener_timer()
        self._t0 = time.time()
        self._deadline = self._t0 + self._nivel()['tiempo']
        self.ids.conc_timerbar.value = 100
        self._ev_timer = Clock.schedule_interval(self._tick_timer, 0.05)

    def _tick_timer(self, dt):
        if self._deadline is None:
            return False
        restante = self._deadline - time.time()
        total = self._nivel()['tiempo']
        self.ids.conc_timerbar.value = max(0, (restante / total) * 100)
        if restante <= 0:
            self.responder(None)
            return False

    def _detener_timer(self):
        if self._ev_timer:
            self._ev_timer.cancel()
            self._ev_timer = None

    def _borrar_limite(self):
        self._deadline = None

    def responder(self, es_si, salida=False):
        if self._t0 is None:
            return
        t = time.time() - self._t0
        limite = self._nivel()['tiempo']
        self._t0 = None
        self._detener_timer()
        self._borrar_limite()
        self._tiempos.append(min(t, limite))
        item = self._items[self._idx]
        self.ids.conc_si.disabled = True
        self.ids.conc_no.disabled = True
        if salida:
            self._err_nivel += 1
            self._err_total += 1
            self.ids.conc_feedback.text = 'Saliste de la evaluación'
            self.ids.conc_feedback.color = theme.ROJO
        elif es_si is None or t > limite:
            self._err_nivel += 1
            self._err_total += 1
            self.ids.conc_feedback.text = '¡Tiempo agotado!'
            self.ids.conc_feedback.color = theme.ROJO
        elif es_si == item['ok']:
            self._rapidez.append(max(0.0, 1 - t / limite))
            self._ok_nivel += 1
            self._ok_total += 1
            self.ids.conc_feedback.text = f'Correcto ({t:.2f}s)'
            self.ids.conc_feedback.color = theme.VERDE
        else:
            self._rapidez.append(max(0.0, 1 - t / limite))
            self._err_nivel += 1
            self._err_total += 1
            self.ids.conc_feedback.text = f'Error ({t:.2f}s)'
            self.ids.conc_feedback.color = theme.ROJO
        self._actualizar_marcadores()
        self._idx += 1
        self._programar(lambda dt: self._mostrar(), 0.9)

    def _fin_nivel(self):
        self._detener_timer()
        self._borrar_limite()
        self.ids.conc_bar.value = len(self._items)
        nivel = self._nivel()
        paso = self._ok_nivel >= APROBAR
        stats = f'Resultado del nivel: {self._ok_nivel} aciertos y {self._err_nivel} errores de {len(self._items)}.'
        if nivel['clave'] in ('FACIL', 'NORMAL'):
            self._siguiente_nivel = self._nivel_idx + 1
            prox = NIVELES[self._siguiente_nivel]['nombre'].title()
            titulo = '¡NIVEL SUPERADO!' if paso else 'NIVEL COMPLETADO'
            detalle = f'{stats}\nAhora sube la exigencia: pasas al {prox}.'
        elif nivel['clave'] == 'DIFICIL':
            if paso:
                self._siguiente_nivel = self._nivel_idx + 1
                titulo = '¡NEUROULTRA DESBLOQUEADO!'
                detalle = (f'{stats}\nSuperaste el modo difícil. Se activa NeuroUltra: '
                           'palabras de tu propia lectura contra reloj.')
            else:
                self._siguiente_nivel = None
                titulo = 'NIVEL DIFÍCIL COMPLETADO'
                detalle = (f'{stats}\nNecesitabas {APROBAR} aciertos para NeuroUltra. '
                           'Te quedas en Difícil y continúas a NeuroMemory.')
        else:
            self._siguiente_nivel = None
            self._ultra_superado = paso
            titulo = '¡NEUROULTRA SUPERADO!' if paso else 'NEUROULTRA COMPLETADO'
            detalle = f'{stats}\nFin de NeuroFocus. Continúa a NeuroMemory.'
        self.ids.conc_inter_titulo.text = titulo
        self.ids.conc_inter_titulo.color = nivel['color']
        self.ids.conc_inter_detalle.text = detalle
        self.ids.conc_inter_btn.surface = nivel['color']
        self._mostrar_interstitial()

    def _mostrar_interstitial(self):
        self.ids.conc_si.disabled = True
        self.ids.conc_no.disabled = True
        self.ids.conc_inter_card.opacity = 1
        self.ids.conc_inter_card.disabled = False

    def _ocultar_interstitial(self):
        self.ids.conc_inter_card.opacity = 0
        self.ids.conc_inter_card.disabled = True

    def continuar(self):
        self._ocultar_interstitial()
        if self._siguiente_nivel is not None:
            self._iniciar_prep()
        else:
            self._terminar()

    def _iniciar_prep(self):
        nivel = NIVELES[self._siguiente_nivel]
        self.ids.conc_prep_nombre.text = nivel['nombre']
        self.ids.conc_prep_nombre.color = nivel['color']
        self.ids.conc_prep_regla.text = aviso_tiempo(nivel)
        self.ids.conc_prep_bar.fill = nivel['color']
        self.ids.conc_prep_bar.value = 0
        self.ids.conc_prep_count.text = str(PREP_SEG)
        self.ids.conc_prep_count.color = nivel['color']
        self.ids.conc_prep_layer.opacity = 1
        self._prep_fin = time.time() + PREP_SEG
        self._detener_prep()
        self._ev_prep = Clock.schedule_interval(self._tick_prep, 0.05)

    def _tick_prep(self, dt):
        restante = self._prep_fin - time.time()
        frac = 1 - max(restante, 0) / PREP_SEG
        self.ids.conc_prep_bar.value = frac * 100
        self.ids.conc_prep_count.text = (
            str(int(restante) + 1) if restante > 0 else '¡YA!')
        if restante <= 0:
            self._detener_prep()
            self._ocultar_prep()
            self._cargar_nivel(self._siguiente_nivel)
            return False

    def _detener_prep(self):
        if self._ev_prep:
            Clock.unschedule(self._ev_prep)
            self._ev_prep = None

    def _ocultar_prep(self):
        self.ids.conc_prep_layer.opacity = 0

    def _terminar(self):
        total = self._ok_total + self._err_total
        t_prom = sum(self._tiempos) / len(self._tiempos) if self._tiempos else 0
        rapidez = sum(self._rapidez) / len(self._rapidez) if self._rapidez else 0.0
        self._guardar_palabras()
        session.session['concentracion'].update({
            'aciertos': self._ok_total,
            'errores': self._err_total,
            'total': total,
            'tiempo_promedio': round(t_prom, 2),
            'rapidez': round(rapidez, 4),
            'nivel_max': self._nivel_max,
            'ultra_superado': self._ultra_superado,
        })
        App.get_running_app().ir_a('retencion')
