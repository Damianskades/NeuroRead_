import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/libros.dart';
import '../../contenido/modulos.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/logros.dart';
import '../../logica/puntajes.dart';
import '../../logica/redondeo.dart';
import '../../tema/colores.dart';
import '../../widgets/circulos.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_bar.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/textos.dart';
import '../perfil/modal_eliminar.dart';

const _tipos = [
  ('literal', 'Literal', Colores.verde),
  ('critica', 'Crítica', Colores.naranja),
  ('inferencial', 'Inferencial', Colores.azul),
];

class PestanaPerfil extends StatefulWidget {
  const PestanaPerfil({super.key});

  @override
  State<PestanaPerfil> createState() => _PestanaPerfilState();
}

class _PestanaPerfilState extends State<PestanaPerfil> {
  late final String _mensaje;

  @override
  void initState() {
    super.initState();
    final navegacion = context.read<Navegacion>();
    _mensaje = navegacion.mensajePerfil;
    navegacion.mensajePerfil = '';
  }

  Future<void> _cerrarSesion() async {
    final navegacion = context.read<Navegacion>();
    await context.read<EstadoUsuario>().cerrarSesion();
    navegacion.irA(Pantalla.acceso);
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<EstadoUsuario>();
    final usuario = estado.usuario;
    if (usuario == null) {
      return const SizedBox.expand();
    }
    final (nivel, ultima) = estado.nivelActual;
    final estadisticas = estado.estadisticas;
    final primera = estado.primeraSesion;
    final nombre = '${usuario.nombre} ${usuario.apellido}'.trim();
    final inicial = usuario.nombre.isNotEmpty
        ? usuario.nombre
        : (usuario.nombreUsuario.isNotEmpty ? usuario.nombreUsuario : '?');
    final logros = generarLogros(
      sesiones: estado.sesiones,
      leidosPorLibro: {
        for (final MapEntry(:key, :value) in estado.leidosPorLibro.entries)
          key: value.length,
      },
      capitulosPorLibro: capitulosPorLibro(),
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [
          if (_mensaje.isEmpty)
            const SizedBox.shrink()
          else
            Texto(_mensaje, color: Colores.verde, negrita: true),
          NeoCard(
            radio: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                CirculoInicial(inicial[0].toUpperCase()),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4,
                    children: [
                      TextoDisplay(
                        nombre.isEmpty ? usuario.nombreUsuario : nombre,
                        tamano: 22,
                        contorno: false,
                      ),
                      Texto(
                        usuario.grado.isEmpty
                            ? '@${usuario.nombreUsuario}'
                            : '@${usuario.nombreUsuario}. ${usuario.grado}',
                        color: Colores.textoSec,
                        negrita: true,
                      ),
                      SizedBox(
                        height: 28,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: NeoBadge(
                            nivel.nombre,
                            superficie: nivel.color,
                            ancho: 120,
                            alto: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                _Cifra('${estadisticas.total}', 'Evaluaciones', Colores.texto),
                _Cifra(
                  '${estadisticas.racha}',
                  'Días de racha',
                  Colores.naranja,
                ),
                _Cifra(
                  '${estadisticas.mejor}%',
                  'Mejor puntaje',
                  Colores.dorado,
                ),
              ],
            ),
          ),
          const Etiqueta('TU EVOLUCIÓN'),
          _Evolucion(primera: primera, ultima: ultima),
          const Etiqueta('PUNTAJE POR MÓDULO'),
          _TarjetaBarras(
            ultima == null
                ? const []
                : [
                    for (final MapEntry(key: codigo, value: campo)
                        in camposModulos.entries)
                      (
                        nombresModulos[codigo]!,
                        (ultima.valor(campo) ?? 0).toDouble(),
                        Colores.modulosCodigo[codigo]!,
                      ),
                  ],
          ),
          const Etiqueta('TIPOS DE COMPRENSIÓN'),
          _TarjetaBarras([
            if (ultima != null)
              for (final (clave, nombre, color) in _tipos)
                if (ultima.valor(clave) != null)
                  (nombre, ultima.valor(clave)!.toDouble(), color),
          ]),
          NeoCard(
            superficie: Colores.tarjetaAlt,
            radio: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 14,
              children: [
                const NeoIcon.cuadrado(
                  'bombilla',
                  lado: 46,
                  colorChip: Colores.azul,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 6,
                    children: [
                      const Etiqueta('RECOMENDACIÓN DE NEUROCOACH'),
                      Texto(nivel.recomendacion, negrita: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Etiqueta('LOGROS'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [for (final logro in logros) _TarjetaLogro(logro)],
          ),
          const SizedBox(height: 4),
          NeoButton(
            'EDITAR PERFIL',
            superficie: Colores.tarjetaAlt,
            colorTexto: Colores.texto,
            alto: 52,
            onPressed: () =>
                context.read<Navegacion>().irA(Pantalla.editarPerfil),
          ),
          NeoButton(
            'CERRAR SESIÓN',
            superficie: Colores.transparente,
            colorBorde: Colores.rojo,
            colorTexto: Colores.rojo,
            sombra: 0,
            alto: 52,
            onPressed: _cerrarSesion,
          ),
          Enlace(
            'Eliminar cuenta',
            color: Colores.rojo,
            onTap: () => mostrarModalEliminar(context),
          ),
        ],
      ),
    );
  }
}

class _Cifra extends StatelessWidget {
  const _Cifra(this.valor, this.texto, this.color);

  final String valor;
  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: NeoCard(
      radio: 14,
      sombra: 3,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 2,
        children: [
          TextoDisplay(
            valor,
            tamano: 24,
            color: color,
            contorno: false,
            alineacion: TextAlign.center,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 16),
            child: Texto(
              texto,
              color: Colores.textoSec,
              negrita: true,
              alineacion: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

class _Evolucion extends StatelessWidget {
  const _Evolucion({required this.primera, required this.ultima});

  final SesionResumen? primera;
  final SesionResumen? ultima;

  Widget _columna(String titulo, SesionResumen? sesion) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        Texto(
          titulo,
          color: Colores.textoSec,
          negrita: true,
          alineacion: TextAlign.center,
        ),
        TextoDisplay(
          sesion == null ? '--' : '${sesion.puntajeGlobal}%',
          tamano: 30,
          color: sesion == null ? Colores.texto : nivelDeSesion(sesion).color,
          contorno: false,
          alineacion: TextAlign.center,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final hayDatos = primera != null && ultima != null;
    final (texto, fondo, color) = hayDatos
        ? insigniaDiferencia(ultima!.puntajeGlobal - primera!.puntajeGlobal)
        : ('SIN DATOS', Colores.tarjetaAlt, Colores.textoSec);
    return NeoCard(
      radio: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                _columna('INICIAL', hayDatos ? primera : null),
                const SizedBox(
                  width: 2,
                  child: ColoredBox(color: Colores.tarjetaAlt),
                ),
                _columna('ACTUAL', hayDatos ? ultima : null),
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
        ],
      ),
    );
  }
}

class _TarjetaBarras extends StatelessWidget {
  const _TarjetaBarras(this.filas);

  final List<(String, double, Color)> filas;

  @override
  Widget build(BuildContext context) {
    final indices = List.generate(filas.length, (i) => i)
      ..sort((a, b) {
        final orden = filas[b].$2.compareTo(filas[a].$2);
        return orden != 0 ? orden : a.compareTo(b);
      });
    final ordenadas = [for (final i in indices) filas[i]];
    return NeoCard(
      radio: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: ordenadas.isEmpty
          ? const Texto('Aún no hay datos. Completa una evaluación.')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                for (final (nombre, valor, color) in ordenadas)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Expanded(child: Texto(nombre, negrita: true)),
                          SizedBox(
                            width: 48,
                            child: Texto(
                              '${redondear(valor)}%',
                              color: color,
                              negrita: true,
                              alineacion: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      NeoBar(valor: valor, relleno: color, radio: 5, alto: 11),
                    ],
                  ),
              ],
            ),
    );
  }
}

class _TarjetaLogro extends StatelessWidget {
  const _TarjetaLogro(this.logro);

  final Logro logro;

  @override
  Widget build(BuildContext context) {
    final ok = logro.ok;
    final color = ok ? Colores.texto : Colores.textoSec;
    return NeoCard(
      radio: 16,
      sombra: 3,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          NeoIcon.cuadrado(
            'trofeo',
            lado: 40,
            colorChip: ok ? Colores.dorado : Colores.tarjetaAlt,
            colorGlifo: ok ? null : Colores.textoSec,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 2,
              children: [
                Texto(logro.nombre, tamano: 13.5, color: color, negrita: true),
                Texto(logro.detalle, color: color, negrita: true),
              ],
            ),
          ),
          NeoBadge(
            ok ? 'LOGRADO' : 'BLOQUEADO',
            superficie: ok ? Colores.verde : Colores.tarjetaAlt,
            colorTexto: ok ? Colores.textoOscuro : Colores.textoSec,
            ancho: 84,
            alto: 22,
          ),
        ],
      ),
    );
  }
}
