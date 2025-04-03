import 'package:SmartTrainer/connections/repository/anamnese_repository.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
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
      // Mock das respostas para RespostasParq
      mockRespostasParq = RespostasParq(respostas: {
        'testeParqQ1': 'Não',
        'testeParqQ2': 'Não',
        'testeParqQ3': 'Não',
        'testeParqQ4': 'Não',
        'testeParqQ5': 'Não',
        'testeParqQ6': 'Não',
        'testeParqQ7': 'Não',
      });

      // Mock das respostas para RespostasHistSaude
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
    test('create should return an Anamnese when successful', () async {
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
      expect(anamnese.nomeCompleto, equals(createdAnamnese.nomeCompleto));
      expect(anamnese.email, equals(createdAnamnese.email));
      expect(anamnese.sexo, equals(createdAnamnese.sexo));
      expect(anamnese.data, equals(createdAnamnese.data));
      expect(anamnese.status, equals(createdAnamnese.status));
      expect(anamnese.idade, equals(createdAnamnese.idade));
      expect(anamnese.nomeContatoEmergencia,
          equals(createdAnamnese.nomeContatoEmergencia));
      expect(anamnese.telefoneContatoEmergencia,
          equals(createdAnamnese.telefoneContatoEmergencia));
      expect(anamnese.respostasParq, equals(createdAnamnese.respostasParq));
      expect(anamnese.respostasHistSaude,
          equals(createdAnamnese.respostasHistSaude));
    });

    test('getLastAnamnese should return the most recent anamnese', () async {
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
      final date = DateTime.now();
      final anamnesesData = [
        Anamnese(
          nomeCompleto: 'Teste Aluno',
          email: 'teste@aluno.com',
          data: date,
          idade: 20,
          sexo: Sexo.masculino,
          telefone: '(31) 99999-9999',
          status: StatusAnamneseEnum.REALIZADA,
          nomeContatoEmergencia: 'Contato Teste',
          telefoneContatoEmergencia: '(31) 99999-9999',
          respostasParq: mockRespostasParq,
          respostasHistSaude: mockRespostasHistSaude,
        ),
        Anamnese(
          nomeCompleto: 'Teste Aluno',
          email: 'teste@aluno.com',
          data: date.subtract(const Duration(days: 1)),
          idade: 20,
          sexo: Sexo.masculino,
          telefone: '(31) 99999-9999',
          status: StatusAnamneseEnum.REALIZADA,
          nomeContatoEmergencia: 'Contato Teste',
          telefoneContatoEmergencia: '(31) 99999-9999',
          respostasParq: mockRespostasParq,
          respostasHistSaude: mockRespostasHistSaude,
        ),
      ];

      for (final ultimaAnamneseData in anamnesesData) {
        await instance
            .collection('alunos')
            .doc(alunoId)
            .collection('anamneses')
            .add(ultimaAnamneseData.toMap());
      }

      final result = await anamneseRepository.getLastAnamnese(alunoId);

      expect(result, isNotNull);
      expect(result?.data, date);
    });
  });
}
