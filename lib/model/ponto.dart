import 'package:intl/intl.dart';

class Ponto {
  static const nomeTabela = 'ponto';
  static const campoId = '_id';
  static const campoLongitude = 'longitude';
  static const campoLatitude = 'latitude';
  static const campoHorario = 'horario';

  int? id;
  double longitude;
  double latitude;
  DateTime? horario;

  Ponto({
    this.id,
    required this.longitude,
    required this.latitude,
    required this.horario
  });

  String get dataFormatada {
    return DateFormat('dd/MM/yyyy').format(horario!);
  }

  Map<String, dynamic> toMap() => {
    campoId: id,
    campoLongitude: longitude,
    campoLatitude: latitude,
    campoHorario:
    horario == null ? null : DateFormat("yyyy-MM-dd").format(horario!),
  };

  factory Ponto.fromMap(Map<String, dynamic> map) => Ponto(
    id: map[campoId] is int ? map[campoId] : null,
    longitude: map[campoLongitude] is double ? map[campoLongitude] : 0,
    latitude: map[campoLatitude] is double ? map[campoLatitude] : 0,
    horario: map[campoHorario] is String
        ? DateFormat("yyyy-MM-dd").parse(map[campoHorario])
        : null,
  );
}