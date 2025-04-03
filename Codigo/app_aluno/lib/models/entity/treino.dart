import 'package:SmartTrainer/models/entity/exercicio.dart';

class Treino {
  String? id;

  String _nome;
  List<Exercicio> _exercicios;

  Treino({
    required String nome,
    List<Exercicio>? exercicios,
    this.id,
  })  : _nome = nome,
        _exercicios = exercicios ?? [];

  String get nome => _nome;
  List<Exercicio> get exercicios => _exercicios;

  set nome(String nome) => _nome = nome;

  Map<String, dynamic> toMap() {
    return {
      'nome': _nome,
    };
  }

  factory Treino.fromMap(
      Map<String, dynamic> map, String id, List<Exercicio> exercicios) {
    return Treino(
      nome: map['nome'],
      exercicios: exercicios,
      id: id,
    );
  }
}
