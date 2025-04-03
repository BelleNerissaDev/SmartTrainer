import 'package:SmartTrainer/models/entity/nivel_esforco.dart';

class Feedback {
  String? id;

  NivelEsforco _nivelEsforco;
  String _observacao;

  Feedback({
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

  factory Feedback.fromMap(Map<String, dynamic> map, String id) {
    return Feedback(
      nivelEsforco: NivelEsforco.values.firstWhere(
        (element) => element.value == map['nivelEsforco'],
      ),
      observacao: map['observacao'],
      id: id,
    );
  }
}
