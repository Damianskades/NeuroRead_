import 'package:flutter/material.dart';

class MarcoModulo extends StatelessWidget {
  const MarcoModulo({super.key, required this.children, this.espacio = 12});

  final List<Widget> children;
  final double espacio;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 46, 20, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: espacio,
          children: children,
        ),
      ),
    ),
  );
}
