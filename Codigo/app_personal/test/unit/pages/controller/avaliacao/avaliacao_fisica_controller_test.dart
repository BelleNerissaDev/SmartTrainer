import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:SmartTrainer_Personal/pages/controller/avaliacao_fisica/avaliacao_fisica_controller.dart';
import 'package:SmartTrainer_Personal/connections/repository/avaliacao_fisica_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';

import 'avaliacao_fisica_controller_test.mocks.dart';

@GenerateMocks([AvaliacaoFisicaRepository, FirebaseStorage])
void main() {
  group('AvaliacaoController', () {
    late AvaliacaoController avaliacaoController;
    late MockAvaliacaoFisicaRepository mockAvaliacaoRepository;
    late MockFirebaseStorage mockFirebaseStorage;
    late Aluno aluno;


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

    setUp(() {
      mockAvaliacaoRepository = MockAvaliacaoFisicaRepository();
      mockFirebaseStorage = MockFirebaseStorage();
      avaliacaoController = AvaliacaoController(
          avaliacaoRepository: mockAvaliacaoRepository,
          storage: mockFirebaseStorage);
      aluno = Aluno(
        nome: 'John Doe',
        telefone: '123456789',
        email: 'john.doe@example.com',
        sexo: 'Male',
        status: StatusAlunoEnum.ATIVO,
        peso: 70.5,
        altura: 180,
        uid: 'uid',
        imagem: null,
        primeiroAcesso: true,
        id: '1',
        dataNascimento: DateTime.now(),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200.0',
          numeroAcessos: '50',
        ),
      );
    });

    test('salvarAvaliacao returns true when repository call is successful',
        () async {
      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.pendente,
        tipoAvaliacao: TipoAvaliacao.pdf,
      );

      when(mockAvaliacaoRepository.create(any))
          .thenAnswer((_) async => avaliacao);

      final result = await avaliacaoController.solicitarAvaliacaoOnline(aluno);

      expect(result, true);
      verify(mockAvaliacaoRepository.create(any)).called(1);
    });

    test(
        '''salvarAvaliacao returns false when repository call throws an exception''',
        () async {
      when(mockAvaliacaoRepository.create(any))
          .thenThrow(Exception('Failed to create'));

      final result = await avaliacaoController.solicitarAvaliacaoOnline(aluno);

      expect(result, false);
      verify(mockAvaliacaoRepository.create(any)).called(1);
    });
  });
}
