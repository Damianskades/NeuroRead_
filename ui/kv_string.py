KV = """
#:import theme theme
#:import dp kivy.metrics.dp
#:import config data.config
#:import hexc kivy.utils.get_hex_from_color

<Label>:
    font_hinting: theme.HINTING
    on_texture: theme.textura_nitida(self.texture)

<L@Label>:
    font_name: theme.F_BODY
    color: theme.TEXTO

<LSec@L>:
    color: theme.TEXTO_SEC

<LDisplay@Label>:
    font_name: theme.F_DISPLAY
    color: theme.TEXTO
    outline_width: 1
    outline_color: theme.BORDE

<SectionTitle@LDisplay>:
    font_size: '13sp'
    color: theme.TEXTO_SEC
    outline_width: 0
    halign: 'left'
    valign: 'middle'
    padding: [0, dp(4)]
    text_size: self.width, None
    size_hint_y: None
    height: self.texture_size[1]

<Etiqueta@LSec>:
    font_size: '13sp'
    font_name: theme.F_DISPLAY
    bold: True
    halign: 'left'
    valign: 'middle'
    text_size: self.width, None
    size_hint_y: None
    height: self.texture_size[1]

<CampoTexto@TextInput>:
    font_name: theme.F_BODY
    font_size: '14sp'
    foreground_color: theme.TEXTO
    background_normal: ''
    background_active: ''
    background_color: theme.TARJETA_ALT
    cursor_color: theme.DORADO
    hint_text_color: theme.TEXTO_SEC
    multiline: False
    write_tab: False
    padding: [dp(14), dp(14)]
    size_hint_y: None
    height: dp(48)
    canvas.after:
        Color:
            rgba: theme.BORDE
        Line:
            rectangle: (self.x, self.y, self.width, self.height)
            width: dp(2)

<CampoTextoLargo@CampoTexto>:
    multiline: True
    height: dp(150)
    padding: [dp(14), dp(12)]

<BotonBloqueado@Label>:
    font_name: theme.F_DISPLAY
    font_size: '14sp'
    color: theme.TEXTO_SEC
    halign: 'center'
    valign: 'middle'
    text_size: self.size
    size_hint_y: None
    height: dp(50)
    canvas.before:
        Color:
            rgba: theme.TARJETA_ALT
        RoundedRectangle:
            pos: self.pos
            size: self.size
            radius: [dp(14)]
        Color:
            rgba: theme.TEXTO_SEC
        Line:
            rounded_rectangle: (self.x + 1, self.y + 1, self.width - 2, self.height - 2, dp(14))
            dash_length: dp(6)
            dash_offset: dp(4)
            width: 1

<CirculoNumero@Label>:
    fondo: theme.DORADO
    font_name: theme.F_DISPLAY
    font_size: '14sp'
    color: theme.TEXTO_OSCURO
    size_hint: None, None
    size: dp(30), dp(30)
    canvas.before:
        Color:
            rgba: self.fondo or theme.DORADO
        Ellipse:
            pos: self.pos
            size: self.size
        Color:
            rgba: theme.BORDE
        Line:
            circle: (self.center_x, self.center_y, self.width / 2)
            width: dp(1.5)

<PasoComoFunciona@BoxLayout>:
    numero: '1'
    fondo: theme.DORADO
    titulo: ''
    texto: ''
    size_hint_y: None
    height: self.minimum_height
    spacing: dp(12)
    CirculoNumero:
        text: root.numero
        fondo: root.fondo
        pos_hint: {'top': 1}
    BoxLayout:
        orientation: 'vertical'
        spacing: dp(2)
        size_hint_y: None
        height: self.minimum_height
        pos_hint: {'top': 1}
        L:
            text: root.titulo
            font_size: '14sp'
            bold: True
            halign: 'left'
            valign: 'top'
            text_size: self.width, None
            size_hint_y: None
            height: self.texture_size[1]
        LSec:
            text: root.texto
            font_size: '13sp'
            font_name: theme.F_DISPLAY
            bold: True
            color: theme.TEXTO
            halign: 'left'
            valign: 'top'
            text_size: self.width, None
            size_hint_y: None
            height: self.texture_size[1]

<TarjetaModulo@NeoCard>:
    color_mod: theme.DORADO
    nombre: ''
    habilidad: ''
    surface: theme.TARJETA_ALT
    radius: dp(14)
    shadow_off: dp(3)
    orientation: 'vertical'
    padding: [dp(12), dp(16), dp(12), dp(10)]
    spacing: dp(2)
    size_hint_y: None
    height: self.minimum_height
    canvas:
        Color:
            rgba: self.color_mod or theme.DORADO
        RoundedRectangle:
            pos: self.x + dp(2), self.top - dp(8)
            size: self.width - dp(4), dp(6)
            radius: [dp(12), dp(12), 0, 0]
    L:
        text: root.nombre
        font_name: theme.F_DISPLAY
        font_size: '13sp'
        bold: True
        halign: 'left'
        valign: 'top'
        text_size: self.width, None
        size_hint_y: None
        height: self.texture_size[1]
    LSec:
        text: root.habilidad
        font_size: '13sp'
        font_name: theme.F_DISPLAY
        bold: True
        halign: 'left'
        valign: 'top'
        text_size: self.width, None
        size_hint_y: None
        height: self.texture_size[1]

<CirculoInicial@Label>:
    font_name: theme.F_DISPLAY
    font_size: '28sp'
    color: theme.TEXTO_OSCURO
    size_hint: None, None
    size: dp(64), dp(64)
    canvas.before:
        Color:
            rgba: theme.BORDE
        Ellipse:
            pos: self.x + dp(3), self.y - dp(3)
            size: self.size
        Color:
            rgba: theme.DORADO
        Ellipse:
            pos: self.pos
            size: self.size
        Color:
            rgba: theme.BORDE
        Line:
            circle: (self.center_x, self.center_y, self.width / 2)
            width: dp(2)

<Enlace@ButtonBehavior+Label>:
    font_name: theme.F_DISPLAY
    font_size: '13sp'
    bold: True
    color: theme.DORADO
    halign: 'center'
    valign: 'middle'
    text_size: self.size
    size_hint_y: None
    height: dp(48)

<ErrorFormulario@L>:
    text: ''
    font_size: '13sp'
    font_name: theme.F_DISPLAY
    bold: True
    color: theme.ROJO
    halign: 'center'
    valign: 'middle'
    text_size: self.width, None
    size_hint_y: None
    height: max(self.texture_size[1], dp(24))

<ModHeader@NeoCard>:
    icono: 'book'
    titulo: ''
    subtitulo: ''
    chip_color: theme.DORADO
    surface: theme.TARJETA
    size_hint_y: None
    height: self.minimum_height
    padding: [dp(16), dp(12)]
    spacing: dp(12)
    NeoIcon:
        icon: root.icono
        color_chip: root.chip_color
        size: dp(48), dp(48)
        pos_hint: {'top': 1}
    BoxLayout:
        orientation: 'vertical'
        spacing: dp(2)
        size_hint_y: None
        height: self.minimum_height
        pos_hint: {'top': 1}
        LDisplay:
            text: root.titulo
            font_size: '20sp'
            color: root.chip_color
            halign: 'left'
            valign: 'top'
            text_size: self.width, None
            size_hint_y: None
            height: self.texture_size[1]
        LSec:
            text: root.subtitulo
            font_size: '13sp'
            font_name: theme.F_DISPLAY
            bold: True
            halign: 'left'
            valign: 'top'
            text_size: self.width, None
            size_hint_y: None
            height: self.texture_size[1]

ScreenManager:
    SplashScreen:
        name: 'splash'
    LoginScreen:
        name: 'login'
    RegistroScreen:
        name: 'registro'
    PrincipalScreen:
        name: 'principal'
    LectorScreen:
        name: 'lector'
    ActividadScreen:
        name: 'actividad'
    BienvenidaEvaluacionScreen:
        name: 'bienvenida_evaluacion'
    VelocidadScreen:
        name: 'velocidad'
    ComprensionScreen:
        name: 'comprension'
    InterpretacionScreen:
        name: 'interpretacion'
    ImaginacionScreen:
        name: 'imaginacion'
    ConcentracionScreen:
        name: 'concentracion'
    RetencionScreen:
        name: 'retencion'
    ResultadosScreen:
        name: 'resultados'
    EditarPerfilScreen:
        name: 'editar_perfil'

<TarjetaTocable@ButtonBehavior+NeoCard>:
    orientation: 'horizontal'

<InicioScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        do_scroll_x: False
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(40), dp(20), dp(24)]
            spacing: dp(18)
            size_hint_y: None
            height: self.minimum_height
            BoxLayout:
                size_hint_y: None
                height: self.minimum_height
                spacing: dp(12)
                BoxLayout:
                    orientation: 'vertical'
                    spacing: dp(2)
                    size_hint_y: None
                    height: self.minimum_height
                    pos_hint: {'top': 1}
                    LSec:
                        id: ini_fecha
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LDisplay:
                        id: ini_hola
                        text: ''
                        font_size: '26sp'
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                NeoCard:
                    surface: theme.TARJETA_ALT
                    radius: dp(12)
                    shadow_off: dp(3)
                    padding: [dp(10), dp(10)]
                    spacing: dp(6)
                    size_hint: None, None
                    width: dp(104)
                    height: self.minimum_height
                    pos_hint: {'top': 1}
                    NeoIcon:
                        icon: 'llama'
                        marco: False
                        color_glifo: theme.NARANJA
                        size: dp(22), dp(22)
                        pos_hint: {'top': 1}
                    L:
                        id: ini_racha
                        text: '0 días'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: max(dp(22), self.texture_size[1])
                        pos_hint: {'top': 1}
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(18), dp(16)]
                spacing: dp(10)
                size_hint_y: None
                height: self.minimum_height
                BoxLayout:
                    size_hint_y: None
                    height: self.minimum_height
                    spacing: dp(12)
                    NeoBadge:
                        id: ini_nivel
                        text: ''
                        font_size: '11sp'
                        size_hint: None, None
                        size: dp(128), dp(24)
                        pos_hint: {'top': 1}
                    LSec:
                        text: 'Tu nivel actual'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'right'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: max(dp(24), self.texture_size[1])
                        pos_hint: {'top': 1}
                LDisplay:
                    id: ini_puntaje
                    markup: True
                    text: '0'
                    font_size: '52sp'
                    halign: 'left'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: max(dp(68), self.texture_size[1])
                NeoBar:
                    id: ini_barra
                    max: 100
                    value: 0
                    size_hint_y: None
                    height: dp(14)
                LSec:
                    id: ini_faltan
                    markup: True
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.TEXTO
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                Enlace:
                    id: ini_neuroscore
                    text: 'VER MI NEUROSCORE'
                    halign: 'left'
                    on_press: root.ver_neuroscore()
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                padding: [dp(16), dp(14)]
                spacing: dp(14)
                size_hint_y: None
                height: self.minimum_height
                NeoIcon:
                    icon: 'bombilla'
                    color_chip: theme.AZUL
                    size: dp(46), dp(46)
                    pos_hint: {'top': 1}
                BoxLayout:
                    orientation: 'vertical'
                    spacing: dp(4)
                    size_hint_y: None
                    height: self.minimum_height
                    pos_hint: {'top': 1}
                    Etiqueta:
                        text: 'OBJETIVO DE HOY'
                    LDisplay:
                        id: ini_obj_nombre
                        text: ''
                        font_size: '16sp'
                        outline_width: 0
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        id: ini_obj_desc
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        color: theme.TEXTO
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(16), dp(14)]
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height
                Etiqueta:
                    text: 'CONTINÚA DONDE TE QUEDASTE'
                BoxLayout:
                    size_hint_y: None
                    height: self.minimum_height
                    spacing: dp(14)
                    NeoCard:
                        id: ini_libro_portada
                        surface: theme.DORADO
                        radius: dp(8)
                        shadow_off: dp(3)
                        size_hint: None, None
                        size: dp(52), dp(68)
                        pos_hint: {'top': 1}
                        AnchorLayout:
                            NeoIcon:
                                id: ini_libro_icono
                                icon: 'ruta'
                                marco: False
                                color_glifo: theme.TEXTO_OSCURO
                                size: dp(34), dp(34)
                    BoxLayout:
                        orientation: 'vertical'
                        spacing: dp(4)
                        size_hint_y: None
                        height: self.minimum_height
                        pos_hint: {'top': 1}
                        LDisplay:
                            id: ini_libro_titulo
                            text: ''
                            font_size: '16sp'
                            outline_width: 0
                            halign: 'left'
                            valign: 'top'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        LSec:
                            id: ini_libro_detalle
                            text: ''
                            font_size: '13sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            halign: 'left'
                            valign: 'top'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        NeoBar:
                            id: ini_libro_barra
                            max: 1
                            value: 0
                            radius: dp(5)
                            size_hint_y: None
                            height: dp(10)
                        Widget:
                            size_hint_y: None
                            height: dp(2)
                NeoButton:
                    id: ini_libro_btn
                    text: 'EMPEZAR'
                    surface: theme.VERDE
                    color: theme.TEXTO_OSCURO
                    font_size: '15sp'
                    size_hint_y: None
                    height: dp(52)
                    on_press: root.continuar()
            TarjetaTocable:
                surface: theme.TARJETA_ALT
                radius: dp(18)
                padding: [dp(16), dp(14)]
                spacing: dp(14)
                size_hint_y: None
                height: self.minimum_height
                on_press: root.abrir_evaluacion()
                NeoIcon:
                    id: ini_clas_icono
                    icon: 'candado'
                    color_chip: theme.FONDO
                    color_glifo: theme.VIOLETA
                    size: dp(40), dp(40)
                    pos_hint: {'top': 1}
                BoxLayout:
                    orientation: 'vertical'
                    spacing: dp(4)
                    size_hint_y: None
                    height: self.minimum_height
                    pos_hint: {'top': 1}
                    LDisplay:
                        text: 'Evaluación clasificatoria'
                        font_size: '16sp'
                        outline_width: 0
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        id: ini_clas_texto
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        color: theme.TEXTO
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]

<RutaScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        do_scroll_x: False
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(40), dp(20), dp(24)]
            spacing: dp(18)
            size_hint_y: None
            height: self.minimum_height
            BoxLayout:
                orientation: 'vertical'
                spacing: dp(4)
                size_hint_y: None
                height: self.minimum_height
                LDisplay:
                    text: 'Tu ruta'
                    font_size: '26sp'
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                LSec:
                    id: ruta_frase
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.TEXTO
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(18), dp(16)]
                spacing: dp(10)
                size_hint_y: None
                height: self.minimum_height
                BoxLayout:
                    size_hint_y: None
                    height: self.minimum_height
                    spacing: dp(8)
                    Etiqueta:
                        text: 'PROGRESO HACIA LA EVALUACIÓN'
                        pos_hint: {'top': 1}
                    LDisplay:
                        id: ruta_progreso
                        text: ''
                        font_size: '15sp'
                        outline_width: 0
                        color: theme.VIOLETA
                        halign: 'right'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint: None, None
                        width: dp(70)
                        height: self.texture_size[1]
                        pos_hint: {'top': 1}
                NeoBar:
                    id: ruta_barra
                    fill: theme.VIOLETA
                    max: 4
                    value: 0
                    size_hint_y: None
                    height: dp(14)
                LSec:
                    id: ruta_meta
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.TEXTO
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
            BoxLayout:
                size_hint_y: None
                height: dp(48)
                spacing: dp(10)
                NeoChip:
                    id: ruta_filtro_todas
                    text: 'Todas'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.size
                    on_press: root.elegir_filtro('todas')
                NeoChip:
                    id: ruta_filtro_pendientes
                    text: 'Pendientes'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.size
                    on_press: root.elegir_filtro('pendientes')
                NeoChip:
                    id: ruta_filtro_completadas
                    text: 'Completadas'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.size
                    on_press: root.elegir_filtro('completadas')
            BoxLayout:
                id: ruta_lista
                orientation: 'vertical'
                spacing: dp(18)
                size_hint_y: None
                height: self.minimum_height

<ActividadScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(20), dp(36), dp(20), dp(16)]
        spacing: dp(12)
        BoxLayout:
            size_hint_y: None
            height: dp(48)
            spacing: dp(10)
            NeoBotonIcono:
                texto: 'VOLVER'
                icono: 'volver'
                on_press: root.volver()
            Widget:
            NeoBadge:
                id: act_libro
                text: ''
                surface: theme.VERDE
                font_size: '11sp'
                size_hint: None, None
                size: max(dp(120), self.texture_size[0] + dp(20)), dp(26)
                pos_hint: {'center_y': 0.5}
        ScrollView:
            id: act_scroll
            do_scroll_x: False
            BoxLayout:
                orientation: 'vertical'
                spacing: dp(18)
                padding: [0, dp(4), dp(4), dp(12)]
                size_hint_y: None
                height: self.minimum_height
                LDisplay:
                    id: act_titulo
                    text: ''
                    font_size: '20sp'
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                BoxLayout:
                    id: act_contenido
                    orientation: 'vertical'
                    size_hint_y: None
                    height: self.minimum_height
                    NeoCard:
                        id: act_intro
                        surface: theme.TARJETA
                        radius: dp(18)
                        orientation: 'vertical'
                        padding: [dp(18), dp(16)]
                        spacing: dp(10)
                        size_hint_y: None
                        height: self.minimum_height
                        Etiqueta:
                            text: 'OBJETIVO DE LECTURA'
                        LDisplay:
                            id: act_hab_nombre
                            text: ''
                            font_size: '16sp'
                            outline_width: 0
                            halign: 'left'
                            valign: 'top'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        L:
                            id: act_objetivo
                            text: ''
                            font_size: '13sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            halign: 'left'
                            valign: 'top'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        L:
                            id: act_bloqueo
                            text: ''
                            font_size: '13sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            color: theme.NARANJA
                            halign: 'left'
                            valign: 'top'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        Widget:
                            size_hint_y: None
                            height: dp(2)
                        NeoButton:
                            id: act_intro_btn
                            text: 'EMPEZAR'
                            surface: theme.VERDE
                            color: theme.TEXTO_OSCURO
                            font_size: '15sp'
                            size_hint_y: None
                            height: dp(52)
                            on_press: root.accion_intro()
                    BoxLayout:
                        id: act_paso
                        orientation: 'vertical'
                        spacing: dp(12)
                        size_hint_y: None
                        height: self.minimum_height
                        Etiqueta:
                            id: act_paso_lbl
                            text: ''
                        NeoBar:
                            id: act_paso_bar
                            fill: theme.DORADO
                            max: 1
                            value: 0
                            size_hint_y: None
                            height: dp(12)
                        NeoCard:
                            surface: theme.TARJETA
                            radius: dp(16)
                            size_hint_y: None
                            height: self.minimum_height
                            padding: [dp(16), dp(15)]
                            L:
                                id: act_enunciado
                                text: ''
                                font_size: '14.5sp'
                                bold: True
                                halign: 'left'
                                valign: 'top'
                                text_size: self.width, None
                                size_hint_y: None
                                height: self.texture_size[1]
                        BoxLayout:
                            id: act_zona
                            orientation: 'vertical'
                            spacing: dp(12)
                            padding: [0, dp(2), dp(4), dp(4)]
                            size_hint_y: None
                            height: self.minimum_height
                        L:
                            id: act_feedback
                            text: ''
                            font_size: '13.5sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            halign: 'left'
                            valign: 'top'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        NeoButton:
                            id: act_siguiente
                            text: 'SIGUIENTE'
                            surface: theme.DORADO
                            color: theme.TEXTO_OSCURO
                            font_size: '15sp'
                            size_hint_y: None
                            height: dp(52)
                            on_press: root.siguiente()
                    NeoCard:
                        id: act_resumen
                        surface: theme.TARJETA
                        radius: dp(18)
                        orientation: 'vertical'
                        padding: [dp(18), dp(18)]
                        spacing: dp(12)
                        size_hint_y: None
                        height: self.minimum_height
                        BoxLayout:
                            size_hint_y: None
                            height: self.minimum_height
                            spacing: dp(12)
                            NeoIcon:
                                icon: 'trofeo'
                                color_chip: theme.DORADO
                                size: dp(46), dp(46)
                                pos_hint: {'top': 1}
                            LDisplay:
                                text: '¡Actividad completada!'
                                font_size: '18sp'
                                outline_width: 0
                                halign: 'left'
                                valign: 'middle'
                                text_size: self.width, None
                                size_hint_y: None
                                height: max(dp(46), self.texture_size[1])
                                pos_hint: {'top': 1}
                        L:
                            id: act_resumen_txt
                            text: ''
                            font_size: '13.5sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            halign: 'left'
                            valign: 'top'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        NeoButton:
                            text: 'VOLVER A MI RUTA'
                            surface: theme.VERDE
                            color: theme.TEXTO_OSCURO
                            font_size: '15sp'
                            size_hint_y: None
                            height: dp(52)
                            on_press: root.volver_a_ruta()

<EvaluacionScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        do_scroll_x: False
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(40), dp(20), dp(24)]
            spacing: dp(18)
            size_hint_y: None
            height: self.minimum_height
            BoxLayout:
                orientation: 'vertical'
                spacing: dp(4)
                size_hint_y: None
                height: self.minimum_height
                LDisplay:
                    text: 'Evaluación'
                    font_size: '26sp'
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                LSec:
                    text: 'Tu clasificatoria para pasar de nivel.'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(18), dp(16)]
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height
                BoxLayout:
                    size_hint_y: None
                    height: self.minimum_height
                    spacing: dp(14)
                    NeoIcon:
                        id: eval_icono
                        icon: 'candado'
                        color_chip: theme.VIOLETA
                        size: dp(52), dp(52)
                        pos_hint: {'top': 1}
                    BoxLayout:
                        orientation: 'vertical'
                        spacing: dp(2)
                        size_hint_y: None
                        height: self.minimum_height
                        pos_hint: {'top': 1}
                        Etiqueta:
                            text: 'EVALUACIÓN CLASIFICATORIA'
                        LDisplay:
                            id: eval_estado
                            text: ''
                            font_size: '20sp'
                            outline_width: 0
                            halign: 'left'
                            valign: 'top'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                LSec:
                    id: eval_texto
                    markup: True
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.TEXTO
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                NeoBar:
                    id: eval_barra
                    fill: theme.VIOLETA
                    max: 4
                    value: 0
                    size_hint_y: None
                    height: dp(14)
                BoxLayout:
                    id: eval_acciones
                    orientation: 'vertical'
                    spacing: dp(4)
                    size_hint_y: None
                    height: self.minimum_height
                    BotonBloqueado:
                        id: eval_boton_bloqueado
                        text: 'EVALUACIÓN BLOQUEADA'
                    Enlace:
                        id: eval_enlace_ruta
                        text: 'Ir a mi ruta'
                        on_press: root.ir_a_ruta()
                    NeoButton:
                        id: eval_boton_empezar
                        text: 'EMPEZAR EVALUACIÓN'
                        surface: theme.DORADO
                        color: theme.TEXTO_OSCURO
                        font_size: '15sp'
                        size_hint_y: None
                        height: dp(54)
                        on_press: root.empezar()
            Etiqueta:
                text: 'CÓMO FUNCIONA'
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(18), dp(16)]
                spacing: dp(16)
                size_hint_y: None
                height: self.minimum_height
                PasoComoFunciona:
                    numero: '1'
                    fondo: theme.DORADO
                    titulo: 'Completa tu ruta'
                    texto: 'Termina ' + str(config.ACTIVIDADES_PARA_DESBLOQUEAR) + ' actividades de tu nivel.'
                PasoComoFunciona:
                    numero: '2'
                    fondo: theme.NARANJA
                    titulo: 'Rinde la evaluación'
                    texto: 'Los seis módulos con un texto nuevo.'
                PasoComoFunciona:
                    numero: '3'
                    fondo: theme.VERDE
                    titulo: 'Actualiza tu nivel'
                    texto: 'Tu nivel cambia según tu nuevo puntaje.'
            Etiqueta:
                text: 'MÓDULOS DE LA EVALUACIÓN'
            GridLayout:
                cols: 2
                spacing: dp(14)
                padding: [0, 0, dp(3), dp(3)]
                size_hint_y: None
                height: self.minimum_height
                TarjetaModulo:
                    nombre: 'NeuroRead'
                    habilidad: 'Velocidad lectora'
                    color_mod: theme.MODULE_COLORS['velocidad']
                TarjetaModulo:
                    nombre: 'NeuroTest'
                    habilidad: 'Comprensión'
                    color_mod: theme.MODULE_COLORS['comprension']
                TarjetaModulo:
                    nombre: 'NeuroInsight'
                    habilidad: 'Interpretación'
                    color_mod: theme.MODULE_COLORS['interpretacion']
                TarjetaModulo:
                    nombre: 'NeuroCreative'
                    habilidad: 'Creatividad'
                    color_mod: theme.MODULE_COLORS['imaginacion']
                TarjetaModulo:
                    nombre: 'NeuroFocus'
                    habilidad: 'Concentración'
                    color_mod: theme.MODULE_COLORS['concentracion']
                TarjetaModulo:
                    nombre: 'NeuroMemory'
                    habilidad: 'Memoria'
                    color_mod: theme.MODULE_COLORS['retencion']
            Etiqueta:
                text: 'EVALUACIONES ANTERIORES'
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(16), dp(8)]
                size_hint_y: None
                height: self.minimum_height
                BoxLayout:
                    id: eval_historial
                    orientation: 'vertical'
                    spacing: dp(4)
                    size_hint_y: None
                    height: self.minimum_height

<LibrosScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        do_scroll_x: False
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(40), dp(20), dp(24)]
            spacing: dp(18)
            size_hint_y: None
            height: self.minimum_height
            BoxLayout:
                orientation: 'vertical'
                spacing: dp(4)
                size_hint_y: None
                height: self.minimum_height
                LDisplay:
                    text: 'Libros'
                    font_size: '26sp'
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                LSec:
                    text: 'Lee para practicar y prepararte para tu próxima evaluación.'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.TEXTO
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
            BoxLayout:
                id: libros_lista
                orientation: 'vertical'
                spacing: dp(18)
                size_hint_y: None
                height: self.minimum_height

<LibroDetalleScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        id: det_scroll
        do_scroll_x: False
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(36), dp(20), dp(24)]
            spacing: dp(18)
            size_hint_y: None
            height: self.minimum_height
            NeoBotonIcono:
                texto: 'VOLVER'
                icono: 'volver'
                on_press: root.volver()
            BoxLayout:
                size_hint_y: None
                height: self.minimum_height
                spacing: dp(16)
                NeoCard:
                    id: det_portada
                    surface: theme.VERDE
                    radius: dp(10)
                    shadow_off: dp(3)
                    size_hint: None, None
                    size: dp(108), dp(150)
                    pos_hint: {'top': 1}
                    AnchorLayout:
                        NeoIcon:
                            icon: 'libro'
                            marco: False
                            color_glifo: theme.TEXTO_OSCURO
                            size: dp(44), dp(44)
                BoxLayout:
                    orientation: 'vertical'
                    spacing: dp(6)
                    size_hint_y: None
                    height: self.minimum_height
                    pos_hint: {'top': 1}
                    LDisplay:
                        id: det_titulo
                        text: ''
                        font_size: '22sp'
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        id: det_autor
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        id: det_tipo
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
            Etiqueta:
                text: 'CAPÍTULOS'
            BoxLayout:
                id: det_capitulos
                orientation: 'vertical'
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height
            Etiqueta:
                text: 'ACTIVIDADES DE TU NIVEL'
            BoxLayout:
                id: det_actividades
                orientation: 'vertical'
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height

<LectorScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(20), dp(36), dp(20), dp(16)]
        spacing: dp(10)
        NeoBotonIcono:
            texto: 'VOLVER'
            icono: 'volver'
            on_press: root.volver()
        Etiqueta:
            id: lector_libro
            text: ''
        LDisplay:
            id: lector_titulo
            text: ''
            font_size: '22sp'
            halign: 'left'
            valign: 'top'
            text_size: self.width, None
            size_hint_y: None
            height: self.texture_size[1]
        ScrollView:
            id: lector_scroll
            do_scroll_x: False
            BoxLayout:
                orientation: 'vertical'
                spacing: dp(18)
                padding: [0, dp(6), dp(4), dp(10)]
                size_hint_y: None
                height: self.minimum_height
                NeoCard:
                    id: lector_texto
                    surface: theme.TARJETA
                    radius: dp(16)
                    orientation: 'vertical'
                    padding: [dp(18), dp(18)]
                    spacing: dp(14)
                    size_hint_y: None
                    height: self.minimum_height
                NeoButton:
                    id: lector_btn
                    text: 'MARCAR COMO LEÍDO'
                    surface: theme.VERDE
                    color: theme.TEXTO_OSCURO
                    font_size: '15sp'
                    size_hint_y: None
                    height: dp(54)
                    on_press: root.accion()

<PrincipalScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        ScreenManager:
            id: principal_sm
            InicioScreen:
                name: 'inicio'
            RutaScreen:
                name: 'ruta'
            EvaluacionScreen:
                name: 'evaluacion'
            LibrosScreen:
                name: 'libros'
            LibroDetalleScreen:
                name: 'libro_detalle'
            PerfilScreen:
                name: 'perfil'
        NeoTabBar:
            id: principal_barra
            NeoTab:
                pestana: 'inicio'
                texto: 'Inicio'
                icono: 'inicio'
                on_press: root.ir_a_pestana('inicio')
            NeoTab:
                pestana: 'ruta'
                texto: 'Ruta'
                icono: 'ruta'
                on_press: root.ir_a_pestana('ruta')
            NeoTab:
                pestana: 'evaluacion'
                texto: 'Evaluación'
                icono: 'evaluacion'
                on_press: root.ir_a_pestana('evaluacion')
            NeoTab:
                pestana: 'libros'
                texto: 'Libros'
                icono: 'libro'
                on_press: root.ir_a_pestana('libros')
            NeoTab:
                pestana: 'perfil'
                texto: 'Perfil'
                icono: 'perfil'
                on_press: root.ir_a_pestana('perfil')

<SplashScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(36), dp(96), dp(36), dp(52)]
        spacing: dp(20)
        NeoDeco:
            tint: theme.DORADO
            seed: 11
            size_hint_y: None
            height: dp(34)
        NeoCard:
            surface: theme.TARJETA
            radius: dp(24)
            size_hint_y: None
            height: self.minimum_height
            padding: [dp(24), dp(24)]
            orientation: 'vertical'
            spacing: dp(10)
            BoxLayout:
                size_hint_y: None
                height: self.minimum_height
                spacing: dp(12)
                NeoIcon:
                    icon: 'brain'
                    color_chip: theme.DORADO
                    size: dp(50), dp(50)
                    pos_hint: {'top': 1}
                LDisplay:
                    markup: True
                    text: 'NEURO[color=' + hexc(theme.VERDE) + ']READ[/color]'
                    font_size: '27sp'
                    halign: 'left'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: max(dp(50), self.texture_size[1])
                    pos_hint: {'top': 1}
            LSec:
                text: 'Evaluación cognitiva de lectura en 6 módulos'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'left'
                valign: 'middle'
                text_size: self.width, None
                size_hint_y: None
                height: max(dp(24), self.texture_size[1])
            L:
                text: 'Mide tu velocidad, comprensión, interpretación, creatividad, concentración y memoria. Al final recibes un perfil lector con misiones personalizadas.'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
        Widget:
            size_hint_y: None
            height: dp(18)
        LSec:
            id: splash_msg
            text: 'Iniciando...'
            font_size: '13sp'
            font_name: theme.F_DISPLAY
            bold: True
            halign: 'center'
            text_size: self.width, None
            size_hint_y: None
            height: self.texture_size[1]
        NeoBar:
            id: splash_bar
            fill: theme.DORADO
            max: 100
            value: 0
            size_hint_y: None
            height: dp(18)
        Widget:
            size_hint_y: 1
        NeoDeco:
            tint: theme.TURQUESA
            seed: 23
            size_hint_y: None
            height: dp(30)
        LSec:
            text: 'v3.0: 6 textos aleatorios y modo NeuroUltra'
            font_size: '13sp'
            font_name: theme.F_DISPLAY
            bold: True
            halign: 'center'
            text_size: self.width, None
            size_hint_y: None
            height: max(dp(22), self.texture_size[1])

<LoginScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(28), dp(64), dp(28), dp(40)]
        spacing: dp(16)
        NeoDeco:
            tint: theme.DORADO
            seed: 31
            size_hint_y: None
            height: dp(30)
        BoxLayout:
            size_hint_y: None
            height: self.minimum_height
            spacing: dp(12)
            NeoIcon:
                icon: 'brain'
                color_chip: theme.DORADO
                size: dp(50), dp(50)
                pos_hint: {'top': 1}
            LDisplay:
                markup: True
                text: 'NEURO[color=' + hexc(theme.VERDE) + ']READ[/color]'
                font_size: '26sp'
                halign: 'left'
                valign: 'middle'
                text_size: self.width, None
                size_hint_y: None
                height: max(dp(50), self.texture_size[1])
                pos_hint: {'top': 1}
        LSec:
            text: 'Inicia sesión con tu perfil para entrenar tu lectura'
            font_size: '13sp'
            font_name: theme.F_DISPLAY
            bold: True
            color: theme.TEXTO
            halign: 'left'
            valign: 'middle'
            text_size: self.width, None
            size_hint_y: None
            height: max(dp(22), self.texture_size[1])
        NeoCard:
            surface: theme.TARJETA
            radius: dp(20)
            orientation: 'vertical'
            padding: [dp(20), dp(18)]
            spacing: dp(10)
            size_hint_y: None
            height: self.minimum_height
            BoxLayout:
                size_hint_y: None
                height: dp(26)
                spacing: dp(8)
                NeoBadge:
                    text: 'INICIAR SESIÓN'
                    surface: theme.VERDE
                    size_hint_x: None
                    width: dp(116)
                NeoDeco:
                    tint: theme.VERDE
                    seed: 8
            Etiqueta:
                text: 'USUARIO O CORREO'
            BoxLayout:
                size_hint_y: None
                height: dp(48)
                spacing: dp(10)
                NeoIcon:
                    icon: 'perfil'
                    color_chip: theme.TURQUESA
                    size: dp(42), dp(42)
                    pos_hint: {'center_y': 0.5}
                CampoTexto:
                    id: login_user
                    hint_text: 'Tu usuario o correo...'
                    cursor_color: theme.TURQUESA
                    on_text_validate: app.login_entrar()
            Etiqueta:
                text: 'CONTRASEÑA'
            BoxLayout:
                size_hint_y: None
                height: dp(48)
                spacing: dp(10)
                NeoIcon:
                    icon: 'candado'
                    color_chip: theme.NARANJA
                    size: dp(42), dp(42)
                    pos_hint: {'center_y': 0.5}
                CampoTexto:
                    id: login_pass
                    hint_text: 'Tu contraseña...'
                    password: True
                    cursor_color: theme.NARANJA
                    on_text_validate: app.login_entrar()
            ErrorFormulario:
                id: login_error
            NeoButton:
                text: 'ENTRAR'
                surface: theme.VERDE
                color: theme.TEXTO_OSCURO
                font_size: '16sp'
                size_hint_y: None
                height: dp(56)
                on_press: app.login_entrar()
            Enlace:
                text: '¿No tienes cuenta? Regístrate'
                on_press: app.ir_a('registro')
        Widget:
            size_hint_y: 1
        NeoDeco:
            tint: theme.TURQUESA
            seed: 23
            size_hint_y: None
            height: dp(28)
        LSec:
            text: 'Tu progreso se guarda por perfil. NeuroRead v3'
            font_size: '13sp'
            font_name: theme.F_DISPLAY
            bold: True
            halign: 'center'
            text_size: self.width, None
            size_hint_y: None
            height: max(dp(22), self.texture_size[1])

<RegistroScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        id: reg_scroll
        do_scroll_x: False
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(46), dp(20), dp(36)]
            spacing: dp(18)
            size_hint_y: None
            height: self.minimum_height
            BoxLayout:
                size_hint_y: None
                height: self.minimum_height
                spacing: dp(12)
                NeoIcon:
                    icon: 'perfil'
                    color_chip: theme.DORADO
                    size: dp(50), dp(50)
                    pos_hint: {'top': 1}
                LDisplay:
                    text: 'Crear cuenta'
                    font_size: '26sp'
                    halign: 'left'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: max(dp(50), self.texture_size[1])
                    pos_hint: {'top': 1}
            LSec:
                text: 'Completa tus datos para empezar a entrenar tu lectura.'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.TEXTO
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(18), dp(18)]
                spacing: dp(8)
                size_hint_y: None
                height: self.minimum_height
                Etiqueta:
                    text: 'NOMBRE DE USUARIO'
                CampoTexto:
                    id: reg_usuario
                    hint_text: 'Por ejemplo: luciaperez'
                Etiqueta:
                    text: 'NOMBRE'
                CampoTexto:
                    id: reg_nombre
                    hint_text: 'Tu nombre...'
                Etiqueta:
                    text: 'APELLIDO'
                CampoTexto:
                    id: reg_apellido
                    hint_text: 'Tu apellido...'
                Etiqueta:
                    text: 'GRADO ESCOLAR'
                GridLayout:
                    id: reg_grados
                    cols: 2
                    spacing: dp(10)
                    padding: [0, dp(2), dp(4), dp(6)]
                    size_hint_y: None
                    height: self.minimum_height
                Etiqueta:
                    text: 'CORREO'
                CampoTexto:
                    id: reg_correo
                    hint_text: 'nombre@correo.com'
                Etiqueta:
                    text: 'CONTRASEÑA'
                CampoTexto:
                    id: reg_clave
                    hint_text: 'Mínimo 6 caracteres'
                    password: True
                Etiqueta:
                    text: 'REPITE LA CONTRASEÑA'
                CampoTexto:
                    id: reg_clave2
                    hint_text: 'Vuelve a escribirla'
                    password: True
                    on_text_validate: root.crear()
                Widget:
                    size_hint_y: None
                    height: dp(2)
                ErrorFormulario:
                    id: reg_error
                NeoButton:
                    text: 'CREAR CUENTA'
                    surface: theme.DORADO
                    color: theme.TEXTO_OSCURO
                    font_size: '16sp'
                    size_hint_y: None
                    height: dp(56)
                    on_press: root.crear()
                Enlace:
                    text: '¿Ya tienes cuenta? Inicia sesión'
                    on_press: app.ir_a('login')

<EditarPerfilScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        id: edit_scroll
        do_scroll_x: False
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(46), dp(20), dp(36)]
            spacing: dp(18)
            size_hint_y: None
            height: self.minimum_height
            BoxLayout:
                size_hint_y: None
                height: self.minimum_height
                spacing: dp(12)
                NeoIcon:
                    icon: 'perfil'
                    color_chip: theme.DORADO
                    size: dp(50), dp(50)
                    pos_hint: {'top': 1}
                LDisplay:
                    text: 'Editar perfil'
                    font_size: '26sp'
                    halign: 'left'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: max(dp(50), self.texture_size[1])
                    pos_hint: {'top': 1}
            LSec:
                text: 'Actualiza tus datos y, si quieres, cambia tu contraseña.'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.TEXTO
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(18), dp(18)]
                spacing: dp(8)
                size_hint_y: None
                height: self.minimum_height
                Etiqueta:
                    text: 'NOMBRE DE USUARIO'
                CampoTexto:
                    id: edit_usuario
                    hint_text: 'Por ejemplo: luciaperez'
                Etiqueta:
                    text: 'NOMBRE'
                CampoTexto:
                    id: edit_nombre
                    hint_text: 'Tu nombre...'
                Etiqueta:
                    text: 'APELLIDO'
                CampoTexto:
                    id: edit_apellido
                    hint_text: 'Tu apellido...'
                Etiqueta:
                    text: 'GRADO ESCOLAR'
                GridLayout:
                    id: edit_grados
                    cols: 2
                    spacing: dp(10)
                    padding: [0, dp(2), dp(4), dp(6)]
                    size_hint_y: None
                    height: self.minimum_height
                Etiqueta:
                    text: 'CORREO'
                CampoTexto:
                    id: edit_correo
                    hint_text: 'nombre@correo.com'
                Widget:
                    size_hint_y: None
                    height: dp(6)
                Etiqueta:
                    text: 'CAMBIAR CONTRASEÑA'
                LSec:
                    text: 'Opcional. Déjalo vacío si no quieres cambiarla.'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                Etiqueta:
                    text: 'CONTRASEÑA ACTUAL'
                CampoTexto:
                    id: edit_clave_actual
                    hint_text: 'Tu contraseña actual'
                    password: True
                Etiqueta:
                    text: 'CONTRASEÑA NUEVA'
                CampoTexto:
                    id: edit_clave_nueva
                    hint_text: 'Mínimo 6 caracteres'
                    password: True
                Etiqueta:
                    text: 'REPITE LA CONTRASEÑA NUEVA'
                CampoTexto:
                    id: edit_clave_nueva2
                    hint_text: 'Vuelve a escribirla'
                    password: True
                Widget:
                    size_hint_y: None
                    height: dp(2)
                ErrorFormulario:
                    id: edit_error
                NeoButton:
                    text: 'GUARDAR CAMBIOS'
                    surface: theme.DORADO
                    color: theme.TEXTO_OSCURO
                    font_size: '16sp'
                    size_hint_y: None
                    height: dp(56)
                    on_press: root.guardar()
                NeoButton:
                    text: 'CANCELAR'
                    surface: theme.TARJETA_ALT
                    color: theme.TEXTO
                    font_size: '15sp'
                    size_hint_y: None
                    height: dp(52)
                    on_press: root.cancelar()

<PerfilScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        id: perfil_scroll
        do_scroll_x: False
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(40), dp(20), dp(24)]
            spacing: dp(18)
            size_hint_y: None
            height: self.minimum_height
            L:
                id: perfil_mensaje
                text: ''
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.VERDE
                halign: 'left'
                valign: 'middle'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1] if self.text else 0
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                padding: [dp(16), dp(14)]
                spacing: dp(16)
                size_hint_y: None
                height: self.minimum_height
                CirculoInicial:
                    id: perfil_inicial
                    text: ''
                    pos_hint: {'top': 1}
                BoxLayout:
                    orientation: 'vertical'
                    spacing: dp(4)
                    size_hint_y: None
                    height: self.minimum_height
                    pos_hint: {'top': 1}
                    LDisplay:
                        id: perfil_nombre
                        text: ''
                        font_size: '22sp'
                        outline_width: 0
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        id: perfil_detalle
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    BoxLayout:
                        size_hint_y: None
                        height: dp(28)
                        NeoBadge:
                            id: perfil_nivel
                            text: ''
                            size_hint: None, None
                            size: dp(120), dp(24)
                            pos_hint: {'center_y': 0.5}
                        Widget:
            BoxLayout:
                size_hint_y: None
                height: max(perfil_c_total.minimum_height, perfil_c_racha.minimum_height, perfil_c_mejor.minimum_height)
                spacing: dp(12)
                NeoCard:
                    surface: theme.TARJETA
                    radius: dp(14)
                    shadow_off: dp(3)
                    orientation: 'vertical'
                    padding: [dp(4), dp(10)]
                    spacing: dp(2)
                    id: perfil_c_total
                    LDisplay:
                        id: perfil_total
                        text: '0'
                        font_size: '24sp'
                        outline_width: 0
                        color: theme.TEXTO
                        halign: 'center'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        text: 'Evaluaciones'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'center'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: max(dp(16), self.texture_size[1])
                NeoCard:
                    surface: theme.TARJETA
                    radius: dp(14)
                    shadow_off: dp(3)
                    orientation: 'vertical'
                    padding: [dp(4), dp(10)]
                    spacing: dp(2)
                    id: perfil_c_racha
                    LDisplay:
                        id: perfil_racha
                        text: '0'
                        font_size: '24sp'
                        outline_width: 0
                        color: theme.NARANJA
                        halign: 'center'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        text: 'Días de racha'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'center'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: max(dp(16), self.texture_size[1])
                NeoCard:
                    surface: theme.TARJETA
                    radius: dp(14)
                    shadow_off: dp(3)
                    orientation: 'vertical'
                    padding: [dp(4), dp(10)]
                    spacing: dp(2)
                    id: perfil_c_mejor
                    LDisplay:
                        id: perfil_mejor
                        text: '0'
                        font_size: '24sp'
                        outline_width: 0
                        color: theme.DORADO
                        halign: 'center'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        text: 'Mejor puntaje'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'center'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: max(dp(16), self.texture_size[1])
            Etiqueta:
                text: 'TU EVOLUCIÓN'
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(16), dp(14)]
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height
                BoxLayout:
                    spacing: dp(12)
                    size_hint_y: None
                    height: self.minimum_height
                    BoxLayout:
                        orientation: 'vertical'
                        spacing: dp(4)
                        size_hint_y: None
                        height: self.minimum_height
                        LSec:
                            text: 'INICIAL'
                            font_size: '13sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            halign: 'center'
                            valign: 'middle'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        LDisplay:
                            id: perfil_inicial_pts
                            text: '--'
                            font_size: '30sp'
                            outline_width: 0
                            halign: 'center'
                            valign: 'middle'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                    Widget:
                        size_hint_x: None
                        width: dp(2)
                        canvas:
                            Color:
                                rgba: theme.TARJETA_ALT
                            Rectangle:
                                pos: self.pos
                                size: self.size
                    BoxLayout:
                        orientation: 'vertical'
                        spacing: dp(4)
                        size_hint_y: None
                        height: self.minimum_height
                        LSec:
                            text: 'ACTUAL'
                            font_size: '13sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            halign: 'center'
                            valign: 'middle'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        LDisplay:
                            id: perfil_actual_pts
                            text: '--'
                            font_size: '30sp'
                            outline_width: 0
                            halign: 'center'
                            valign: 'middle'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                AnchorLayout:
                    size_hint_y: None
                    height: dp(28)
                    NeoBadge:
                        id: perfil_diferencia
                        text: ''
                        surface: theme.VERDE
                        size_hint: None, None
                        size: max(dp(150), self.texture_size[0] + dp(24)), dp(26)
            Etiqueta:
                text: 'PUNTAJE POR MÓDULO'
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(16), dp(14)]
                size_hint_y: None
                height: self.minimum_height
                BoxLayout:
                    id: perfil_modulos
                    orientation: 'vertical'
                    spacing: dp(10)
                    size_hint_y: None
                    height: self.minimum_height
            Etiqueta:
                text: 'TIPOS DE COMPRENSIÓN'
            NeoCard:
                surface: theme.TARJETA
                radius: dp(18)
                orientation: 'vertical'
                padding: [dp(16), dp(14)]
                size_hint_y: None
                height: self.minimum_height
                BoxLayout:
                    id: perfil_tipos
                    orientation: 'vertical'
                    spacing: dp(10)
                    size_hint_y: None
                    height: self.minimum_height
            NeoCard:
                surface: theme.TARJETA_ALT
                radius: dp(18)
                padding: [dp(16), dp(14)]
                spacing: dp(14)
                size_hint_y: None
                height: self.minimum_height
                NeoIcon:
                    icon: 'bombilla'
                    color_chip: theme.AZUL
                    size: dp(46), dp(46)
                    pos_hint: {'top': 1}
                BoxLayout:
                    orientation: 'vertical'
                    spacing: dp(6)
                    size_hint_y: None
                    height: self.minimum_height
                    pos_hint: {'top': 1}
                    Etiqueta:
                        text: 'RECOMENDACIÓN DE NEUROCOACH'
                    L:
                        id: perfil_recomendacion
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
            Etiqueta:
                text: 'LOGROS'
            BoxLayout:
                id: perfil_logros
                orientation: 'vertical'
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height
            Widget:
                size_hint_y: None
                height: dp(4)
            NeoButton:
                text: 'EDITAR PERFIL'
                surface: theme.TARJETA_ALT
                color: theme.TEXTO
                font_size: '15sp'
                size_hint_y: None
                height: dp(52)
                on_press: root.editar()
            NeoButton:
                text: 'CERRAR SESIÓN'
                surface: theme.TRANSPARENTE
                color_borde: theme.ROJO
                color: theme.ROJO
                shadow_off: 0
                font_size: '15sp'
                size_hint_y: None
                height: dp(52)
                on_press: root.cerrar_sesion()
            Enlace:
                text: 'Eliminar cuenta'
                font_size: '13sp'
                color: theme.ROJO
                on_press: root.eliminar_cuenta()

<HomeCard@NeoCard>:
    titulo: ''
    desc: ''
    icono: 'book'
    chip_color: theme.DORADO
    estrella: False
    radius: dp(16)
    orientation: 'horizontal'
    padding: [dp(14), dp(12)]
    spacing: dp(12)
    size_hint_y: None
    height: self.minimum_height
    NeoIcon:
        icon: root.icono
        color_chip: root.chip_color
        size: dp(46), dp(46)
        pos_hint: {'top': 1}
    BoxLayout:
        orientation: 'vertical'
        spacing: dp(2)
        size_hint_y: None
        height: self.minimum_height
        pos_hint: {'top': 1}
        BoxLayout:
            size_hint_y: None
            height: self.minimum_height
            spacing: dp(8)
            LDisplay:
                text: root.titulo
                font_size: '14.5sp'
                color: root.chip_color
                halign: 'left'
                valign: 'middle'
                text_size: self.width, None
                size_hint_y: None
                height: max(dp(24), self.texture_size[1])
                pos_hint: {'top': 1}
            NeoBadge:
                text: 'ESTRELLA'
                surface: theme.DORADO
                size_hint: None, None
                width: dp(74) if root.estrella else 0
                height: dp(24)
                opacity: 1 if root.estrella else 0
                pos_hint: {'top': 1}
        LSec:
            text: root.desc
            font_size: '13sp'
            font_name: theme.F_DISPLAY
            bold: True
            color: theme.TEXTO
            halign: 'left'
            valign: 'top'
            text_size: self.width, None
            size_hint_y: None
            height: self.texture_size[1]

<BienvenidaEvaluacionScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(46), dp(20), dp(36)]
            spacing: dp(12)
            size_hint_y: None
            height: self.minimum_height
            BoxLayout:
                size_hint_y: None
                height: self.minimum_height
                spacing: dp(10)
                LDisplay:
                    markup: True
                    text: 'NEURO[color=' + hexc(theme.VERDE) + ']READ[/color]'
                    font_size: '25sp'
                    halign: 'left'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                NeoDeco:
                    tint: theme.VERDE
                    seed: 4
                    size_hint_x: None
                    width: dp(70)
            NeoCard:
                surface: theme.TARJETA
                size_hint_y: None
                height: self.minimum_height
                padding: [dp(16), dp(12)]
                orientation: 'vertical'
                spacing: dp(4)
                LDisplay:
                    id: home_eval_titulo
                    text: ''
                    font_size: '16sp'
                    outline_width: 0
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                L:
                    id: home_intro
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.TEXTO
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                LSec:
                    id: home_texto_titulo
                    text: 'Cargando texto...'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.DORADO
                    halign: 'left'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: max(dp(22), self.texture_size[1])
            SectionTitle:
                text: 'EVALUACIÓN: 6 MÓDULOS'
            HomeCard:
                titulo: 'NeuroRead'
                desc: 'Velocidad lectora medida en palabras por minuto'
                icono: 'book'
                chip_color: theme.DORADO
            HomeCard:
                titulo: 'NeuroTest'
                desc: 'Comprensión literal, inferencial y crítica'
                icono: 'check'
                chip_color: theme.VERDE
            HomeCard:
                titulo: 'NeuroInsight'
                desc: 'Interpretación: emoción e intención del autor'
                icono: 'eye'
                chip_color: theme.AZUL
            HomeCard:
                titulo: 'NeuroCreative'
                desc: 'Imaginación, creatividad y visualización'
                icono: 'spark'
                chip_color: theme.TURQUESA
                estrella: True
            HomeCard:
                titulo: 'NeuroFocus'
                desc: '4 niveles de reacción: llega al modo NeuroUltra'
                icono: 'bolt'
                chip_color: theme.NARANJA
            HomeCard:
                titulo: 'NeuroMemory'
                desc: 'Retención: memoria inmediata y diferida'
                icono: 'brain'
                chip_color: theme.VIOLETA
            SectionTitle:
                text: 'PANELES INTELIGENTES: 3 ANÁLISIS'
            HomeCard:
                titulo: 'NeuroScore'
                desc: 'Perfil lector con puntaje global y desglose'
                icono: 'gauge'
                chip_color: theme.MARINO
            HomeCard:
                titulo: 'NeuroCoach'
                desc: 'Actividades de tu ruta según tus resultados'
                icono: 'target'
                chip_color: theme.MARINO
            HomeCard:
                titulo: 'NeuroTrack'
                desc: 'Historial, logros y evolución en tu perfil'
                icono: 'chart'
                chip_color: theme.MARINO
            Widget:
                size_hint_y: None
                height: dp(10)
            NeoButton:
                text: 'INICIAR EVALUACIÓN'
                surface: theme.DORADO
                color: theme.TEXTO_OSCURO
                font_size: '17sp'
                size_hint_y: None
                height: dp(64)
                on_press: app.ir_a('velocidad')

<VelocidadScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(20), dp(46), dp(20), dp(26)]
        spacing: dp(12)
        ModHeader:
            icono: 'book'
            titulo: 'NeuroRead'
            subtitulo: 'Módulo 1 de 6: velocidad lectora'
            chip_color: theme.DORADO
        NeoCard:
            surface: theme.TARJETA
            size_hint_y: None
            height: max(dp(64), vel_estado.height + dp(48))
            padding: [dp(16), dp(8)]
            spacing: dp(8)
            BoxLayout:
                orientation: 'vertical'
                LDisplay:
                    id: vel_timer
                    text: '0.0 s'
                    font_size: '22sp'
                    color: theme.DORADO
                    halign: 'left'
                    valign: 'middle'
                    text_size: self.size
                LSec:
                    text: 'Cronómetro'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'left'
                    valign: 'top'
                    text_size: self.size
                    size_hint_y: None
                    height: dp(16)
            BoxLayout:
                orientation: 'vertical'
                L:
                    id: vel_palabras
                    text: '-- palabras'
                    font_size: '15sp'
                    bold: True
                    halign: 'right'
                    valign: 'middle'
                    text_size: self.size
                LSec:
                    id: vel_estado
                    text: 'Listo'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'right'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: max(dp(16), self.texture_size[1])
        NeoCard:
            surface: theme.TARJETA_ALT
            size_hint_y: None
            height: vel_tip.height + dp(20)
            padding: [dp(14), dp(10)]
            L:
                id: vel_tip
                text: 'Consejo: lee a tu ritmo natural, sin correr. La comprensión del texto se evalúa en el siguiente módulo.'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.TEXTO
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
        ScrollView:
            NeoCard:
                surface: theme.TARJETA
                size_hint_y: None
                height: max(self.minimum_height, dp(280))
                padding: [dp(18), dp(16)]
                L:
                    id: vel_texto_label
                    text: ''
                    font_size: '14sp'
                    line_height: 1.25
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
        BoxLayout:
            size_hint_y: None
            height: dp(62)
            spacing: dp(14)
            NeoButton:
                id: vel_btn_start
                text: 'EMPEZAR'
                surface: theme.AZUL
                color: theme.TEXTO
                font_size: '15sp'
                on_press: app.vel_empezar()
            NeoButton:
                id: vel_btn_stop
                text: 'TERMINÉ DE LEER'
                surface: theme.VERDE
                color: theme.TEXTO_OSCURO
                font_size: '15sp'
                opacity: 0.35
                disabled: True
                on_press: app.vel_terminar()

<ComprensionScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(20), dp(46), dp(20), dp(26)]
        spacing: dp(12)
        ModHeader:
            icono: 'check'
            titulo: 'NeuroTest'
            subtitulo: 'Módulo 2 de 6: comprensión lectora'
            chip_color: theme.VERDE
        BoxLayout:
            size_hint_y: None
            height: dp(24)
            spacing: dp(8)
            LSec:
                id: comp_prog
                text: 'Pregunta 1 de 5'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'left'
                valign: 'middle'
                text_size: self.size
            NeoBadge:
                id: comp_tipo
                text: 'LITERAL'
                surface: theme.VERDE
                size_hint_x: None
                width: dp(96)
        NeoBar:
            id: comp_bar
            fill: theme.VERDE
            max: 5
            value: 0
            size_hint_y: None
            height: dp(14)
        NeoCard:
            surface: theme.TARJETA
            size_hint_y: None
            height: comp_pregunta.height + dp(30)
            padding: [dp(18), dp(14)]
            L:
                id: comp_pregunta
                text: ''
                font_size: '14.5sp'
                bold: True
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
        ScrollView:
            BoxLayout:
                id: comp_opciones
                orientation: 'vertical'
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height
                padding: [0, dp(4)]
        L:
            id: comp_feedback
            text: ''
            font_size: '15sp'
            bold: True
            halign: 'center'
            valign: 'middle'
            text_size: self.size
            size_hint_y: None
            height: dp(32)

<InterpretacionScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(20), dp(46), dp(20), dp(26)]
        spacing: dp(11)
        ModHeader:
            icono: 'eye'
            titulo: 'NeuroInsight'
            subtitulo: 'Módulo 3 de 6: interpretación profunda'
            chip_color: theme.AZUL
        BoxLayout:
            size_hint_y: None
            height: dp(22)
            LSec:
                id: inter_prog
                text: 'Pregunta 1 de 5'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'left'
                valign: 'middle'
                text_size: self.size
        NeoBar:
            id: inter_bar
            fill: theme.AZUL
            max: 3
            value: 0
            size_hint_y: None
            height: dp(14)
        NeoCard:
            surface: theme.TARJETA
            size_hint_y: None
            height: inter_pregunta.height + dp(28)
            padding: [dp(18), dp(14)]
            L:
                id: inter_pregunta
                text: ''
                font_size: '14sp'
                bold: True
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
        NeoCard:
            surface: theme.TARJETA_ALT
            size_hint_y: None
            height: inter_guia.height + dp(20)
            padding: [dp(14), dp(10)]
            L:
                id: inter_guia
                text: 'Guía: responde con tus propias palabras, menciona emociones, intención del autor y ejemplos. Se detectan respuestas repetitivas.'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.TEXTO
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
        TextInput:
            id: inter_input
            hint_text: 'Escribe tu análisis aquí...'
            font_name: theme.F_BODY
            font_size: '14sp'
            foreground_color: theme.TEXTO
            background_color: theme.TARJETA_ALT
            cursor_color: theme.AZUL
            hint_text_color: theme.TEXTO_SEC
            multiline: True
            padding: [dp(14), dp(12)]
            on_text: app.inter_count(self.text)
        BoxLayout:
            size_hint_y: None
            height: dp(26)
            LSec:
                id: inter_count_lbl
                text: '0 palabras'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.NARANJA
                halign: 'left'
                valign: 'middle'
                text_size: self.size
            LSec:
                text: 'mínimo 10, sin repetir'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'right'
                valign: 'middle'
                text_size: self.size
        NeoButton:
            text: 'SIGUIENTE'
            surface: theme.AZUL
            color: theme.TEXTO
            font_size: '16sp'
            size_hint_y: None
            height: dp(58)
            on_press: app.inter_siguiente()

<ImaginacionScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(20), dp(46), dp(20), dp(26)]
        spacing: dp(11)
        NeoCard:
            surface: theme.TARJETA
            size_hint_y: None
            height: max(dp(82), imag_cabecera.height + dp(24))
            padding: [dp(16), dp(12)]
            spacing: dp(12)
            NeoIcon:
                icon: 'spark'
                color_chip: theme.TURQUESA
                size: dp(48), dp(48)
                pos_hint: {'center_y': 0.5}
            BoxLayout:
                id: imag_cabecera
                orientation: 'vertical'
                spacing: dp(2)
                size_hint_y: None
                height: self.minimum_height
                pos_hint: {'center_y': 0.5}
                BoxLayout:
                    size_hint_y: None
                    height: dp(28)
                    spacing: dp(8)
                    LDisplay:
                        text: 'NeuroCreative'
                        font_size: '20sp'
                        color: theme.TURQUESA
                        halign: 'left'
                        valign: 'middle'
                        text_size: self.size
                        shorten: True
                    NeoBadge:
                        text: 'ESTRELLA'
                        surface: theme.DORADO
                        size_hint_x: None
                        width: dp(74)
                        pos_hint: {'center_y': 0.5}
                LSec:
                    text: 'Módulo 4 de 6: imaginación y creatividad'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
        NeoCard:
            surface: theme.TARJETA
            size_hint_y: None
            height: imag_consigna.height + dp(28)
            padding: [dp(18), dp(14)]
            L:
                id: imag_consigna
                text: 'Imagina un FINAL ALTERNATIVO para la historia que leíste. Describe colores, sonidos, sensaciones e hipótesis: cuanto más rico tu vocabulario, mayor tu puntaje.'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
        TextInput:
            id: imag_input
            hint_text: 'Describe tu final alternativo aquí...'
            font_name: theme.F_BODY
            font_size: '14sp'
            foreground_color: theme.TEXTO
            background_color: theme.TARJETA_ALT
            cursor_color: theme.TURQUESA
            hint_text_color: theme.TEXTO_SEC
            multiline: True
            padding: [dp(14), dp(12)]
            on_text: app.imag_count(self.text)
        BoxLayout:
            size_hint_y: None
            height: dp(26)
            LSec:
                id: imag_count_lbl
                text: '0 palabras'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.TURQUESA
                halign: 'left'
                valign: 'middle'
                text_size: self.size
            LSec:
                id: imag_riqueza_lbl
                text: 'Riqueza: --'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.VERDE
                halign: 'right'
                valign: 'middle'
                text_size: self.size
        NeoButton:
            text: 'EVALUAR MI CREATIVIDAD'
            surface: theme.TURQUESA
            color: theme.TEXTO_OSCURO
            font_size: '16sp'
            size_hint_y: None
            height: dp(58)
            on_press: app.imag_guardar()

<ConcentracionScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    FloatLayout:
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(46), dp(20), dp(26)]
            spacing: dp(11)
            size_hint: 1, 1
            pos_hint: {'x': 0, 'y': 0}
            ModHeader:
                icono: 'bolt'
                titulo: 'NeuroFocus'
                subtitulo: 'Módulo 5 de 6: reacción por niveles'
                chip_color: theme.NARANJA
            BoxLayout:
                size_hint_y: None
                height: dp(26)
                spacing: dp(8)
                NeoBadge:
                    id: conc_nivel_badge
                    text: 'NIVEL FÁCIL'
                    surface: theme.VERDE
                    size_hint_x: None
                    width: dp(120)
                LSec:
                    id: conc_prog
                    text: 'Palabra 1 de 6'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'right'
                    valign: 'middle'
                    text_size: self.size
            NeoBar:
                id: conc_bar
                fill: theme.NARANJA
                max: 4
                value: 0
                size_hint_y: None
                height: dp(14)
            NeoCard:
                surface: theme.TARJETA
                size_hint_y: None
                height: conc_regla.height + dp(22)
                padding: [dp(16), dp(11)]
                L:
                    id: conc_regla
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.NARANJA
                    halign: 'center'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
            NeoCard:
                surface: theme.TARJETA
                size_hint_y: None
                height: dp(150)
                padding: [dp(20), dp(16)]
                orientation: 'vertical'
                spacing: dp(8)
                LDisplay:
                    id: conc_palabra
                    text: '?'
                    font_size: '40sp'
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.size
                NeoBar:
                    id: conc_timerbar
                    fill: theme.ROJO
                    max: 100
                    value: 0
                    opacity: 0
                    size_hint_y: None
                    height: dp(12)
            BoxLayout:
                size_hint_y: None
                height: dp(50)
                spacing: dp(14)
                NeoCard:
                    surface: theme.TARJETA
                    padding: [dp(10), dp(6)]
                    L:
                        id: conc_aciertos
                        text: 'Aciertos: 0'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        color: theme.VERDE
                        halign: 'center'
                        valign: 'middle'
                        text_size: self.size
                NeoCard:
                    surface: theme.TARJETA
                    padding: [dp(10), dp(6)]
                    L:
                        id: conc_errores
                        text: 'Errores: 0'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        color: theme.ROJO
                        halign: 'center'
                        valign: 'middle'
                        text_size: self.size
            Widget:
                size_hint_y: 1
            L:
                id: conc_feedback
                text: ''
                font_size: '15sp'
                bold: True
                halign: 'center'
                valign: 'middle'
                text_size: self.size
                size_hint_y: None
                height: dp(30)
            BoxLayout:
                size_hint_y: None
                height: dp(64)
                spacing: dp(14)
                NeoButton:
                    id: conc_si
                    text: 'SÍ'
                    surface: theme.VERDE
                    color: theme.TEXTO_OSCURO
                    font_size: '15sp'
                    on_press: app.conc_responder(True)
                NeoButton:
                    id: conc_no
                    text: 'NO'
                    surface: theme.ROJO
                    color: theme.TEXTO
                    font_size: '15sp'
                    on_press: app.conc_responder(False)
        NeoCard:
            id: conc_inter_card
            surface: theme.TARJETA
            radius: dp(20)
            orientation: 'vertical'
            padding: [dp(22), dp(20)]
            spacing: dp(10)
            size_hint: None, None
            width: min(root.width - dp(44), dp(340))
            height: conc_inter_titulo.height + conc_inter_detalle.height + dp(120)
            pos_hint: {'center_x': 0.5, 'center_y': 0.52}
            opacity: 0
            disabled: True
            LDisplay:
                id: conc_inter_titulo
                text: ''
                font_size: '19sp'
                color: theme.NARANJA
                halign: 'center'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
            L:
                id: conc_inter_detalle
                text: ''
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.TEXTO
                halign: 'center'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
            NeoButton:
                id: conc_inter_btn
                text: 'CONTINUAR'
                surface: theme.NARANJA
                color: theme.TEXTO_OSCURO
                font_size: '15sp'
                size_hint_y: None
                height: dp(54)
                on_press: app.conc_continuar()
        FloatLayout:
            id: conc_prep_layer
            size_hint: 1, 1
            pos_hint: {'x': 0, 'y': 0}
            opacity: 0
            canvas.before:
                Color:
                    rgba: theme.VELO
                Rectangle:
                    pos: self.pos
                    size: self.size
            NeoCard:
                surface: theme.TARJETA
                radius: dp(20)
                orientation: 'vertical'
                padding: [dp(22), dp(20)]
                spacing: dp(10)
                size_hint: None, None
                width: min(root.width - dp(44), dp(340))
                height: conc_prep_regla.height + dp(206)
                pos_hint: {'center_x': 0.5, 'center_y': 0.52}
                LSec:
                    text: 'PREPÁRATE: SIGUIENTE NIVEL'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.size
                    size_hint_y: None
                    height: dp(20)
                LDisplay:
                    id: conc_prep_nombre
                    text: ''
                    font_size: '22sp'
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.size
                    size_hint_y: None
                    height: dp(34)
                L:
                    id: conc_prep_regla
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.TEXTO
                    halign: 'center'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                LDisplay:
                    id: conc_prep_count
                    text: '6'
                    font_size: '38sp'
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.size
                    size_hint_y: None
                    height: dp(52)
                NeoBar:
                    id: conc_prep_bar
                    fill: theme.NARANJA
                    max: 100
                    value: 0
                    size_hint_y: None
                    height: dp(16)

<RetencionScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    BoxLayout:
        orientation: 'vertical'
        padding: [dp(20), dp(46), dp(20), dp(26)]
        spacing: dp(12)
        ModHeader:
            icono: 'brain'
            titulo: 'NeuroMemory'
            subtitulo: 'Módulo 6 de 6: memoria diferida'
            chip_color: theme.VIOLETA
        BoxLayout:
            size_hint_y: None
            height: dp(22)
            LSec:
                id: ret_prog
                text: 'Preparando test...'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'left'
                valign: 'middle'
                text_size: self.size
        NeoBar:
            id: ret_bar
            fill: theme.VIOLETA
            max: 3
            value: 0
            size_hint_y: None
            height: dp(14)
        NeoCard:
            surface: theme.TARJETA
            id: ret_wait_card
            size_hint_y: None
            height: dp(196)
            padding: [dp(20), dp(16)]
            orientation: 'vertical'
            spacing: dp(6)
            NeoIcon:
                icon: 'timer'
                color_chip: theme.VIOLETA
                size: dp(44), dp(44)
                pos_hint: {'center_x': 0.5}
            LDisplay:
                id: ret_countdown
                text: '30'
                font_size: '44sp'
                color: theme.VIOLETA
                halign: 'center'
                valign: 'middle'
                text_size: self.size
            LSec:
                text: 'Sin releer el texto: en unos segundos comprobaremos cuánto recuerdas de la lectura.'
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                color: theme.TEXTO
                halign: 'center'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
        NeoCard:
            surface: theme.TARJETA
            id: ret_q_card
            size_hint_y: None
            height: ret_pregunta.height + dp(28)
            padding: [dp(18), dp(14)]
            opacity: 0
            L:
                id: ret_pregunta
                text: ''
                font_size: '14.5sp'
                bold: True
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1]
        ScrollView:
            BoxLayout:
                id: ret_opts_box
                orientation: 'vertical'
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height
                opacity: 0
                padding: [0, dp(4)]
        L:
            id: ret_feedback
            text: ''
            font_size: '15sp'
            bold: True
            halign: 'center'
            valign: 'middle'
            text_size: self.size
            size_hint_y: None
            height: dp(30)

<ResultadosScreen>:
    canvas.before:
        Color:
            rgba: theme.FONDO
        Rectangle:
            pos: self.pos
            size: self.size
    ScrollView:
        id: res_scroll
        BoxLayout:
            orientation: 'vertical'
            padding: [dp(20), dp(46), dp(20), dp(38)]
            spacing: dp(13)
            size_hint_y: None
            height: self.minimum_height
            LSec:
                id: res_consulta
                text: ''
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'left'
                valign: 'top'
                text_size: self.width, None
                size_hint_y: None
                height: self.texture_size[1] if self.text else 0
                opacity: 1 if self.text else 0
            BoxLayout:
                size_hint_y: None
                height: self.minimum_height
                spacing: dp(12)
                NeoIcon:
                    icon: 'gauge'
                    color_chip: theme.MARINO
                    size: dp(50), dp(50)
                    pos_hint: {'top': 1}
                BoxLayout:
                    orientation: 'vertical'
                    spacing: dp(2)
                    size_hint_y: None
                    height: self.minimum_height
                    pos_hint: {'top': 1}
                    LDisplay:
                        markup: True
                        text: 'Neuro[color=' + hexc(theme.AZUL) + ']Score[/color]'
                        font_size: '23sp'
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    LSec:
                        text: 'Panel 1 de 3: tu perfil lector de hoy'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: max(dp(18), self.texture_size[1])
            LSec:
                id: res_titulo_texto
                text: ''
                font_size: '13sp'
                font_name: theme.F_DISPLAY
                bold: True
                halign: 'left'
                valign: 'middle'
                text_size: self.width, None
                size_hint_y: None
                height: max(dp(20), self.texture_size[1])
            NeoCard:
                surface: theme.MARINO
                radius: dp(20)
                size_hint_y: None
                height: self.minimum_height
                padding: [dp(20), dp(16)]
                orientation: 'vertical'
                spacing: dp(6)
                LSec:
                    text: 'PUNTAJE GLOBAL'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    color: theme.TEXTO_SEC
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                LDisplay:
                    id: res_score
                    markup: True
                    text: '--'
                    font_size: '52sp'
                    color: theme.DORADO
                    halign: 'center'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
                NeoBadge:
                    id: res_nivel
                    text: ''
                    surface: theme.DORADO
                    font_size: '13sp'
                    size_hint: None, None
                    size: dp(190), dp(34)
                    pos_hint: {'center_x': 0.5}
                LSec:
                    id: res_rango
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'center'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
            NeoCard:
                surface: theme.TARJETA
                size_hint_y: None
                height: self.minimum_height
                padding: [dp(16), dp(14)]
                L:
                    id: res_retro
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'left'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
            NeoCard:
                id: res_comp_card
                surface: theme.TARJETA
                orientation: 'vertical'
                size_hint_y: None
                height: self.minimum_height if self.opacity else 0
                opacity: 0
                padding: [dp(14), dp(14)]
                spacing: dp(10)
                LSec:
                    text: 'COMPARACIÓN CON TU EVALUACIÓN ANTERIOR'
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'left'
                    valign: 'middle'
                    text_size: self.width, None
                    size_hint_y: None
                    height: max(dp(18), self.texture_size[1])
                BoxLayout:
                    size_hint_y: None
                    height: max(res_comp_c_anterior.minimum_height, res_comp_c_nuevo.minimum_height)
                    spacing: dp(10)
                    NeoCard:
                        id: res_comp_c_anterior
                        surface: theme.TARJETA_ALT
                        orientation: 'vertical'
                        padding: [dp(8), dp(8)]
                        spacing: dp(2)
                        LDisplay:
                            id: res_comp_anterior
                            text: '--'
                            font_size: '21sp'
                            halign: 'center'
                            valign: 'middle'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        LSec:
                            text: 'Anterior'
                            font_size: '13sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            halign: 'center'
                            valign: 'middle'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                    NeoCard:
                        id: res_comp_c_nuevo
                        surface: theme.TARJETA_ALT
                        orientation: 'vertical'
                        padding: [dp(8), dp(8)]
                        spacing: dp(2)
                        LDisplay:
                            id: res_comp_nuevo
                            text: '--'
                            font_size: '21sp'
                            halign: 'center'
                            valign: 'middle'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                        LSec:
                            text: 'Nuevo'
                            font_size: '13sp'
                            font_name: theme.F_DISPLAY
                            bold: True
                            halign: 'center'
                            valign: 'middle'
                            text_size: self.width, None
                            size_hint_y: None
                            height: self.texture_size[1]
                AnchorLayout:
                    size_hint_y: None
                    height: dp(28)
                    NeoBadge:
                        id: res_comp_dif
                        text: ''
                        surface: theme.VERDE
                        size_hint: None, None
                        size: max(dp(150), self.texture_size[0] + dp(24)), dp(26)
                L:
                    id: res_comp_msg
                    text: ''
                    font_size: '13sp'
                    font_name: theme.F_DISPLAY
                    bold: True
                    halign: 'center'
                    valign: 'top'
                    text_size: self.width, None
                    size_hint_y: None
                    height: self.texture_size[1]
            BoxLayout:
                size_hint_y: None
                height: max(res_fort_card.minimum_height, res_mej_card.minimum_height)
                spacing: dp(14)
                NeoCard:
                    id: res_fort_card
                    surface: theme.TARJETA
                    padding: [dp(14), dp(11)]
                    orientation: 'vertical'
                    spacing: dp(4)
                    L:
                        text: 'FORTALEZAS'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        color: theme.VERDE
                        halign: 'left'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    L:
                        id: res_fortalezas
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    Widget:
                NeoCard:
                    id: res_mej_card
                    surface: theme.TARJETA
                    padding: [dp(14), dp(11)]
                    orientation: 'vertical'
                    spacing: dp(4)
                    L:
                        text: 'POR MEJORAR'
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        color: theme.NARANJA
                        halign: 'left'
                        valign: 'middle'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    L:
                        id: res_por_mejorar
                        text: ''
                        font_size: '13sp'
                        font_name: theme.F_DISPLAY
                        bold: True
                        halign: 'left'
                        valign: 'top'
                        text_size: self.width, None
                        size_hint_y: None
                        height: self.texture_size[1]
                    Widget:
            SectionTitle:
                text: 'DESGLOSE POR MÓDULO'
            BoxLayout:
                id: res_cards
                orientation: 'vertical'
                spacing: dp(12)
                size_hint_y: None
                height: self.minimum_height
            Widget:
                size_hint_y: None
                height: dp(6)
            NeoButton:
                id: res_boton
                text: 'IR A INICIO'
                surface: theme.MARINO
                color: theme.TEXTO
                font_size: '16sp'
                size_hint_y: None
                height: dp(60)
                on_press: root.salir()
"""
