import 'dart:io';

import 'package:SmartTrainer/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditarFotoController {
  final AlunoRepository _alunoRepository;
  final FirebaseStorage _storage;
  final Future<SharedPreferences> _prefs;

  EditarFotoController({
    AlunoRepository? alunoRepository,
    FirebaseStorage? storage,
    Future<SharedPreferences>? prefs,
  })  : _alunoRepository = alunoRepository ?? AlunoRepository(),
        _storage = storage ?? FirebaseStorage.instance,
        _prefs = prefs ?? SharedPreferences.getInstance();

  Future<Aluno> editarFoto(File foto) async {
    final prefs = await _prefs;
    final id = prefs.getString('userId');
    final aluno = await _alunoRepository.readById(id!);

    final ref = _storage.ref().child('alunos').child(aluno.id!);

    if (aluno.imagem != null) {
      await _storage.refFromURL(aluno.imagem!).delete();
    }

    final uploadTask = ref.putFile(foto);

    final taskSnapshot = await uploadTask;

    final downloadURL = await taskSnapshot.ref.getDownloadURL();

    aluno.imagem = downloadURL;

    await _alunoRepository.update(aluno);

    return aluno;
  }

  Future<Aluno> removerFoto() async {
    final prefs = await _prefs;
    final id = prefs.getString('userId');
    final aluno = await _alunoRepository.readById(id!);

    if (aluno.imagem != null) {
      await _storage.refFromURL(aluno.imagem!).delete();
      aluno.imagem = null;

      await _alunoRepository.update(aluno);
    }

    return aluno;
  }
}
