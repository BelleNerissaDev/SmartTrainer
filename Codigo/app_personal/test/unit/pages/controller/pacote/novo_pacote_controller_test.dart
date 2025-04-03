import 'package:SmartTrainer_Personal/connections/repository/pacote_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/pages/controller/pacote/pacote_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'novo_pacote_controller_test.mocks.dart';

@GenerateMocks([PacoteRepository])
void main() {
  group('NovoPacoteController', () {
    late PacoteController controller;
    late MockPacoteRepository mockPacoteRepository;

    setUp(() {
      mockPacoteRepository = MockPacoteRepository();
      controller = PacoteController(pacoteRepository: mockPacoteRepository);
    });

    test('criarPacote should return true when successful', () async {
      const nome = 'Pacote Mensal';
      const valorMensal = '100,00';
      const numeroAcessos = '30';

      when(mockPacoteRepository.create(any)).thenAnswer((_) async => Pacote(
            id: '1',
            nome: nome,
            valorMensal: valorMensal,
            numeroAcessos: numeroAcessos,
          ));

      final result = await controller.criarPacote(
        nome: nome,
        valorMensal: valorMensal,
        numeroAcessos: numeroAcessos,
      );

      expect(result, true);
      verify(mockPacoteRepository.create(any)).called(1);
    });

    test('criarPacote should return false when an error occurs', () async {
      const nome = 'Pacote Mensal';
      const valorMensal = '100,00';
      const numeroAcessos = '30';

      when(mockPacoteRepository.create(any)).thenThrow(Exception());

      final result = await controller.criarPacote(
        nome: nome,
        valorMensal: valorMensal,
        numeroAcessos: numeroAcessos,
      );

      expect(result, false);
      verify(mockPacoteRepository.create(any)).called(1);
    });

    test('editarPacote should return true when successful', () async {
      const id = '123';
      const nome = 'Pacote Atualizado';
      const valorMensal = '150,00';
      const numeroAcessos = '50';

      when(mockPacoteRepository.update(any)).thenAnswer((_) async => Pacote(
            id: '1',
            nome: nome,
            valorMensal: valorMensal,
            numeroAcessos: numeroAcessos,
          ));

      final result = await controller.editarPacote(
        id: id,
        nome: nome,
        valorMensal: valorMensal,
        numeroAcessos: numeroAcessos,
      );

      expect(result, true);
      verify(mockPacoteRepository.update(any)).called(1);
    });

    test('editarPacote should return false when an error occurs', () async {
      const id = '123';
      const nome = 'Pacote Atualizado';
      const valorMensal = '150,00';
      const numeroAcessos = '50';

      when(mockPacoteRepository.update(any)).thenThrow(Exception());

      // Act
      final result = await controller.editarPacote(
        id: id,
        nome: nome,
        valorMensal: valorMensal,
        numeroAcessos: numeroAcessos,
      );

      // Assert
      expect(result, false);
      verify(mockPacoteRepository.update(any)).called(1);
    });

    test('visualizarPacotePorId should return a Pacote object when found',
        () async {
      const id = '123';
      final pacote = Pacote(
        id: id,
        nome: 'Pacote Mensal',
        valorMensal: '100,00',
        numeroAcessos: '30',
      );

      when(mockPacoteRepository.readById(id)).thenAnswer((_) async => pacote);

      final result = await controller.visualizarPacotePorId(id);

      expect(result, isNotNull);
      expect(result!.id, equals(id));
      expect(result.nome, equals('Pacote Mensal'));
      verify(mockPacoteRepository.readById(id)).called(1);
    });

    test('visualizarPacotePorId should return null when not found', () async {
      const id = '123';

      when(mockPacoteRepository.readById(id)).thenThrow(Exception());

      final result = await controller.visualizarPacotePorId(id);

      expect(result, isNull);
      verify(mockPacoteRepository.readById(id)).called(1);
    });
  });
}
