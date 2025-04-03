

import 'package:SmartTrainer_Personal/models/entity/nivel_esforco.dart';

class FeedbackTreino {
  String? id;

  NivelEsforco _nivelEsforco;
  String _observacao;

  FeedbackTreino({
    required NivelEsforco nivelEsforco,
    required String observacao,
    this.id,
  })  : _nivelEsforco = nivelEsforco,
        _observacao = observacao;

  NivelEsforco get nivelEsforco => _nivelEsforco;
  String get observacao => _observacao;

  set nivelEsforco(NivelEsforco nivelEsforco) => _nivelEsforco = nivelEsforco;
  set observacao(String observacao) => _observacao = observacao;

  Map<String, dynamic> toMap() {
    return {
      'nivelEsforco': _nivelEsforco.value,
      'observacao': _observacao,
    };
  }

  factory FeedbackTreino.fromMap(Map<String, dynamic> map, String id) {
    return FeedbackTreino(
      nivelEsforco: NivelEsforco.values.firstWhere(
        (element) => element.value == map['nivelEsforco'],
      ),
      observacao: map['observacao'],
      id: id,
    );
  }
}
