import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../servicios/errores.dart';
import '../../tema/colores.dart';
import '../../widgets/campos.dart';
import '../../widgets/modales.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/textos.dart';

class ModalEliminar extends StatefulWidget {
  const ModalEliminar({super.key});

  @override
  State<ModalEliminar> createState() => _ModalEliminarState();
}

class _ModalEliminarState extends State<ModalEliminar> {
  final _clave = TextEditingController();
  String _error = '';
  bool _ocupado = false;

  @override
  void dispose() {
    _clave.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    if (_ocupado) {
      return;
    }
    if (_clave.text.isEmpty) {
      setState(() => _error = 'Escribe tu contraseña para confirmar.');
      return;
    }
    final estado = context.read<EstadoUsuario>();
    final navegacion = context.read<Navegacion>();
    final navegador = Navigator.of(context);
    setState(() => _ocupado = true);
    try {
      await estado.eliminarCuenta(_clave.text);
      navegador.pop();
      navegacion.irA(Pantalla.acceso);
    } on ErrorAcceso catch (error) {
      if (mounted) {
        setState(() {
          _error = error.mensaje;
          _clave.clear();
          _ocupado = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => ModalNeo(
    ancho: 340,
    espacio: 12,
    children: [
      const TextoDisplay(
        'Eliminar cuenta',
        tamano: 20,
        color: Colores.rojo,
        contorno: false,
      ),
      const Texto(
        'Se borrarán tu perfil, tus evaluaciones y tu progreso. '
        'Esta acción no se puede deshacer.',
      ),
      CampoTexto(
        controlador: _clave,
        pista: 'Tu contraseña...',
        oculto: true,
        colorCursor: Colores.rojo,
        alEnviar: (_) => _confirmar(),
      ),
      ErrorFormulario(_error),
      SizedBox(
        height: 52,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Expanded(
              child: NeoButton(
                'ELIMINAR',
                superficie: Colores.rojo,
                colorTexto: Colores.texto,
                tamano: 14,
                habilitado: !_ocupado,
                onPressed: _confirmar,
              ),
            ),
            Expanded(
              child: NeoButton(
                'CANCELAR',
                superficie: Colores.tarjetaAlt,
                colorTexto: Colores.texto,
                tamano: 14,
                habilitado: !_ocupado,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Future<void> mostrarModalEliminar(BuildContext context) =>
    mostrarModal<void>(context, (_) => const ModalEliminar());
