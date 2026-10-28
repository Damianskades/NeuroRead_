import 'package:cloud_firestore/cloud_firestore.dart';

DateTime fechaDe(Object? valor) => switch (valor) {
  Timestamp() => valor.toDate(),
  DateTime() => valor,
  _ => DateTime.fromMillisecondsSinceEpoch(0),
};

Timestamp marcaDe(DateTime fecha) => Timestamp.fromDate(fecha);

int? enteroDe(Object? valor) => (valor as num?)?.toInt();

double? decimalDe(Object? valor) => (valor as num?)?.toDouble();
