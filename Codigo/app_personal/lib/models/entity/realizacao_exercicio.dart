

import 'package:SmartTrainer_Personal/models/entity/nivel_esforco.dart';

class RealizacaoExercicio {
  String? id;

  double _novaCarga;
  NivelEsforco _nivelEsforco;
  String _idExercicio;

  RealizacaoExercicio({
    required double novaCarga,
    required NivelEsforco nivelEsforco,
    required String idExercicio,
    this.id,
  })  : _novaCarga = novaCarga,
        _nivelEsforco = nivelEsforco,
        _idExercicio = idExercicio;

  double get novaCarga => _novaCarga;
  NivelEsforco get nivelEsforco => _nivelEsforco;
  String get idExercicio => _idExercicio;

  set novaCarga(double novaCarga) => _novaCarga = novaCarga;
  set nivelEsforco(NivelEsforco nivelEsforco) => _nivelEsforco = nivelEsforco;
  set idExercicio(String idExercicio) => _idExercicio = idExercicio;

  Map<String, dynamic> toMap() {
    return {
      'novaCarga': _novaCarga,
      'nivelEsforco': _nivelEsforco.value,
      'idExercicio': _idExercicio,
    };
  }

  factory RealizacaoExercicio.fromMap(Map<String, dynamic> map, String id) {
    return RealizacaoExercicio(
      novaCarga: map['novaCarga'],
      nivelEsforco: NivelEsforco.values.firstWhere(
        (element) => element.value == map['nivelEsforco'],
      ),
      idExercicio: map['idExercicio'],
      id: id,
    );
  }
}
