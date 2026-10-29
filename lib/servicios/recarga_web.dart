import 'dart:js_interop';
import 'dart:js_interop_unsafe';

Future<void> reiniciarTrasLimpiarCache() async {
  final ubicacion = globalContext.getProperty<JSObject>('location'.toJS);
  ubicacion.callMethod<JSAny?>('reload'.toJS);
}
