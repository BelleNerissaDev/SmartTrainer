import 'dart:io';
import 'package:SmartTrainer/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';

import 'package:SmartTrainer/pages/controller/editar_foto_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

import 'editar_foto_controller_test.mocks.dart';

@GenerateMocks([
  AlunoRepository,
  SharedPreferences,
])
void main() {
  group('Editar Foto Controller', () {
    late EditarFotoController controller;
    late MockAlunoRepository mockAlunoRepository;
    late MockFirebaseStorage mockFirebaseStorage;
    late MockSharedPreferences mockSharedPreferences;
    late Aluno aluno;

    setUp(() {
      mockAlunoRepository = MockAlunoRepository();
      mockFirebaseStorage = MockFirebaseStorage();
      mockSharedPreferences = MockSharedPreferences();

      controller = EditarFotoController(
        alunoRepository: mockAlunoRepository,
        storage: mockFirebaseStorage,
        prefs: Future.value(mockSharedPreferences),
      );

      aluno = Aluno(
        id: '123',
        imagem: null,
        primeiroAcesso: true,
        nome: 'John Doe',
        telefone: '123456789',
        email: 'test@example',
        sexo: 'Male',
        status: StatusAlunoEnum.ATIVO,
        peso: 70.5,
        altura: 180,
        uid: '12345',
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      );
    });

    test('editarFoto uploads a new photo and updates the aluno', () async {
      final file = File('path/to/photo');
      final ref = mockFirebaseStorage.ref().child('alunos').child(aluno.id!);
      final uploadTask = ref.putFile(file);

      final taskSnapshot = await uploadTask;

      final newImageUrl = await taskSnapshot.ref.getDownloadURL();

      when(mockSharedPreferences.getString('userId')).thenReturn('123');
      when(mockAlunoRepository.readById('123')).thenAnswer((_) async => aluno);
      when(mockAlunoRepository.update(aluno)).thenAnswer((_) async => aluno);

      final updatedAluno = await controller.editarFoto(file);

      expect(updatedAluno.imagem, newImageUrl);
      verify(mockAlunoRepository.update(updatedAluno)).called(1);
    });

    test('editarFoto uploads a new photo and updates the aluno with old file',
        () async {
   
      final oldFile = File('path/to/old_photo');
      final oldRef = mockFirebaseStorage.ref().child('alunos').child(aluno.id!);
      final oldUploadTask = oldRef.putFile(oldFile);
      final oldTaskSnapshot = await oldUploadTask;
      final oldImageUrl = await oldTaskSnapshot.ref.getDownloadURL();

      aluno.imagem = oldImageUrl;

      final file = File('path/to/photo');
      final ref = mockFirebaseStorage.ref().child('alunos').child(aluno.id!);
      final uploadTask = ref.putFile(file);
      final taskSnapshot = await uploadTask;
      final newImageUrl = await taskSnapshot.ref.getDownloadURL();

      when(mockSharedPreferences.getString('userId')).thenReturn('123');
      when(mockAlunoRepository.readById('123')).thenAnswer((_) async => aluno);
      when(mockAlunoRepository.update(aluno)).thenAnswer((_) async => aluno);

      final updatedAluno = await controller.editarFoto(file);

      expect(updatedAluno.imagem, newImageUrl);
      verify(mockAlunoRepository.update(updatedAluno)).called(1);
    });
    test('removerFoto removes the photo and updates the aluno', () async {
      
      final oldFile = File('path/to/old_photo');
      final oldRef = mockFirebaseStorage.ref().child('alunos').child(aluno.id!);
      final oldUploadTask = oldRef.putFile(oldFile);
      final oldTaskSnapshot = await oldUploadTask;
      final oldImageUrl = await oldTaskSnapshot.ref.getDownloadURL();

      aluno.imagem = oldImageUrl;

      when(mockSharedPreferences.getString('userId')).thenReturn('123');
      when(mockAlunoRepository.readById('123')).thenAnswer((_) async => aluno);
      when(mockAlunoRepository.update(aluno)).thenAnswer((_) async => aluno);

      await controller.removerFoto();

      expect(aluno.imagem, isNull);
      verify(mockAlunoRepository.update(aluno)).called(1);
    });

    test('removerFoto does nothing if there is no photo', () async {
      

      when(mockSharedPreferences.getString('userId')).thenReturn('123');
      when(mockAlunoRepository.readById('123')).thenAnswer((_) async => aluno);
      when(mockAlunoRepository.update(aluno)).thenAnswer((_) async => aluno);

      await controller.removerFoto();

      expect(aluno.imagem, isNull);
      verifyNever(mockAlunoRepository.update(aluno));
    });
  });
}
