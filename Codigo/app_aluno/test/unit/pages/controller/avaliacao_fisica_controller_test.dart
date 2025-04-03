import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:SmartTrainer/pages/controller/avaliacao_fisica_controller.dart';
import 'package:SmartTrainer/connections/repository/avaliacao_fisica_repository.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';

import 'avaliacao_fisica_controller_test.mocks.dart';

@GenerateMocks([AvaliacaoFisicaRepository])
void main() {
  group('AvaliacaoFisicaController', () {
    late AvaliacaoFisicaController controller;
    late MockAvaliacaoFisicaRepository mockRepository;
    late AvaliacaoFisica avaliacaoFisica;

    setUp(() {
      mockRepository = MockAvaliacaoFisicaRepository();
      controller =
          AvaliacaoFisicaController(avaliacaoRepository: mockRepository);
      avaliacaoFisica = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.pendente,
        tipoAvaliacao: TipoAvaliacao.online,
      );
    });

    test('cadastrarAvaliacaoOnline returns true when successful', () async {
      when(mockRepository.update(any)).thenAnswer((_) async => avaliacaoFisica);

      final result = await controller.cadastrarAvaliacaoOnline(
        avaliacaoFisica: avaliacaoFisica,
        altura: 180,
        peso: 75.0,
        pescoco: 40.0,
        cintura: 80.0,
        quadril: 90.0,
      );

      expect(result, true);
      expect(avaliacaoFisica.altura, 180);
      expect(avaliacaoFisica.peso, 75.0);
      expect(avaliacaoFisica.medidaPescoco, 40.0);
      expect(avaliacaoFisica.medidaCintura, 80.0);
      expect(avaliacaoFisica.medidaQuadril, 90.0);
      expect(avaliacaoFisica.status, StatusAvaliacao.realizada);
      verify(mockRepository.update(avaliacaoFisica)).called(1);
    });

    test('cadastrarAvaliacaoOnline returns false when an exception is thrown',
        () async {
      when(mockRepository.update(any)).thenThrow(Exception());

      final result = await controller.cadastrarAvaliacaoOnline(
        avaliacaoFisica: avaliacaoFisica,
        altura: 180,
        peso: 75.0,
        pescoco: 40.0,
        cintura: 80.0,
        quadril: 90.0,
      );

      expect(result, false);
      verify(mockRepository.update(avaliacaoFisica)).called(1);
    });
  });
}
