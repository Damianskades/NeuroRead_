import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/modulos.dart';
import '../../contenido/niveles.dart';
import '../../estado/estado_evaluacion.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/puntajes.dart';
import '../../tema/colores.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/textos.dart';

class PantallaResultados extends StatefulWidget {
  const PantallaResultados({super.key});

  @override
  State<PantallaResultados> createState() => _PantallaResultadosState();
}

class _PantallaResultadosState extends State<PantallaResultados> {
  late final String? _sesionId = context.read<Navegacion>().sesionId;

  @override
  void initState() {
    super.initState();
    if (_sesionId == null) {
      _guardarNueva();
    }
  }

  void _guardarNueva() {
    final evaluacion = context.read<EstadoEvaluacion>();
    final estado = context.read<EstadoUsuario>();
    final datos = evaluacion.datos;
    final usuario = estado.usuario;
    if (datos == null || usuario == null || evaluacion.guardada) {
      return;
    }
    final sesion = sesionParaGuardar(
      datos,
      tipo: evaluacion.tipo,
      fecha: DateTime.now(),
    );
    if (evaluacion.tipo == 'clasificatoria') {
      final previa = estado.ultimaSesion;
      evaluacion.comparacion = previa == null
          ? null
          : comparar(
              previa.puntajeGlobal,
              porClave(usuario.nivel) ?? nivelDe(previa.puntajeGlobal),
              sesion.puntajeGlobal,
              nivelDe(sesion.puntajeGlobal),
            );
    }
    estado.guardarSesion(sesion, inicial: evaluacion.tipo == 'inicial');
    evaluacion.guardada = true;
  }

  DatosNeuroScore? _datos(EstadoUsuario estado) {
    final id = _sesionId;
    if (id == null) {
      final evaluacion = context.read<EstadoEvaluacion>();
      final datos = evaluacion.datos;
      return datos == null
          ? null
          : datosSesionActual(datos, comparacion: evaluacion.comparacion);
    }
    final sesion = estado.sesionPorId(id);
    return sesion == null
        ? null
        : datosSesionGuardada(sesion, estado.sesionAnteriorA(id));
  }

