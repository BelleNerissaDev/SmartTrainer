import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RespostasParq respostasParq;
  late RespostasHistSaude respostasHistSaude;
  setUpAll(() {
    respostasParq = RespostasParq(respostas: {
      'testeParqQ1': 'Não',
      'testeParqQ2': 'Não',
      'testeParqQ3': 'Não',
      'testeParqQ4': 'Não',
      'testeParqQ5': 'Não',
      'testeParqQ6': 'Não',
      'testeParqQ7': 'Não',
    });

    // Mock das respostas para RespostasHistSaude
    respostasHistSaude = RespostasHistSaude(respostas: {
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
  group('Aluno', () {
    late Aluno aluno;

    setUp(() {
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
        dataNascimento: DateTime.now(),
        pacote:
            Pacote(nome: 'pacote 1', valorMensal: '200.0', numeroAcessos: '50'),
      );
    });
    test('addAvaliacaoFisica should add the provided AvaliacaoFisica', () {
      final avaliacaoFisica = AvaliacaoFisica(
        data: new DateTime(2024, 10, 10),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
      );

      aluno.addAvaliacaoFisica(avaliacaoFisica);

      expect(aluno.avaliacoesFisicas, contains(avaliacaoFisica));
    });

    test('addAnamnese should add the provided Anamnese', () {
      final aluno = Aluno(
          dataNascimento: DateTime(1990, 5, 20),
          nome: 'John Doe',
          telefone: '123456789',
          email: 'john.doe@example.com',
          sexo: 'Male',
          status: StatusAlunoEnum.ATIVO,
          peso: 70.5,
          altura: 180,
          uid: 'uid',
          imagem: null,
          primeiroAcesso: false,
          pacote:
              Pacote(nome: 'Teste', valorMensal: '20.00', numeroAcessos: '20'));
      final anamnese = Anamnese(
          nomeCompleto: aluno.nome,
          email: aluno.email,
          data: DateTime(2024, 10, 10),
          idade: 20,
          sexo: Sexo.masculino,
          telefone: aluno.telefone,
          status: StatusAnamneseEnum.REALIZADA,
          nomeContatoEmergencia: 'Jane Doe',
          telefoneContatoEmergencia: '987654321',
          respostasParq: respostasParq,
          respostasHistSaude: respostasHistSaude);

      aluno.addAnamnese(anamnese);

      expect(aluno.anamneses, contains(anamnese));
    });

    test('toMap should return a valid map representation of the Aluno object',
        () {
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
      expect(map['primeiroAcesso'], isTrue);
      expect(map['dataNascimento'], equals(aluno.dataNascimento));
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
        'dataNascimento': Timestamp.now(),
      };

      final aluno = Aluno.fromMap(
        map,
        '',
        Pacote(
          nome: 'pacote 1',
          valorMensal: '200.0',
          numeroAcessos: '50',
        ),
      );

      expect(aluno!.nome, equals('John Doe'));
      expect(aluno.telefone, equals('123456789'));
      expect(aluno.email, equals('john.doe@example.com'));
      expect(aluno.sexo, equals('Male'));
      expect(aluno.imagem, isNull);
      expect(aluno.status, equals(StatusAlunoEnum.ATIVO));
      expect(aluno.peso, equals(70.5));
      expect(aluno.altura, equals(180));
      expect(aluno.uid, equals('uid'));
    });

    test('fromMap should return null when the provided map is null', () {
      final aluno = Aluno.fromMap(
        null,
        '',
        Pacote(nome: 'pacote 1', valorMensal: '200.0', numeroAcessos: '50'),
      );

      expect(aluno, isNull);
    });

    test('setters should update the respective fields', () {
      aluno = Aluno(
        nome: '',
        telefone: '',
        email: '',
        sexo: '',
        status: StatusAlunoEnum.ATIVO,
        peso: 0,
        altura: 0,
        uid: '',
        imagem: null,
        primeiroAcesso: true,
        dataNascimento: DateTime.now(),
        pacote: Pacote(nome: '', valorMensal: '', numeroAcessos: ''),
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
      aluno.primeiroAcesso = false;
      aluno.dataNascimento = DateTime(2020, 10, 10);

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
      expect(aluno.primeiroAcesso, isFalse);
      expect(aluno.dataNascimento, equals(DateTime(2020, 10, 10)));
    });
  });
}
