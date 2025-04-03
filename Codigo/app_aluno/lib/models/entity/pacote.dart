class Pacote {
  String? id;
  String _nome;
  String _valorMensal;
  String _numeroAcessos;

  Pacote({
    required String nome,
    required String valorMensal,
    required String numeroAcessos,
    this.id,
  })  : _nome = nome,
        _valorMensal = valorMensal,
        _numeroAcessos = numeroAcessos;

  String get nome => _nome;
  String get valorMensal => _valorMensal;
  String get numeroAcessos => _numeroAcessos;

  set nome(String nome) => _nome = nome;
  set valorMensal(String valorMensal) => _valorMensal = valorMensal;
  set numeroAcessos(String numeroAcessos) => _numeroAcessos = numeroAcessos;

  Map<String, dynamic> toMap() {
    return {
      'nome': _nome,
      'valorMensal': _valorMensal,
      'numeroAcessos': _numeroAcessos,
    };
  }

  static Pacote? fromMap(Map<String, dynamic>? map, String id) {
    if (map == null) {
      return null;
    }
    return Pacote(
      nome: map['nome'],
      valorMensal: map['valorMensal'],
      numeroAcessos: map['numeroAcessos'],
      id: id,
    );
  }

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'Pacote{id: $id, nome: $nome, valorMensal: $valorMensal, numeroAcessos: $numeroAcessos}';
  }
}
