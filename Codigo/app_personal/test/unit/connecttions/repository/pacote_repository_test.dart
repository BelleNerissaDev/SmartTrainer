import 'package:SmartTrainer_Personal/connections/repository/pacote_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PacoteRepository', () {
    late FakeFirebaseFirestore instance;
    late PacoteRepository pacoteRepository;

    setUp(() {
      instance = FakeFirebaseFirestore();
      pacoteRepository = PacoteRepository(
        firestore: instance,
      );
    });

    test('create should add a new pacote to the collection', () async {
      final pacote =
          Pacote(nome: 'Pacote A', valorMensal: '100,00', numeroAcessos: '30');

      await pacoteRepository.create(pacote);

      expect(pacote.id, isNotNull);

      final snapshot =
          await instance.collection('pacotes').doc(pacote.id).get();
      final createdPackageData = snapshot.data();

      final createdPacote = Pacote.fromMap(createdPackageData!, pacote.id!);

      expect(pacote.nome, equals(createdPacote!.nome));
      expect(pacote.valorMensal, equals(createdPacote.valorMensal));
      expect(pacote.numeroAcessos, equals(createdPacote.numeroAcessos));
    });

    test('readAll should return all pacotes from the collection', () async {
      final pacote1 =
          Pacote(nome: 'Pacote 1', valorMensal: '100,00', numeroAcessos: '10');
      final pacote2 =
          Pacote(nome: 'Pacote 2', valorMensal: '200,00', numeroAcessos: '20');

      await pacoteRepository.create(pacote1);
      await pacoteRepository.create(pacote2);

      final pacotes = await pacoteRepository.readAll();

      expect(pacotes.length, equals(2));
      expect(pacotes[0].nome, equals('Pacote 1'));
      expect(pacotes[1].nome, equals('Pacote 2'));
    });

    test('readById should return the correct pacote', () async {
      final pacote = Pacote(
          nome: 'Pacote Teste', valorMensal: '150,00', numeroAcessos: '15');
      await pacoteRepository.create(pacote);

      final pacoteFromDb = await pacoteRepository.readById(pacote.id!);

      expect(pacoteFromDb.id, equals(pacote.id));
      expect(pacoteFromDb.nome, equals('Pacote Teste'));
      expect(pacoteFromDb.valorMensal, equals('150,00'));
      expect(pacoteFromDb.numeroAcessos, equals('15'));
    });

    test('update should modify the pacote data', () async {
      final pacote = Pacote(
          nome: 'Pacote Atualizar', valorMensal: '100,00', numeroAcessos: '10');
      await pacoteRepository.create(pacote);

      pacote.nome = 'Pacote Atualizado';
      pacote.valorMensal = '120,00';
      await pacoteRepository.update(pacote);

      final pacoteUpdated = await pacoteRepository.readById(pacote.id!);

      expect(pacoteUpdated.nome, equals('Pacote Atualizado'));
      expect(pacoteUpdated.valorMensal, equals('120,00'));
      expect(pacoteUpdated.numeroAcessos, equals('10'));
    });
  });
}
