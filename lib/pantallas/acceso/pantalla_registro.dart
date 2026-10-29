import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../estado/estado_usuario.dart';
import '../../estado/navegacion.dart';
import '../../logica/validacion_registro.dart';
import '../../servicios/errores.dart';
import '../../widgets/campos.dart';
import '../../widgets/neo_button.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/neo_icon.dart';
import '../../widgets/selector_grado.dart';
import '../../widgets/textos.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _usuario = TextEditingController();
  final _nombre = TextEditingController();
  final _apellido = TextEditingController();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  final _clave2 = TextEditingController();
  final _claveError = GlobalKey();
  String? _grado;
  String _error = '';
  bool _ocupado = false;

  @override
  void dispose() {
    for (final controlador in [
      _usuario,
      _nombre,
      _apellido,
      _correo,
      _clave,
      _clave2,
    ]) {
      controlador.dispose();
    }
    super.dispose();
  }

  void _mostrarError(String mensaje) {
    setState(() => _error = mensaje);
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      final contexto = _claveError.currentContext;
      if (contexto != null && contexto.mounted) {
        Scrollable.ensureVisible(
          contexto,
          alignment: 0.5,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _crear() async {
    if (_ocupado) {
      return;
    }
    final usuario = _usuario.text.trim();
    final nombre = limpiarNombre(_nombre.text);
    final apellido = limpiarNombre(_apellido.text);
    final correo = _correo.text.trim();
    final error = validarRegistro(
      usuario: usuario,
      nombre: nombre,
      apellido: apellido,
      grado: _grado,
      correo: correo,
      clave: _clave.text,
      clave2: _clave2.text,
    );
    if (error != null) {
      _mostrarError(error);
      return;
    }
    setState(() => _ocupado = true);
    try {
      await context.read<EstadoUsuario>().autenticacion.registrar(
        nombreUsuario: usuario,
        nombre: nombre,
        apellido: apellido,
        grado: _grado!,
        correo: correo,
        clave: _clave.text,
      );
      if (mounted) {
        setState(() => _error = '');
        context.read<Navegacion>().irA(Pantalla.bienvenida);
      }
    } on ErrorAcceso catch (error) {
      if (mounted) {
        _mostrarError(error.mensaje);
      }
    } finally {
      if (mounted) {
        setState(() => _ocupado = false);
      }
    }
  }

  List<Widget> _campo(
    String etiqueta,
    TextEditingController controlador,
    String pista, {
    bool oculto = false,
    TextInputType teclado = TextInputType.text,
    bool enviar = false,
  }) => [
    Etiqueta(etiqueta),
    CampoTexto(
      controlador: controlador,
      pista: pista,
      oculto: oculto,
      teclado: teclado,
      alEnviar: enviar ? (_) => _crear() : null,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 46, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                const NeoIcon.cuadrado('perfil', lado: 50),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: TextoDisplay('Crear cuenta', tamano: 26),
                    ),
                  ),
                ),
              ],
            ),
            const Texto(
              'Completa tus datos para empezar a entrenar tu lectura.',
              negrita: true,
            ),
            NeoCard(
              radio: 18,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  ..._campo(
                    'NOMBRE DE USUARIO',
                    _usuario,
                    'Por ejemplo: luciaperez',
                  ),
                  ..._campo('NOMBRE', _nombre, 'Tu nombre...'),
                  ..._campo('APELLIDO', _apellido, 'Tu apellido...'),
                  const Etiqueta('GRADO ESCOLAR'),
                  SelectorGrado(
                    elegido: _grado,
                    alElegir: (grado) => setState(() => _grado = grado),
                  ),
                  ..._campo(
                    'CORREO',
                    _correo,
                    'nombre@correo.com',
                    teclado: TextInputType.emailAddress,
                  ),
                  ..._campo(
                    'CONTRASEÑA',
                    _clave,
                    'Mínimo 6 caracteres',
                    oculto: true,
                  ),
                  ..._campo(
                    'REPITE LA CONTRASEÑA',
                    _clave2,
                    'Vuelve a escribirla',
                    oculto: true,
                    enviar: true,
                  ),
                  const SizedBox(height: 2),
                  ErrorFormulario(_error, key: _claveError),
                  NeoButton(
                    'CREAR CUENTA',
                    tamano: 16,
                    alto: 56,
                    onPressed: _crear,
                  ),
                  Enlace(
                    '¿Ya tienes cuenta? Inicia sesión',
                    onTap: () =>
                        context.read<Navegacion>().irA(Pantalla.acceso),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
