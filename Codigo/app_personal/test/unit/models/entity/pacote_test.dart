import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';

void main() {
  group('Pacote', () {
    test('toMap should return a valid map representation of the Pacote object',
        () {
      final pacote = Pacote(
        nome: 'Pacote Mensal',
        valorMensal: '100,00',
        numeroAcessos: '30',
      );

      final map = pacote.toMap();

      expect(map['nome'], equals('Pacote Mensal'));
      expect(map['valorMensal'], equals('100,00'));
      expect(map['numeroAcessos'], equals('30'));
    });

    test(
        'fromMap should return a valid Pacote object from a map representation',
        () {
      final map = {
        'nome': 'Pacote Semestral',
        'valorMensal': '500,00',
        'numeroAcessos': '100',
      };

      final pacote = Pacote.fromMap(map, 'some_id');

      expect(pacote!.nome, equals('Pacote Semestral'));
      expect(pacote.valorMensal, equals('500,00'));
      expect(pacote.numeroAcessos, equals('100'));
      expect(pacote.id, equals('some_id'));
    });

    test('fromMap should return null when the provided map is null', () {
      final pacote = Pacote.fromMap(null, 'some_id');

      expect(pacote, isNull);
    });

    test('setters should update the respective fields', () {
      final pacote = Pacote(
        nome: 'Pacote Anual',
        valorMensal: '1200,00',
        numeroAcessos: '300',
      );

      pacote.nome = 'Pacote Atualizado';
      pacote.valorMensal = '1500,00';
      pacote.numeroAcessos = '350';

      expect(pacote.nome, equals('Pacote Atualizado'));
      expect(pacote.valorMensal, equals('1500,00'));
      expect(pacote.numeroAcessos, equals('350'));
    });

    test('should create a valid Pacote object and test the getters', () {
      final pacote = Pacote(
        nome: 'Pacote Mensal',
        valorMensal: '100,00',
        numeroAcessos: '30',
      );

      expect(pacote.nome, equals('Pacote Mensal'));
      expect(pacote.valorMensal, equals('100,00'));
      expect(pacote.numeroAcessos, equals('30'));
    });

    test(
        // ignore: lines_longer_than_80_chars
        'toString should return a valid string representation of the Pacote object',
        () {
      final pacote = Pacote(
        nome: 'Pacote Anual',
        valorMensal: '1200,00',
        numeroAcessos: '300',
        id: '123',
      );

      expect(
        pacote.toString(),
        equals('Pacote Anual - R\$ 1200,00, 300 acessos'),
      );
    });
  });
}
