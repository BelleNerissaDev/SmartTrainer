import 'package:SmartTrainer/connections/repository/anamnese_repository.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:SmartTrainer/pages/controller/anamnese_controller.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnamneseController', () {
    late FakeFirebaseFirestore instance;
    late AnamneseRepository anamneseRepository;
    late AnamneseController anamneseController;

    setUp(() {
      instance = FakeFirebaseFirestore();
      anamneseRepository = AnamneseRepository(firestore: instance);
      anamneseController =
          AnamneseController(anamneseRepository: anamneseRepository);
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

    test('create should return true when anamnese is successfully created',
        () async {
      final alunoData = {
        'nome': 'John Doe',
        'telefone': '123456789',
        'email': 'john.doe@example.com',
        'sexo': 'Male',
        'imagem': null,
        'status': 'Ativo',
        'peso': 70.5,
        'altura': 180,
        'uid': 'uid',
        'primeiroAcesso': true
      };

      final alunoDoc = await instance.collection('alunos').add(alunoData);
      final alunoId = alunoDoc.id;

      final result = await anamneseController.criarAnamnese(
        idAluno: alunoId,
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

      expect(result, isTrue);
    });

    test('carregarAnamnese should return the most recent anamnese', () async {
      final alunoData = {
        'nome': 'John Doe',
        'telefone': '123456789',
        'email': 'john.doe@example.com',
        'sexo': 'Male',
        'imagem': null,
        'status': 'Ativo',
        'peso': 70.5,
        'altura': 180,
        'uid': 'uid',
        'primeiroAcesso': true
      };

      final alunoDoc = await instance.collection('alunos').add(alunoData);
      final alunoId = alunoDoc.id;
      final date = DateTime.now();

      final anamnesesData = [
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
      ];

      for (final anamnese in anamnesesData) {
        await instance
            .collection('alunos')
            .doc(alunoId)
            .collection('anamneses')
            .add(anamnese.toMap());
      }

      final result = await anamneseController.carregarAnamnese(alunoId);

      expect(result, isNotNull);
      expect(result?.data, equals(date));
    });
  });
}
