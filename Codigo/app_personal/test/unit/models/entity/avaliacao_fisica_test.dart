import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';

void main() {
  group('AvaliacaoFisica', () {
    late Aluno aluno;

    setUpAll(() {
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
    test('should create an instance of AvaliacaoFisica', () {
      final avaliacao = AvaliacaoFisica(
        id: '1',
        aluno: aluno,
        data: DateTime(2023, 10, 1),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
        peso: 70.5,
        altura: 175,
        idade: 25,
        imc: 23.0,
        percentualGordura: 15.0,
        relacaoCinturaQuadril: 0.85,
        pesoGordura: 10.5,
        medidaCintura: 80.0,
        medidaQuadril: 94.0,
        medidaPescoco: 40.0,
        linkArquivo: 'http://example.com/file.pdf',
      );

      expect(avaliacao.id, '1');
      expect(avaliacao.aluno?.nome, 'John Doe');
      expect(avaliacao.data, DateTime(2023, 10, 1));
      expect(avaliacao.status, StatusAvaliacao.realizada);
      expect(avaliacao.tipoAvaliacao, TipoAvaliacao.pdf);
      expect(avaliacao.peso, 70.5);
      expect(avaliacao.altura, 175);
      expect(avaliacao.idade, 25);
      expect(avaliacao.imc, 23.0);
      expect(avaliacao.percentualGordura, 15.0);
      expect(avaliacao.relacaoCinturaQuadril, 0.85);
      expect(avaliacao.pesoGordura, 10.5);
      expect(avaliacao.medidaCintura, 80.0);
      expect(avaliacao.medidaQuadril, 94.0);
      expect(avaliacao.medidaPescoco, 40.0);
      expect(avaliacao.linkArquivo, 'http://example.com/file.pdf');
    });

    test('should convert AvaliacaoFisica to map', () {
      final avaliacao = AvaliacaoFisica(
        id: '1',
        aluno: aluno,
        data: DateTime(2023, 10, 1),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
        peso: 70.5,
        altura: 175,
        idade: 25,
        imc: 23.0,
        percentualGordura: 15.0,
        relacaoCinturaQuadril: 0.85,
        pesoGordura: 10.5,
        medidaCintura: 80.0,
        medidaQuadril: 94.0,
        medidaPescoco: 40.0,
        linkArquivo: 'http://example.com/file.pdf',
      );

      final expectedMap = {
        'data': DateTime(2023, 10, 1),
        'status': 'Realizada',
        'tipoAvaliacao': 'PDF',
        'peso': 70.5,
        'altura': 175,
        'idade': 25,
        'imc': 23,
        'percentualGordura': 15.0,
        'relacaoCinturaQuadril': 0.85,
        'pesoGordura': 10.5,
        'medidaCintura': 80,
        'medidaQuadril': 94,
        'medidaPescoco': 40,
        'linkArquivo': 'http://example.com/file.pdf',
      };

      final map = avaliacao.toMap();

      expect(map, expectedMap);
    });

    test('should create an instance of AvaliacaoFisica from map', () {
      final map = {
        'data': Timestamp.fromDate(DateTime(2023, 10, 1)),
        'status': 'Realizada',
        'tipoAvaliacao': 'PDF',
        'peso': 70.5,
        'altura': 175,
        'idade': 25,
        'imc': 23.0,
        'percentualGordura': 15.0,
        'relacaoCinturaQuadril': 0.85,
        'pesoGordura': 10.5,
        'medidaCintura': 80.0,
        'medidaQuadril': 94.0,
        'medidaPescoco': 40.0,
        'linkArquivo': 'http://example.com/file.pdf',
      };

      final fromMap = AvaliacaoFisica.fromMap(map);

      expect(fromMap, isNotNull);

      expect(fromMap?.data, DateTime(2023, 10, 1));
      expect(fromMap?.status, StatusAvaliacao.realizada);
      expect(fromMap?.tipoAvaliacao, TipoAvaliacao.pdf);
      expect(fromMap?.peso, 70.5);
      expect(fromMap?.altura, 175);
      expect(fromMap?.idade, 25);
      expect(fromMap?.imc, 23.0);
      expect(fromMap?.percentualGordura, 15.0);
      expect(fromMap?.relacaoCinturaQuadril, 0.85);
      expect(fromMap?.pesoGordura, 10.5);
      expect(fromMap?.medidaCintura, 80.0);
      expect(fromMap?.medidaQuadril, 94.0);
      expect(fromMap?.medidaPescoco, 40.0);
      expect(fromMap?.linkArquivo, 'http://example.com/file.pdf');
    });

    test('should return null if fromMap fails', () {
      final map = {
        'data': 'invalid-date',
        'status': 'invalid-status',
        'tipoAvaliacao': 'invalid-tipoAvaliacao',
      };

      final fromMap = AvaliacaoFisica.fromMap(map);

      expect(fromMap, isNull);
    });
  });
}
