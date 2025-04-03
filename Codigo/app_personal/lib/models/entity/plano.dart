import 'package:SmartTrainer_Personal/models/entity/treino.dart';

class PlanoTreino {
  String? id;

  String _nome;
  String _status;
  List<Treino> _treinos;

  PlanoTreino({
    required String nome,
    required String status,
    List<Treino>? treinos,
    this.id,
  })  : _nome = nome,
        _status = status,
        _treinos = treinos ?? [];

  String get nome => _nome;
  String get status => _status;
  List<Treino> get treinos => _treinos;

  set nome(String nome) => _nome = nome;
  set status(String status) => _status = status;

  Map<String, dynamic> toMap() {
    return {
      'nome': _nome,
      'status': _status,
    };
  }

  factory PlanoTreino.fromMap(
      Map<String, dynamic> map, String id, List<Treino> treinos) {
    return PlanoTreino(
      nome: map['nome'],
      status: map['status'],
      treinos: treinos,
      id: id,
    );
  }
}
