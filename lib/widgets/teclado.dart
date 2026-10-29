import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

enum _Parte { arriba, aviso, contador, campo, boton }

class ColumnaConCampo extends StatelessWidget {
  const ColumnaConCampo({
    super.key,
    required this.arriba,
    required this.aviso,
    required this.contador,
    required this.campo,
    required this.boton,
    this.espacio = 11,
    this.campoMinimo = 150,
  });

  final List<Widget> arriba;
  final Widget aviso;
  final Widget contador;
  final Widget campo;
  final Widget boton;
  final double espacio;
  final double campoMinimo;

  @override
  Widget build(BuildContext context) => CustomMultiChildLayout(
    delegate: _Distribucion(espacio, campoMinimo),
    children: [
      LayoutId(
        id: _Parte.arriba,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: espacio,
            children: arriba,
          ),
        ),
      ),
      LayoutId(id: _Parte.aviso, child: aviso),
      LayoutId(id: _Parte.contador, child: contador),
      LayoutId(id: _Parte.campo, child: campo),
      LayoutId(id: _Parte.boton, child: boton),
    ],
  );
}

class _Distribucion extends MultiChildLayoutDelegate {
  _Distribucion(this.espacio, this.campoMinimo);

  final double espacio;
  final double campoMinimo;

  @override
  void performLayout(Size size) {
    final ancho = BoxConstraints.tightFor(width: size.width);
    final suelto = ancho.copyWith(minHeight: 0, maxHeight: size.height);
    final aviso = layoutChild(_Parte.aviso, suelto).height;
    final contador = layoutChild(_Parte.contador, suelto).height;
    final boton = layoutChild(_Parte.boton, suelto).height;
    final fijos = aviso + contador + boton + espacio * 4;
    final libre = math.max(0.0, size.height - fijos - campoMinimo);
    final arriba = layoutChild(
      _Parte.arriba,
      ancho.copyWith(minHeight: 0, maxHeight: libre),
    ).height;
    final campo = math.max(0.0, size.height - fijos - arriba);
    layoutChild(
      _Parte.campo,
      ancho.copyWith(minHeight: campo, maxHeight: campo),
    );
    var y = 0.0;
    for (final (parte, alto) in [
      (_Parte.arriba, arriba),
      (_Parte.aviso, aviso),
      (_Parte.contador, contador),
      (_Parte.campo, campo),
      (_Parte.boton, boton),
    ]) {
      positionChild(parte, Offset(0, y));
      y += alto + espacio;
    }
  }

  @override
  bool shouldRelayout(_Distribucion anterior) =>
      anterior.espacio != espacio || anterior.campoMinimo != campoMinimo;
}

class GrupoSobreTeclado extends StatefulWidget {
  const GrupoSobreTeclado({super.key, required this.child});

  final Widget child;

  @override
  State<GrupoSobreTeclado> createState() => _GrupoSobreTecladoState();
}

class _GrupoSobreTecladoState extends State<GrupoSobreTeclado>
    with WidgetsBindingObserver {
  Timer? _espera;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusManager.instance.addListener(_programar);
  }

  @override
  void dispose() {
    _espera?.cancel();
    FocusManager.instance.removeListener(_programar);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() => _programar();

  void _programar() {
    _espera?.cancel();
    _espera = Timer(const Duration(milliseconds: 150), _mostrar);
  }

  bool _focoAdentro() {
    final foco = FocusManager.instance.primaryFocus?.context;
    if (foco == null) {
      return false;
    }
    var adentro = false;
    foco.visitAncestorElements((elemento) {
      if (identical(elemento, context)) {
        adentro = true;
        return false;
      }
      return true;
    });
    return adentro;
  }

  void _mostrar() {
    if (!mounted || !_focoAdentro()) {
      return;
    }
    final vista = View.of(context);
    if (vista.viewInsets.bottom <= 0) {
      return;
    }
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
