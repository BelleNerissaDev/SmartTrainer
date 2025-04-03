import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Aluno', () {
    test('addAvaliacaoFisica should add the provided AvaliacaoFisica', () {
      final aluno = Aluno(
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
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      );
      final avaliacaoFisica = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.online,
      );

      aluno.addAvaliacaoFisica(avaliacaoFisica);

      expect(aluno.avaliacoesFisicas, contains(avaliacaoFisica));
    });

    // test('addAnamnese should add the provided Anamnese', () {
    //   final aluno = Aluno(
    //     nome: 'John Doe',
    //     telefone: '123456789',
    //     email: 'john.doe@example.com',
    //     sexo: 'Male',
    //     status: StatusAlunoEnum.ATIVO,
    //     peso: 70.5,
    //     altura: 180,
    //     uid: 'uid',
    //     imagem: null,
    //     primeiroAcesso: true,
    //   );
    //   final anamnese = Anamnese(/* provide the necessary arguments */);

    //   aluno.addAnamnese(anamnese);

    //   expect(aluno.anamneses, contains(anamnese));
    // });

    test('toMap should return a valid map representation of the Aluno object',
        () {
      final aluno = Aluno(
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
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      );

      final map = aluno.toMap();

      expect(map['nome'], equals('John Doe'));
      expect(map['telefone'], equals('123456789'));
      expect(map['email'], equals('john.doe@example.com'));
      expect(map['sexo'], equals('Male'));
      expect(map['imagem'], isNull);
      expect(map['status'], equals(StatusAlunoEnum.ATIVO.toString()));
      expect(map['peso'], equals(70.5));
      expect(map['altura'], equals(180));
      expect(map['uid'], equals('uid'));
    });

    test('fromMap should return a valid Aluno object from a map representation',
        () {
      final map = {
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
      };

      final aluno = Aluno.fromMap(
          map,
          'id',
          Pacote(
            nome: 'nome',
            valorMensal: '200',
            numeroAcessos: '20',
          ));

      expect(aluno!.nome, equals('John Doe'));
      expect(aluno.telefone, equals('123456789'));
      expect(aluno.email, equals('john.doe@example.com'));
      expect(aluno.sexo, equals('Male'));
      expect(aluno.imagem, isNull);
      expect(aluno.status, equals(StatusAlunoEnum.ATIVO));
      expect(aluno.peso, equals(70.5));
      expect(aluno.altura, equals(180));
      expect(aluno.uid, equals('uid'));
      expect(aluno.primeiroAcesso, isTrue);
      expect(aluno.dataNascimento, DateTime(1990, 1, 1));
    });

    test('fromMap should return null when the provided map is null', () {
      final aluno = Aluno.fromMap(
        null,
        '',
        Pacote(
          nome: 'nome',
          valorMensal: 'valorMensal',
          numeroAcessos: 'numeroAcessos',
        ),
      );

      expect(aluno, isNull);
    });

    test('setters should update the respective fields', () {
      final aluno = Aluno(
        nome: '',
        telefone: '',
        email: '',
        sexo: '',
        status: StatusAlunoEnum.ATIVO,
        peso: 0,
        altura: 0,
        uid: '',
        imagem: null,
        primeiroAcesso: false,
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      );

      aluno.nome = 'Jane Doe';
      aluno.telefone = '987654321';
      aluno.email = 'john.doe@example.com';
      aluno.sexo = 'Male';
      aluno.imagem = null;
      aluno.status = StatusAlunoEnum.BLOQUEADO;
      aluno.peso = 60.5;
      aluno.altura = 170;
      aluno.uid = 'new_uid';
      aluno.id = 'new_id';
      aluno.primeiroAcesso = true;

      expect(aluno.nome, equals('Jane Doe'));
      expect(aluno.telefone, equals('987654321'));
      expect(aluno.email, equals('john.doe@example.com'));
      expect(aluno.sexo, equals('Male'));
      expect(aluno.imagem, isNull);
      expect(aluno.status, equals(StatusAlunoEnum.BLOQUEADO));
      expect(aluno.peso, equals(60.5));
      expect(aluno.altura, equals(170));
      expect(aluno.uid, equals('new_uid'));
      expect(aluno.id, equals('new_id'));
      expect(aluno.primeiroAcesso, isTrue);
      expect(aluno.dataNascimento, DateTime(1990, 1, 1));
    });
  });
}
