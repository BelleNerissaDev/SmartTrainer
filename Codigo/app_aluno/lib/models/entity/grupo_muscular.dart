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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GrupoMuscular && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
