import 'dart:js_interop';
import 'dart:js_interop_unsafe';

const _marca = 'sesion';
const _valor = 'cerrada';

JSObject _global(String nombre) =>
    globalContext.getProperty<JSObject>(nombre.toJS);

String _ruta() =>
    _global('location').getProperty<JSString>('pathname'.toJS).toDart;

Future<void> reiniciarTrasLimpiarCache() async {
  _global('location')
      .callMethod<JSAny?>('replace'.toJS, '${_ruta()}?$_marca=$_valor'.toJS);
}

bool consumirInicioSinCarga() {
  if (Uri.base.queryParameters[_marca] != _valor) {
    return false;
  }
  final historia = _global('history');
  historia.callMethodVarArgs<JSAny?>('replaceState'.toJS, [
    historia.getProperty<JSAny?>('state'.toJS),
    ''.toJS,
    _ruta().toJS,
  ]);
  return true;
}
