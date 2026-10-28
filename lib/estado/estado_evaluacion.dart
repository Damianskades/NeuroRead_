import 'dart:math';

import '../contenido/textos.dart';
import '../logica/puntajes.dart';

class EstadoEvaluacion {
  TextoEvaluacion? textoActivo;
  DatosEvaluacion? datos;
  String tipo = 'inicial';
  bool guardada = false;
  Comparacion? comparacion;

  void nueva({required bool evaluacionInicialHecha, Random? azar}) {
    final texto = textoAleatorio(excluirId: textoActivo?.id, azar: azar);
    textoActivo = texto;
    datos = DatosEvaluacion.de(texto);
    guardada = false;
    comparacion = null;
    tipo = evaluacionInicialHecha ? 'clasificatoria' : 'inicial';
  }
}