  @override
  Widget build(BuildContext context) {
    final datos = _datos(context.watch<EstadoUsuario>());
    final navegacion = context.read<Navegacion>();
    return Scaffold(
      body: SafeArea(
        child: datos == null
            ? const SizedBox.expand()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 46, 20, 38),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 13,
                  children: [
                    if (datos.encabezado == null)
                      const SizedBox.shrink()
                    else
                      Texto(
                        datos.encabezado!,
                        color: Colores.textoSec,
                        negrita: true,
                      ),
                    const _Encabezado(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Texto(
                          'Texto evaluado: ${datos.textoTitulo}',
                          color: Colores.textoSec,
                          negrita: true,
                        ),
                      ),
                    ),
                    _TarjetaPuntaje(datos: datos),
                    NeoCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Texto(
                        datos.nivel.retroalimentacion,
                        negrita: true,
                      ),
                    ),
                    if (datos.comparacion == null)
                      const SizedBox.shrink()
                    else
                      _TarjetaComparacion(datos.comparacion!),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 14,
                        children: [
                          _Lista('FORTALEZAS', Colores.verde, datos.fortalezas),
                          _Lista(
                            'POR MEJORAR',
                            Colores.naranja,
                            datos.porMejorar,
                          ),
                        ],
                      ),
                    ),
                    const TituloSeccion('DESGLOSE POR MÓDULO'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12,
                      children: [
                        for (final modulo in datos.modulos)
                          _TarjetaModulo(
                            modulo,
                            datos.porcentajes[modulo.codigo] ?? 0,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    NeoButton(
                      datos.encabezado == null ? 'IR A INICIO' : 'VOLVER',
                      superficie: Colores.marino,
                      colorTexto: Colores.texto,
                      tamano: 16,
                      alto: 60,
                      onPressed: navegacion.salirDeResultados,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 12,
    children: [
      const NeoIcon.cuadrado('gauge', lado: 50, colorChip: Colores.marino),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 2,
          children: [
            const TextoDisplay(
              '',
              tamano: 23,
              span: TextSpan(
                children: [
                  TextSpan(text: 'Neuro'),
                  TextSpan(
                    text: 'Score',
                    style: TextStyle(color: Colores.azul),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 18),
              child: const Texto(
                'Panel 1 de 3: tu perfil lector de hoy',
                color: Colores.textoSec,
                negrita: true,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _TarjetaPuntaje extends StatelessWidget {
  const _TarjetaPuntaje({required this.datos});

  final DatosNeuroScore datos;

  @override
  Widget build(BuildContext context) {
    final nivel = datos.nivel;
    return NeoCard(
      superficie: Colores.marino,
      radio: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          const Texto(
            'PUNTAJE GLOBAL',
            color: Colores.textoSec,
            negrita: true,
            alineacion: TextAlign.center,
          ),
          Center(
            child: TextoDisplay(
              '',
              tamano: 52,
              color: nivel.color,
              alineacion: TextAlign.center,
              span: TextSpan(
                text: '${datos.puntaje}',
                children: const [
                  TextSpan(
                    text: '%',
                    style: TextStyle(fontSize: 18, color: Colores.textoSec),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: NeoBadge(
              nivel.nombre,
              superficie: nivel.color,
              tamano: 13,
              ancho: 190,
              alto: 34,
            ),
          ),
          Texto(
            '${nivel.nombre} va de ${nivel.minimo}% a ${nivel.maximo}%',
            color: Colores.textoSec,
            negrita: true,
            alineacion: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TarjetaComparacion extends StatelessWidget {
  const _TarjetaComparacion(this.comparacion);

  final Comparacion comparacion;

  Widget _cifra(int valor, String texto) => Expanded(
    child: NeoCard(
      superficie: Colores.tarjetaAlt,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 2,
        children: [
          Center(
            child: TextoDisplay(
              '$valor%',
              tamano: 21,
              alineacion: TextAlign.center,
            ),
          ),
          Texto(
            texto,
            color: Colores.textoSec,
            negrita: true,
            alineacion: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final (texto, fondo, color) = insigniaDiferencia(comparacion.diferencia);
    return NeoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 18),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Texto(
                'COMPARACIÓN CON TU EVALUACIÓN ANTERIOR',
                color: Colores.textoSec,
                negrita: true,
              ),
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                _cifra(comparacion.anterior, 'Anterior'),
                _cifra(comparacion.nuevo, 'Nuevo'),
              ],
            ),
          ),
          SizedBox(
            height: 28,
            child: Center(
              child: NeoBadge(
                texto,
                superficie: fondo,
                colorTexto: color,
                anchoMinimo: 150,
                alto: 26,
              ),
            ),
          ),
          Texto(
            comparacion.mensaje,
            color: switch (comparacion.signo) {
              1 => Colores.verde,
              0 => Colores.dorado,
              _ => Colores.rojo,
            },
            negrita: true,
            alineacion: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  const _Lista(this.titulo, this.color, this.elementos);

  final String titulo;
  final Color color;
  final List<String> elementos;

  @override
  Widget build(BuildContext context) => Expanded(
    child: NeoCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Texto(titulo, color: color, negrita: true),
          Texto(elementos.join('\n'), negrita: true),
        ],
      ),
    ),
  );
}

class _TarjetaModulo extends StatelessWidget {
  const _TarjetaModulo(this.modulo, this.porcentaje);

  final ModuloResultado modulo;
  final double porcentaje;

  @override
  Widget build(BuildContext context) {
    final color = Colores.modulosCodigo[modulo.codigo]!;
    return NeoCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(
                child: TextoDisplay(
                  nombresModulos[modulo.codigo]!,
                  tamano: 14.5,
                  color: color,
                  contorno: false,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextoDisplay(
                  modulo.valor,
                  tamano: 15,
                  contorno: false,
                  alineacion: TextAlign.right,
                ),
              ),
            ],
          ),
          NeoBar(valor: porcentaje, relleno: color, alto: 12),
          Texto(modulo.detalle, negrita: true),
        ],
      ),
    );
  }
}
