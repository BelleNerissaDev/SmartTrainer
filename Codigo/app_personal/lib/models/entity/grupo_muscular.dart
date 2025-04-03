import 'package:SmartTrainer_Personal/utils/remove_accents.dart';

String grupoMuscularFormatName(String name) {
  return removeAccents(name)
      .replaceAll('_', ' ')
      .toLowerCase()
      .replaceAll(' ', '_');
}

class GrupoMuscular {
  final String nome;
  final String id;

  GrupoMuscular({
    required this.nome,
    required this.id,
  });

  GrupoMuscular.fromMap(Map<String, dynamic> map, [String? id])
      : nome = map['nome'] as String,
        id = id!;

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'id': id,
    };
  }
}
