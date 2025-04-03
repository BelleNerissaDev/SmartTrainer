import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/anamnese_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/pages/controller/anamnese/anamnese_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnamneseController', () {
    late FakeFirebaseFirestore instance;
    late AlunoRepository alunoRepository;
    late AnamneseRepository anamneseRepository;
    late AnamneseController anamneseController;

    setUp(() {
      instance = FakeFirebaseFirestore();
      alunoRepository = AlunoRepository(firestore: instance);
      anamneseRepository = AnamneseRepository(firestore: instance);
      anamneseController = AnamneseController(
        anamneseRepository: anamneseRepository,
        alunoRepository: alunoRepository,
      );
    });

    setUpAll(() {
      dotenv.testLoad(mergeWith: {
        'AMQP_HOST': 'mocked_host',
        'AMQP_PORT': '1234',
        'AMQP_VIRTUAL_HOST': 'mocked_virtual_host',
        'AMQP_USER': 'mocked_user',
        'AMQP_PASSWORD': 'mocked_password',
        'AMQP_CONNECTION_NAME': 'connection_name_test',
        'AMQP_MAX_CONNECTION_ATTEMPTS': '1',
      });
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

    test('editarAnamense should return true on successful edit', () async {
      // Mock para o aluno
      final alunoData = {
        'nome': 'Test Aluno',
        'email': 'test@aluno.com',
        'telefone': '(31) 99999-9999',
        'sexo': 'Male',
      };
      final alunoDoc = await instance.collection('alunos').add(alunoData);
      final alunoId = alunoDoc.id;

      // Mock para a anamnese
      final anamnese = Anamnese(
        id: 'anamnese_id',
        nomeCompleto: 'Test Aluno',
        email: 'test@aluno.com',
        data: DateTime.now(),
        idade: 25,
        sexo: Sexo.masculino,
        telefone: '(31) 99999-9999',
        status: StatusAnamneseEnum.REALIZADA,
        nomeContatoEmergencia: 'Contato Emergencia',
        telefoneContatoEmergencia: '(31) 99999-8888',
        respostasParq: mockRespostasParq,
        respostasHistSaude: mockRespostasHistSaude,
      );

      await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('anamneses')
          .doc(anamnese.id)
          .set(anamnese.toMap());

      final result = await anamneseController.editarAnamense(
        id: anamnese.id!,
        idAluno: alunoId,
        nomeCompleto: anamnese.nomeCompleto!,
        email: anamnese.email!,
        data: anamnese.data,
        idade: anamnese.idade!,
        sexo: anamnese.sexo!,
        telefone: anamnese.telefone!,
        status: StatusAnamneseEnum.REALIZADA,
        nomeContatoEmergencia: anamnese.nomeContatoEmergencia!,
        telefoneContatoEmergencia: anamnese.telefoneContatoEmergencia!,
        respostasParq: anamnese.respostasParq!,
        respostasHistSaude: anamnese.respostasHistSaude!,
      );

      expect(result, isTrue);
    });

    test('solicitarAnamnese should return true on successful request',
        () async {
      // Mock para o aluno
      final alunoData = {
        'nome': 'Test Aluno',
        'email': 'test@aluno.com',
        'telefone': '(31) 99999-9999',
        'sexo': Sexo.masculino.toString(),
        'primeiroAcesso': true,
        'imagem': null,
        'status': 'Ativo',
        'uid': 'uid_teste',
        'dataNascimento': Timestamp.fromDate(DateTime(2000, 1, 1)),
        'pacoteId': 'pacoteId_teste',
      };
      final alunoDoc = await instance.collection('alunos').add(alunoData);
      final alunoId = alunoDoc.id;
      expect(alunoDoc.id, isNotNull);

      // Instanciando o aluno com os dados e o id gerado
      final aluno = Aluno(
        id: alunoId,
        nome: alunoData['nome']! as String,
        telefone: alunoData['telefone']! as String,
        email: alunoData['email']! as String,
        sexo: alunoData['sexo']! as String,
        status: StatusAlunoEnum.ATIVO,
        uid: alunoData['uid']! as String,
        primeiroAcesso: alunoData['primeiroAcesso']! as bool,
        dataNascimento: (alunoData['dataNascimento']! as Timestamp).toDate(),
        pacote: Pacote(
            id: alunoData['pacoteId']! as String,
            nome: 'Pacote Teste',
            valorMensal: '100.0',
            numeroAcessos: '10'),
      );

      // Testando o método solicitarAnamnese
      await anamneseController.solicitarAnamnese(aluno);

      final snapshot = await instance
          .collection('alunos')
          .doc(alunoId)
          .collection('anamneses')
          .orderBy('data', descending: true)
          .limit(1)
          .get();

      expect(snapshot.docs.length, 1);
    });
  });
}
