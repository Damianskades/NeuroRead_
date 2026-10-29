import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../widgets/campos.dart';

class MarcoModulo extends StatelessWidget {
  const MarcoModulo({super.key, required this.children, this.espacio = 12});

  final List<Widget> children;
  final double espacio;

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    body: SobreTeclado(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 46, 20, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: espacio,
            children: children,
          ),
        ),
      ),
    ),
  );
}

class SobreTeclado extends StatefulWidget {
  const SobreTeclado({super.key, required this.child});

  final Widget child;

  @override
  State<SobreTeclado> createState() => _SobreTecladoState();
}

class _SobreTecladoState extends State<SobreTeclado>
    with WidgetsBindingObserver {
  final _clave = GlobalKey();
  double _subida = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusManager.instance.addListener(_alCambiarFoco);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_alCambiarFoco);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() => _alCambiarFoco();

  void _alCambiarFoco() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _medir());

  void _medir() {
    if (!mounted) {
      return;
    }
    final vista = View.of(context);
    final teclado = vista.viewInsets.bottom / vista.devicePixelRatio;
    var subida = 0.0;
    final foco = FocusManager.instance.primaryFocus?.context;
    final propio = _clave.currentContext?.findRenderObject();
    RenderObject? caja = foco?.findRenderObject();
    foco?.visitAncestorElements((elemento) {
      if (elemento.widget is ObjetivoTeclado) {
        caja = elemento.findRenderObject();
        return false;
      }
      return true;
    });
    final objetivo = caja;
    if (teclado > 0 &&
        propio is RenderBox &&
        objetivo is RenderBox &&
        objetivo.attached &&
        _contiene(propio, objetivo)) {
      final abajo =
          objetivo.localToGlobal(Offset(0, objetivo.size.height)).dy + _subida;
      final visible =
          vista.physicalSize.height / vista.devicePixelRatio - teclado;
      subida = math.max(0, abajo - visible);
    }
    if (subida != _subida) {
      setState(() => _subida = subida);
    }
  }

  bool _contiene(RenderObject ancestro, RenderObject nodo) {
    RenderObject? actual = nodo;
    while (actual != null) {
      if (identical(actual, ancestro)) {
        return true;
      }
      actual = actual.parent;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => Transform.translate(
    offset: Offset(0, -_subida),
    child: KeyedSubtree(key: _clave, child: widget.child),
  );
}
