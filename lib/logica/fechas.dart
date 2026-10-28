const _dias = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];

const _meses = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

String fechaLarga(DateTime fecha) =>
    '${_dias[fecha.weekday - 1]}, ${fecha.day} de ${_meses[fecha.month - 1]}';

String fechaCorta(DateTime fecha) =>
    '${fecha.day} de ${_meses[fecha.month - 1]}';

String plural(int n, String singular, String varios) =>
    '$n ${n == 1 ? singular : varios}';

DateTime soloDia(DateTime fecha) =>
    DateTime(fecha.year, fecha.month, fecha.day);

int racha(Iterable<DateTime> fechas, DateTime hoy) {
  final dias = fechas.map(soloDia).toSet();
  final hoyDia = soloDia(hoy);
  var dia = dias.contains(hoyDia)
      ? hoyDia
      : DateTime(hoyDia.year, hoyDia.month, hoyDia.day - 1);
  var cuenta = 0;
  while (dias.contains(dia)) {
    cuenta++;
    dia = DateTime(dia.year, dia.month, dia.day - 1);
  }
  return cuenta;
}
