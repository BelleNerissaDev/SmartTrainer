import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:flutter/material.dart';

class AlunoProvider extends ChangeNotifier {
  Aluno? _aluno;
  Map<String, dynamic> ultimaAnamnesePersonalData = {};
  Map<String, dynamic> ultimaAnamneseParqData = {};
  Map<String, dynamic> ultimaAnamneseHistSaudeData = {};

  Aluno? get aluno => _aluno;

  void setAluno(Aluno novoAluno) {
    _aluno = novoAluno;
    notifyListeners();
  }

  void clearAluno() {
    _aluno = null;
    notifyListeners();
  }

  void updatePersonalData(Map<String, dynamic> data) {
    ultimaAnamnesePersonalData = data;
    notifyListeners();
  }

  void updateParqData(Map<String, dynamic> data) {
    ultimaAnamneseParqData = data;
    notifyListeners();
  }

  void updateHistSaudeData(Map<String, dynamic> data) {
    ultimaAnamneseHistSaudeData = data;
    notifyListeners();
  }

  void clearAnamneseData() {
    ultimaAnamnesePersonalData = {};
    ultimaAnamneseParqData = {};
    ultimaAnamneseHistSaudeData = {};
    notifyListeners();
  }

  void updateUltimaAnamnese(Anamnese data) {
    _aluno?.addAnamnese(data);
    notifyListeners();
  }
}
