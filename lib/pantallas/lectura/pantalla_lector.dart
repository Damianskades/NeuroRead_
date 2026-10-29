import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../contenido/libros.dart';
import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../tema/colores.dart';
import '../../widgets/neo_boton_icono.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/textos.dart';

class PantallaLector extends StatefulWidget {
  const PantallaLector({super.key});

  @override
  State<PantallaLector> createState() => _PantallaLectorState();
}

class _PantallaLectorState extends State<PantallaLector> {
  final _desplazamiento = ScrollController();
  late final String _libroId;
  int _numero = 1;
  bool _leido = false;
  List<String> _parrafos = const [];

  @override
  void initState() {
    super.initState();
    final navegacion = context.read<Navegacion>();
    _libroId = navegacion.libroId ?? '';
    _cargar(navegacion.numeroCapitulo);
  }

  @override
  void dispose() {
    _desplazamiento.dispose();
    super.dispose();
  }

  Future<void> _cargar(int numero) async {
    if (libroPorId(_libroId) == null || capituloDe(_libroId, numero) == null) {
      return;
    }
    if (_desplazamiento.hasClients) {
      _desplazamiento.jumpTo(0);
    }
    setState(() {
      _numero = numero;
      _parrafos = const [];
      _leido = context
          .read<EstadoUsuario>()
          .capitulosLeidos(_libroId)
          .contains(numero);
    });
    final parrafos = await parrafosCapitulo(_libroId, numero);
    if (!mounted || numero != _numero) {
      return;
    }
    setState(() => _parrafos = parrafos);
  }

  bool get _esUltimo => _numero >= libroPorId(_libroId)!.capitulos.length;

  String get _textoBoton => !_leido
      ? 'MARCAR COMO LEÍDO'
      : _esUltimo
      ? 'VOLVER AL LIBRO'
      : 'SIGUIENTE CAPÍTULO';

  void _accion() {
    if (!_leido) {
      context.read<EstadoUsuario>().marcarCapituloLeido(_libroId, _numero);
      setState(() => _leido = true);
    } else if (_esUltimo) {
      context.read<Navegacion>().abrirLibro(_libroId);
    } else {
      _cargar(_numero + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final libro = libroPorId(_libroId);
    final capitulo = capituloDe(_libroId, _numero);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: NeoBotonIcono(
                  texto: 'VOLVER',
                  onTap: context.read<Navegacion>().volverDeLector,
                ),
              ),
              Etiqueta(libro?.titulo.toUpperCase() ?? ''),
              TextoDisplay(capitulo?.titulo ?? '', tamano: 22),
              Expanded(
                child: SingleChildScrollView(
                  controller: _desplazamiento,
                  padding: const EdgeInsets.fromLTRB(0, 6, 4, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 18,
                    children: [
                      NeoCard(
                        radio: 16,
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 14,
                          children: [
                            for (final parrafo in _parrafos)
                              Texto(
                                parrafo,
                                tamano: 15,
                                color: Colores.texto,
                                interlineado: 1.5,
                              ),
                          ],
                        ),
                      ),
                      NeoButton(
                        _textoBoton,
                        superficie: Colores.verde,
                        tamano: 15,
                        alto: 54,
                        onPressed: _accion,
                      ),
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
}
