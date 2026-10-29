import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../contenido/actividades.dart';
import '../../contenido/libros.dart';
import '../../contenido/niveles.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/fechas.dart';
import '../../logica/validacion.dart';
import '../../modelos/progreso.dart';
import '../../tema/colores.dart';
import '../../widgets/campos.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_boton_icono.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_chip.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/teclado.dart';
import '../../widgets/textos.dart';

enum _Seccion { intro, paso, resumen }

class PantallaActividad extends StatefulWidget {
  const PantallaActividad({super.key});

  @override
  State<PantallaActividad> createState() => _PantallaActividadState();
}

class _PantallaActividadState extends State<PantallaActividad> {
  final _desplazamiento = ScrollController();
  final _campo = TextEditingController();
  final _claveAviso = GlobalKey();
  final _azar = math.Random();

  Actividad? _actividad;
  List<RespuestaPaso> _respuestas = [];
  _Seccion _seccion = _Seccion.intro;
  int _indice = 0;
  bool _respondido = false;
  String _retro = '';
  bool _retroBien = true;
  int? _elegida;
  List<String> _mezcla = const [];
  List<String> _ordenElegido = [];
  String _aviso = '';
  String _resumen = '';

  @override
  void initState() {
    super.initState();
    final id = context.read<Navegacion>().actividadId;
    _actividad = actividadPorId(id);
    final progreso = id == null
        ? null
        : context.read<EstadoUsuario>().progresoDe(id);
    _respuestas = List.of(progreso?.respuestas ?? const <RespuestaPaso>[]);
  }

  @override
  void dispose() {
    _desplazamiento.dispose();
    _campo.dispose();
    super.dispose();
  }

  Paso get _pasoActual => _actividad!.pasos[_indice];

