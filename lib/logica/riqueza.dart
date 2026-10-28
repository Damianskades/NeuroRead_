import '../contenido/palabras_ricas.dart';
import 'normalizado.dart';

final _palabra = RegExp('[a-z0-9]+');

List<String> _palabras(String texto) => _palabra
    .allMatches(sinTildes(texto))
    .map((coincidencia) => coincidencia.group(0)!)
    .toList();

final List<String> _ricas = [
  for (final palabra in palabrasRicas) _palabras(palabra).join(' '),
];

int contarRiqueza(String texto) {
  final tokens = _palabras(texto);
  final unicas = tokens.toSet();
  final frase = ' ${tokens.join(' ')} ';
  var total = 0;
  for (final rica in _ricas) {
    if (rica.contains(' ')) {
      if (frase.contains(' $rica ')) {
        total++;
      }
    } else if (unicas.contains(rica)) {
      total++;
    }
  }
  return total;
}

String nivelRiqueza(int riqueza) {
  if (riqueza == 0) {
    return '--';
  }
  if (riqueza <= 2) {
    return 'Básica';
  }
  if (riqueza <= 5) {
    return 'Media';
  }
  return 'Alta';
}
