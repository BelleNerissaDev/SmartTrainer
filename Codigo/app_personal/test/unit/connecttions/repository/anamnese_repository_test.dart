import 'package:SmartTrainer_Personal/connections/repository/anamnese_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnamneseRepository', () {
    late FakeFirebaseFirestore instance;
    late AnamneseRepository anamneseRepository;
    late Pacote pacote;

    setUp(() async {
      instance = FakeFirebaseFirestore();
      anamneseRepository = AnamneseRepository(
        firestore: instance,
      );
      pacote = Pacote(
        nome: 'pacote 1',
        valorMensal: '200',
        numeroAcessos: '30',
      );

      final document = await instance.collection('pacotes').add(pacote.toMap());
      pacote.id = document.id;
    });

    late RespostasParq mockRespostasParq;
    late RespostasHistSaude mockRespostasHistSaude;

    setUp(() {
      mockRespostasParq = RespostasParq(respostas: {
        'testeParqQ1': 'Não',
        'testeParqQ2': 'Não',
        'testeParqQ3': 'Não',
        'testeParqQ4': 'Não',
        'testeParqQ5': 'Não',
        'testeParqQ6': 'Não',
        'testeParqQ7': 'Não',
      });

      mockRespostasHistSaude = RespostasHistSaude(respostas: {
        'testeHistSaudeQ1': 'Fumo',
        'testeHistSaudeQ2': 'Não sei',
        'testeHistSaudeQ3': 'Não',
        'testeHistSaudeQ4': 'Não',
        'testeHistSaudeQ5': 'Não',
        'testeHistSaudeQ6': 'Não',
        'testeHistSaudeQ7': 'Não',
        'testeHistSaudeQ8': 'Menos que 1L',
        'testeHistSaudeQ9': 'Nenhum',
        'testeHistSaudeQ10': 'Nada',
      });
    });

    test('createAnamnese should return an Anamnese when successful', () async {
      final data = {
        'nome': 'John Doe',
        'telefone': '123456789',
        'email': 'john.doe@example.com',
        'sexo': 'Male',
        'imagem': null,
        'status': 'Ativo',
        'peso': 70.5,
        'altura': 180,
        'uid': 'uid',
        'primeiroAcesso': true,
        'dataNascimento': Timestamp.fromDate(DateTime(1990, 1, 1)),
        'pacoteId': pacote.id,
      };

      final document = await instance.collection('alunos').add(data);
      final alunoId = document.id;

      final anamnese = Anamnese(
        nomeCompleto: 'Teste Aluno',
        email: 'teste@aluno.com',
        data: DateTime.now(),
        idade: 20,
        sexo: Sexo.masculino,
        telefone: '(31) 99999-9999',
        status: StatusAnamneseEnum.REALIZADA,
        nomeContatoEmergencia: 'Contato Teste',
        telefoneContatoEmergencia: '(31) 99999-9999',
        respostasParq: mockRespostasParq,
        respostasHistSaude: mockRespostasHistSaude,
      );

      await anamneseRepository.createAnamnese(anamnese, alunoId);
      expect(anamnese.id, isNotNull);

      final snapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('anamneses')
          .doc(anamnese.id)
          .get();

      final createdAnamneseData = snapshot.data();
      final createdAnamnese =
          Anamnese.fromMap(createdAnamneseData!, snapshot.id);

      expect(anamnese.telefone, equals(createdAnamnese.telefone));
    });

    test(
        'getAllAnamneses should return all anamneses associated aluno data',
        () async {
      // Adiciona dados do aluno e da anamnese ao Firestore simulado
      final alunoData = {
        'nome': 'John Doe',
        'profileImage': 'image_url',
      };
      final alunoDocument = await instance.collection('alunos').add(alunoData);
      final alunoId = alunoDocument.id;

      final anamnese = Anamnese(
        nomeCompleto: 'Teste Aluno',
        email: 'teste@aluno.com',
        data: DateTime.now(),
        idade: 20,
        sexo: Sexo.masculino,
        telefone: '(31) 99999-9999',
        status: StatusAnamneseEnum.REALIZADA,
        nomeContatoEmergencia: 'Contato Teste',
        telefoneContatoEmergencia: '(31) 99999-9999',
        respostasParq: mockRespostasParq,
        respostasHistSaude: mockRespostasHistSaude,
      );

      await anamneseRepository.createAnamnese(anamnese, alunoId);

      final anamneses = await anamneseRepository.getAllAnamneses();

      expect(anamneses, isNotEmpty);
      expect(anamneses.first['alunoNome'], equals(alunoData['nome']));
    });

    test('updateAnamnese should update an existing anamnese', () async {
      // Cria e adiciona uma anamnese
      final anamnese = Anamnese(
        nomeCompleto: 'Teste Aluno',
        email: 'teste@aluno.com',
        data: DateTime.now(),
        idade: 20,
        sexo: Sexo.masculino,
        telefone: '(31) 99999-9999',
        status: StatusAnamneseEnum.REALIZADA,
        nomeContatoEmergencia: 'Contato Teste',
        telefoneContatoEmergencia: '(31) 99999-9999',
        respostasParq: mockRespostasParq,
        respostasHistSaude: mockRespostasHistSaude,
      );

      final alunoDocument = await instance.collection('alunos').add({
        'nome': 'John Doe',
      });
      final alunoId = alunoDocument.id;
      await anamneseRepository.createAnamnese(anamnese, alunoId);

      anamnese.nomeCompleto = 'Novo Nome';

      final updatedAnamnese =
          await anamneseRepository.updateAnamnese(anamnese, alunoId);

      expect(updatedAnamnese.nomeCompleto, equals('Novo Nome'));
    });

    test('readByAluno should return all anamneses for a given aluno', () async {
      // Cria e adiciona uma anamnese
      final anamnese = Anamnese(
        nomeCompleto: 'Teste Aluno',
        email: 'teste@aluno.com',
        data: DateTime.now(),
        idade: 20,
        sexo: Sexo.masculino,
        telefone: '(31) 99999-9999',
        status: StatusAnamneseEnum.REALIZADA,
        nomeContatoEmergencia: 'Contato Teste',
        telefoneContatoEmergencia: '(31) 99999-9999',
        respostasParq: mockRespostasParq,
        respostasHistSaude: mockRespostasHistSaude,
      );

      final alunoDocument = await instance.collection('alunos').add({
        'nome': 'John Doe',
      });
      final alunoId = alunoDocument.id;
      await anamneseRepository.createAnamnese(anamnese, alunoId);

      final anamneses = await anamneseRepository.readByAluno(alunoId);

      expect(anamneses, isNotEmpty);
      expect(anamneses.first.nomeCompleto, equals(anamnese.nomeCompleto));
    });
  });
}
