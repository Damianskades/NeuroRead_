import 'package:flutter/widgets.dart';

class Presionable extends StatefulWidget {
  const Presionable({
    super.key,
    required this.onTap,
    required this.builder,
    this.habilitado = true,
  });

  final VoidCallback? onTap;
  final Widget Function(BuildContext context, bool presionado) builder;
  final bool habilitado;

  @override
  State<Presionable> createState() => _PresionableState();
}

class _PresionableState extends State<Presionable> {
  bool _presionado = false;

  void _marcar(bool valor) {
    if (_presionado != valor) {
      setState(() => _presionado = valor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activo = widget.habilitado && widget.onTap != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: activo ? (_) => _marcar(true) : null,
      onTapUp: activo ? (_) => _marcar(false) : null,
      onTapCancel: activo ? () => _marcar(false) : null,
      onTap: activo ? widget.onTap : null,
      child: widget.builder(context, activo && _presionado),
    );
  }
}
