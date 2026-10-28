import 'package:flutter/widgets.dart';

import '../tema/tipografia.dart';

class EscalaTexto extends StatelessWidget {
  const EscalaTexto({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(Tipografia.escalaTexto)),
    child: child,
  );
}