  void _arriba() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_desplazamiento.hasClients) {
      _desplazamiento.jumpTo(0);
    }
  });

  bool _leido(EstadoUsuario estado) {
    final actividad = _actividad!;
    return estado
        .capitulosLeidos(actividad.libroId)
        .contains(actividad.capituloRequerido);
  }

  void _accionIntro() {
    final actividad = _actividad!;
    if (!_leido(context.read<EstadoUsuario>())) {
      context.read<Navegacion>().abrirLector(
        actividad.libroId,
        actividad.capituloRequerido,
        origen: 'actividad',
      );
      return;
    }
    if (_respuestas.length >= actividad.pasos.length) {
      _finalizar();
      return;
    }
    _cargarPaso();
  }

  void _cargarPaso() {
    _indice = _respuestas.length;
    final paso = _pasoActual;
    setState(() {
      _seccion = _Seccion.paso;
      _retro = '';
      _respondido = false;
      _elegida = null;
      _ordenElegido = [];
      _aviso = '';
      _campo.clear();
      if (paso is PasoOrdenar) {
        final mezcla = List.of(paso.elementos);
        while (mezcla.length > 1 && listEquals(mezcla, paso.elementos)) {
          mezcla.shuffle(_azar);
        }
        _mezcla = mezcla;
      }
    });
    _arriba();
  }

  void _registrar(bool correcta, Object valor) {
    final actividad = _actividad!;
    _respuestas.add(
      RespuestaPaso(
        paso: _respuestas.length,
        tipo: _pasoActual.tipo,
        correcta: correcta,
        valor: valor,
      ),
    );
    context.read<EstadoUsuario>().guardarProgreso(
      actividad.id,
      List.of(_respuestas),
    );
    _respondido = true;
  }

  void _responderOpcion(PasoOpcion paso, int indice) {
    if (_respondido) {
      return;
    }
    final bien = indice == paso.correcta;
    setState(() {
      _elegida = indice;
      _retroBien = bien;
      _retro = bien
          ? '¡Correcto!'
          : 'Incorrecto. La respuesta correcta está en verde.';
      _registrar(bien, indice);
    });
  }

  void _elegirOrden(String elemento) {
    if (_respondido || _ordenElegido.contains(elemento)) {
      return;
    }
    setState(() => _ordenElegido.add(elemento));
  }

  void _reiniciarOrden() {
    if (_respondido) {
      return;
    }
    setState(() {
      _ordenElegido = [];
      _retro = '';
    });
  }

  void _comprobarOrden(PasoOrdenar paso) {
    if (_respondido) {
      return;
    }
    if (_ordenElegido.length < paso.elementos.length) {
      setState(() {
        _retroBien = false;
        _retro = 'Toca todos los elementos en el orden que creas correcto.';
      });
      return;
    }
    final bien = listEquals(_ordenElegido, paso.elementos);
    setState(() {
      _retroBien = bien;
      _retro = bien
          ? '¡Correcto! El orden es el adecuado.'
          : 'El orden no es correcto. El orden correcto es:\n'
                '${[for (var i = 0; i < paso.elementos.length; i++) '${i + 1}. ${paso.elementos[i]}'].join('\n')}';
      _registrar(bien, List.of(_ordenElegido));
    });
  }

  void _comprobarEscrita(PasoEscrita paso) {
    if (_respondido) {
      return;
    }
    final redaccion = analizarRedaccion(
      _campo.text,
      minPalabras: paso.minPalabras,
    );
    if (!redaccion.valida) {
      setState(() => _aviso = redaccion.mensaje);
      WidgetsBinding.instance.addPostFrameCallback((_) => _mostrarAviso());
      return;
    }
    setState(() {
      _aviso = '';
      _retroBien = true;
      _retro = 'Respuesta guardada.';
      _registrar(true, _campo.text.trim());
    });
  }

  void _mostrarAviso() {
    final caja = _claveAviso.currentContext?.findRenderObject();
    if (caja == null || !_desplazamiento.hasClients) {
      return;
    }
    final vista = RenderAbstractViewport.of(caja);
    final posicion = _desplazamiento.position;
    final arriba = vista.getOffsetToReveal(caja, 0).offset - 24;
    final abajo = vista.getOffsetToReveal(caja, 1).offset + 24;
    final destino = posicion.pixels > arriba
        ? arriba
        : (posicion.pixels < abajo ? abajo : posicion.pixels);
    _desplazamiento.animateTo(
      destino.clamp(posicion.minScrollExtent, posicion.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _siguiente() {
    if (!_respondido) {
      return;
    }
    if (_respuestas.length >= _actividad!.pasos.length) {
      _finalizar();
    } else {
      _cargarPaso();
    }
  }

  void _finalizar() {
    final actividad = _actividad!;
    final aciertos = _respuestas.where((r) => r.correcta).length;
    final total = actividad.pasos.length;
    context.read<EstadoUsuario>().completarActividad(
      ActividadCompletada(
        actividadId: actividad.id,
        libroId: actividad.libroId,
        nivel: actividad.nivel,
        aciertos: aciertos,
        total: total,
        respuestas: List.of(_respuestas),
        fecha: DateTime.now(),
      ),
    );
    final mensaje = aciertos == total
        ? 'Excelente trabajo. Respondiste todo correctamente.'
        : aciertos * 2 >= total
        ? 'Buen trabajo. Revisa los pasos que fallaste para seguir mejorando.'
        : 'Sigue practicando. Vuelve a leer el texto y repite la actividad.';
    setState(() {
      _respuestas = [];
      _resumen = 'Aciertos: $aciertos de $total\n$mensaje';
      _seccion = _Seccion.resumen;
    });
    _arriba();
  }

  @override
  Widget build(BuildContext context) {
    final actividad = _actividad;
    final navegacion = context.read<Navegacion>();
    final libro = libroPorId(actividad?.libroId);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  spacing: 10,
                  children: [
                    NeoBotonIcono(
                      texto: 'VOLVER',
                      onTap: () => navegacion.volverDeActividad(
                        libroDeActividad: actividad?.libroId,
                      ),
                    ),
                    const Spacer(),
                    if (libro != null)
                      NeoBadge(
                        libro.titulo.toUpperCase(),
                        superficie: libro.color,
                        anchoMinimo: 120,
                        alto: 26,
                      ),
                  ],
                ),
              ),
              if (actividad != null)
                Expanded(
                  child: SingleChildScrollView(
                    controller: _desplazamiento,
                    padding: const EdgeInsets.fromLTRB(0, 4, 4, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 18,
                      children: [
                        TextoDisplay(actividad.titulo, tamano: 20),
                        switch (_seccion) {
                          _Seccion.intro => _intro(actividad),
                          _Seccion.paso => _paso(actividad),
                          _Seccion.resumen => _tarjetaResumen(navegacion),
                        },
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _intro(Actividad actividad) {
    final leido = _leido(context.watch<EstadoUsuario>());
    final habilidad = habilidades[actividad.habilidad]!;
    return NeoCard(
      radio: 18,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          const Etiqueta('OBJETIVO DE LECTURA'),
          TextoDisplay(
            habilidad.nombre,
            color: habilidad.color,
            contorno: false,
          ),
          Texto(actividad.objetivo, negrita: true),
          if (leido)
            const SizedBox.shrink()
          else
            Texto(
              'Lee el capítulo ${actividad.capituloRequerido} para '
              'desbloquear esta actividad',
              color: Colores.naranja,
              negrita: true,
            ),
          const SizedBox(height: 2),
          NeoButton(
            leido
                ? (_respuestas.isNotEmpty ? 'CONTINUAR' : 'EMPEZAR')
                : 'LEER CAPÍTULO',
            superficie: leido ? Colores.verde : Colores.dorado,
            tamano: 15,
            alto: 52,
            onPressed: _accionIntro,
          ),
        ],
      ),
    );
  }

  Widget _paso(Actividad actividad) {
    final paso = _pasoActual;
    final total = actividad.pasos.length;
    final numero = _indice + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Etiqueta('Paso $numero de $total'),
        NeoBar(
          valor: _respuestas.length.toDouble(),
          maximo: total.toDouble(),
          alto: 12,
        ),
        NeoCard(
          radio: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Texto(
            switch (paso) {
              PasoOpcion(:final pregunta) => pregunta,
              PasoOrdenar(:final instruccion) => instruccion,
              PasoEscrita(:final consigna) => consigna,
            },
            tamano: 14.5,
            negrita: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 4, 4),
          child: KeyedSubtree(
            key: ValueKey(numero),
            child: switch (paso) {
              PasoOpcion() => _zonaOpcion(paso),
              PasoOrdenar() => _zonaOrdenar(paso),
              PasoEscrita() => _zonaEscrita(paso),
            },
          ),
        ),
        if (_retro.isEmpty)
          const SizedBox.shrink()
        else
          Texto(
            _retro,
            tamano: 13.5,
            color: _retroBien ? Colores.verde : Colores.rojo,
            negrita: true,
          ),
        Opacity(
          opacity: _respondido ? 1 : 0,
          child: NeoButton(
            'SIGUIENTE',
            superficie: Colores.dorado,
            tamano: 15,
            alto: 52,
            habilitado: _respondido,
            onPressed: _siguiente,
          ),
        ),
      ],
    );
  }

  Widget _zonaOpcion(PasoOpcion paso) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 12,
    children: [
      for (var i = 0; i < paso.opciones.length; i++)
        ChipOpcion(
          indice: i,
          texto: paso.opciones[i],
          habilitado: !_respondido,
          estado: !_respondido
              ? EstadoOpcion.normal
              : i == paso.correcta
              ? EstadoOpcion.correcta
              : i == _elegida
              ? EstadoOpcion.incorrecta
              : EstadoOpcion.normal,
          onTap: () => _responderOpcion(paso, i),
        ),
    ],
  );

  Widget _zonaOrdenar(PasoOrdenar paso) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 12,
    children: [
      for (final elemento in _mezcla)
        _chipOrden(paso, elemento, _ordenElegido.indexOf(elemento)),
      SizedBox(
        height: 52,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Expanded(
              child: Opacity(
                opacity: _respondido ? 0.5 : 1,
                child: NeoButton(
                  'REINICIAR',
                  superficie: Colores.tarjetaAlt,
                  colorTexto: Colores.texto,
                  tamano: 14,
                  habilitado: !_respondido,
                  onPressed: _reiniciarOrden,
                ),
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: _respondido ? 0.5 : 1,
                child: NeoButton(
                  'COMPROBAR',
                  superficie: Colores.verde,
                  tamano: 14,
                  habilitado: !_respondido,
                  onPressed: () => _comprobarOrden(paso),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _chipOrden(PasoOrdenar paso, String elemento, int posicion) {
    final elegido = posicion >= 0;
    final (superficie, color) = !_respondido
        ? (
            elegido ? Colores.dorado : Colores.tarjetaAlt,
            elegido ? Colores.textoOscuro : Colores.texto,
          )
        : paso.elementos.indexOf(elemento) == posicion
        ? (Colores.verde, Colores.textoOscuro)
        : (Colores.rojo, Colores.texto);
    return NeoChip(
      elegido ? '${posicion + 1}. $elemento' : elemento,
      onTap: () => _elegirOrden(elemento),
      habilitado: !_respondido,
      superficie: superficie,
      colorTexto: color,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 21),
      altoMinimo: 56,
    );
  }

  Widget _zonaEscrita(PasoEscrita paso) {
    final palabras = contarPalabras(_campo.text);
    return GrupoSobreTeclado(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          KeyedSubtree(
            key: _claveAviso,
            child: _aviso.isEmpty
                ? const SizedBox.shrink()
                : Texto(_aviso, color: Colores.rojo, negrita: true),
          ),
          ContadorPalabras(
            '${plural(palabras, 'palabra', 'palabras')} de ${paso.minPalabras} mínimas',
            color: palabras >= paso.minPalabras
                ? Colores.verde
                : Colores.textoSec,
          ),
          CampoTexto.largo(
            controlador: _campo,
            pista: 'Escribe tu respuesta aquí...',
            soloLectura: _respondido,
            alCambiar: (_) => setState(() {}),
          ),
          Opacity(
            opacity: _respondido ? 0.5 : 1,
            child: NeoButton(
              'COMPROBAR',
              superficie: Colores.verde,
              tamano: 14,
              alto: 52,
              habilitado: !_respondido,
              onPressed: () => _comprobarEscrita(paso),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaResumen(Navegacion navegacion) => NeoCard(
    radio: 18,
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            const NeoIcon.cuadrado('trofeo', lado: 46),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 46),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: TextoDisplay(
                    '¡Actividad completada!',
                    tamano: 18,
                    contorno: false,
                  ),
                ),
              ),
            ),
          ],
        ),
        Texto(_resumen, tamano: 13.5, negrita: true),
        NeoButton(
          'VOLVER A MI RUTA',
          superficie: Colores.verde,
          tamano: 15,
          alto: 52,
          onPressed: () => navegacion.irAPestana(Pestanas.ruta),
        ),
      ],
    ),
  );
}
