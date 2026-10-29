import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../servicios/errores.dart';
import '../../tema/colores.dart';
import '../../tema/tipografia.dart';
import '../../widgets/campos.dart';
import '../../widgets/neo_badge.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_deco.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/textos.dart';

class PantallaAcceso extends StatefulWidget {
  const PantallaAcceso({super.key});

  @override
  State<PantallaAcceso> createState() => _PantallaAccesoState();
}

class _PantallaAccesoState extends State<PantallaAcceso> {
  final _usuario = TextEditingController();
  final _clave = TextEditingController();
  String _error = '';
  bool _ocupado = false;

  @override
  void dispose() {
    _usuario.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (_ocupado) {
      return;
    }
    final nombre = _usuario.text.trim();
    final clave = _clave.text;
    if (nombre.isEmpty || clave.isEmpty) {
      setState(() => _error = 'Completa usuario y contraseña para entrar.');
      return;
    }
    setState(() => _ocupado = true);
    try {
      final usuario = await context
          .read<EstadoUsuario>()
          .autenticacion
          .iniciarSesion(nombre, clave);
      if (mounted) {
        context.read<Navegacion>().entrar(
          evaluacionInicialHecha: usuario.evaluacionInicial,
        );
      }
    } on ErrorAcceso catch (error) {
      if (mounted) {
        setState(() {
          _error = error.mensaje;
          if (error.mensaje == Mensajes.credenciales) {
            _clave.clear();
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() => _ocupado = false);
      }
    }
  }

  Widget _campo(
    String icono,
    Color color,
    TextEditingController controlador,
    String pista, {
    bool oculto = false,
  }) => SizedBox(
    height: 48,
    child: Row(
      spacing: 10,
      children: [
        NeoIcon.cuadrado(icono, lado: 42, colorChip: color),
        Expanded(
          child: CampoTexto(
            controlador: controlador,
            pista: pista,
            oculto: oculto,
            colorCursor: color,
            alEnviar: (_) => _entrar(),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, limites) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: limites.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 64, 28, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    const NeoDeco(semilla: 31, alto: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        const NeoIcon.cuadrado('brain', lado: 50),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 50),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: TextoDisplay(
                                '',
                                tamano: 26,
                                span: TextSpan(
                                  children: [
                                    TextSpan(text: 'NEURO'),
                                    TextSpan(
                                      text: 'READ',
                                      style: TextStyle(color: Colores.verde),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 22),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Texto(
                          'Inicia sesión con tu perfil para entrenar tu lectura',
                          negrita: true,
                        ),
                      ),
                    ),
                    NeoCard(
                      radio: 20,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 10,
                        children: [
                          const SizedBox(
                            height: 26,
                            child: Row(
                              spacing: 8,
                              children: [
                                NeoBadge(
                                  'INICIAR SESIÓN',
                                  superficie: Colores.verde,
                                  ancho: 116,
                                  alto: 26,
                                ),
                                Expanded(
                                  child: NeoDeco(
                                    semilla: 8,
                                    tinte: Colores.verde,
                                    alto: 26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Etiqueta('USUARIO O CORREO'),
                          _campo(
                            'perfil',
                            Colores.turquesa,
                            _usuario,
                            'Tu usuario o correo...',
                          ),
                          const Etiqueta('CONTRASEÑA'),
                          _campo(
                            'candado',
                            Colores.naranja,
                            _clave,
                            'Tu contraseña...',
                            oculto: true,
                          ),
                          ErrorFormulario(_error),
                          NeoButton(
                            'ENTRAR',
                            superficie: Colores.verde,
                            tamano: 16,
                            alto: 56,
                            onPressed: _entrar,
                          ),
                          Enlace(
                            '¿No tienes cuenta? Regístrate',
                            onTap: () => context.read<Navegacion>().irA(
                              Pantalla.registro,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const NeoDeco(
                      semilla: 23,
                      tinte: Colores.turquesa,
                      alto: 28,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 22),
                      child: Center(
                        child: Text(
                          'Tu progreso se guarda por perfil. NeuroRead v3',
                          textAlign: TextAlign.center,
                          style: Tipografia.display(
                            13,
                            color: Colores.textoSec,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
