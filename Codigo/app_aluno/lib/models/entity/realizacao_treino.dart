import 'package:SmartTrainer/models/entity/feedback.dart';
import 'package:SmartTrainer/models/entity/realizacao_exercicio.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RealizacaoTreino {
  String? id;

  DateTime _data;
  Treino _treino;
  int _tempo;
  List<RealizacaoExercicio> _realizacaoExercicios;

  Feedback? _feedback;

  RealizacaoTreino({
    required DateTime data,
    required Treino treino,
    required int tempo,
    List<RealizacaoExercicio> realizacaoExercicios = const [],
    this.id,
    Feedback? feedback,
  })  : _data = data,
        _treino = treino,
        _tempo = tempo,
        _realizacaoExercicios = realizacaoExercicios,
        _feedback = feedback;

  DateTime get data => _data;
  Treino get treino => _treino;
  int get tempo => _tempo;
  List<RealizacaoExercicio> get realizacaoExercicios => _realizacaoExercicios;
  Feedback? get feedback => _feedback;

  set data(DateTime data) => _data = data;
  set treino(Treino treino) => _treino = treino;
  set tempo(int tempo) => _tempo = tempo;
  set feedback(Feedback? feedback) => _feedback = feedback;

  Map<String, dynamic> toMap() {
    return {
      'data': _data,
      'treinoId': _treino.id!,
      'tempo': _tempo,
    };
  }

  factory RealizacaoTreino.fromMap(
    Map<String, dynamic> map,
    String id,
    List<RealizacaoExercicio> realizacaoExercicios,
    Feedback? feedback,
    Treino treino,
  ) {
    return RealizacaoTreino(
      data: (map['data'] as Timestamp).toDate(),
      treino: treino,
      tempo: map['tempo'],
      id: id,
      realizacaoExercicios: realizacaoExercicios,
      feedback: feedback,
    );
  }
}
