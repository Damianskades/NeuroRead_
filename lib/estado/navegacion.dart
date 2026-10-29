import 'package:flutter/foundation.dart';

enum Pantalla { carga, acceso, registro, provisional }

class Navegacion extends ChangeNotifier {
  Navegacion({Pantalla inicial = Pantalla.carga}) : _actual = inicial;

  Pantalla _actual;

  Pantalla get actual => _actual;

  void irA(Pantalla pantalla) {
    if (pantalla == _actual) {
      return;
    }
    _actual = pantalla;
    notifyListeners();
  }
}
