import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import './avaliacao_fisica_test.mocks.dart';

@GenerateMocks([Aluno])
void main() {
  group('AvaliacaoFisica', () {
    test('should create an instance with required fields', () {
      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
      );

      expect(avaliacao.data, isNotNull);
      expect(avaliacao.status, StatusAvaliacao.realizada);
      expect(avaliacao.tipoAvaliacao, TipoAvaliacao.pdf);
    });

    test('should calculate IMC correctly', () {
      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
        peso: 70,
        altura: 175,
      );

      avaliacao.calcularIndices();
      expect(avaliacao.imc, closeTo(22.86, 0.01));
    });

    test('should calculate relacaoCinturaQuadril correctly', () {
      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
        medidaCintura: 80,
        medidaQuadril: 100,
      );

      avaliacao.calcularIndices();
      expect(avaliacao.relacaoCinturaQuadril, closeTo(0.8, 0.01));
    });

    test('should calculate pesoGordura correctly', () {
      final avaliacao = AvaliacaoFisica(
        data: DateTime.now(),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
        peso: 70,
        percentualGordura: 20,
      );

      avaliacao.calcularIndices();
      expect(avaliacao.pesoGordura, closeTo(14, 0.01));
    });

    test('should calculate percentualGordura for men correctly', () {
      final aluno = MockAluno();
      when(aluno.sexo).thenReturn(Sexo.masculino.label);
      when(aluno.dataNascimento).thenReturn(DateTime(1990, 1, 1));
      final avaliacao = AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.realizada,
          tipoAvaliacao: TipoAvaliacao.pdf,
          aluno: aluno,
          peso: 80,
          altura: 180,
          medidaCintura: 80,
          medidaPescoco: 40,
          medidaQuadril: 90);

      avaliacao.calcularIndices();
      expect(avaliacao.percentualGordura, closeTo(16.59, 0.01));
    });

    test('should calculate percentualGordura for women correctly', () {
      final aluno = MockAluno();
      when(aluno.sexo).thenReturn(Sexo.feminino.label);
      when(aluno.dataNascimento).thenReturn(DateTime(1990, 1, 1));
      final avaliacao = AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.realizada,
          tipoAvaliacao: TipoAvaliacao.pdf,
          aluno: aluno,
          peso: 80,
          altura: 180,
          medidaCintura: 80,
          medidaPescoco: 40,
          medidaQuadril: 90);

      avaliacao.calcularIndices();
      expect(avaliacao.percentualGordura, closeTo(46.31, 0.01));
    });

    test('should calculate idade correctly', () {
      final aluno = MockAluno();
      when(aluno.sexo).thenReturn(Sexo.feminino.label);
      when(aluno.dataNascimento).thenReturn(DateTime(1990, 1, 1));
      final avaliacao = AvaliacaoFisica(
        data: DateTime(2024, 10, 10),
        status: StatusAvaliacao.realizada,
        tipoAvaliacao: TipoAvaliacao.pdf,
        aluno: aluno,
      );

      avaliacao.calcularIndices();
      expect(avaliacao.idade, 34);
    });

    test('should convert from map correctly', () {
      final data = DateTime(1990, 1, 1);
      final status = StatusAvaliacao.realizada;
      final tipoAvaliacao = TipoAvaliacao.pdf;
      final peso = 70.0;
      final altura = 175;
      final idade = 25;
      final imc = 22.86;
      final percentualGordura = 20.0;
      final relacaoCinturaQuadril = 0.8;
      final pesoGordura = 14.0;
      final medidaCintura = 80.0;
      final medidaQuadril = 100.0;
      final medidaPescoco = 40.0;
      final linkArquivo = 'http://example.com';

      final map = {
        'data': Timestamp.fromDate(data),
        'status': status.name,
        'tipoAvaliacao': tipoAvaliacao.name,
        'peso': peso,
        'altura': altura,
        'idade': idade,
        'imc': imc,
        'percentualGordura': percentualGordura,
        'relacaoCinturaQuadril': relacaoCinturaQuadril,
        'pesoGordura': pesoGordura,
        'medidaCintura': medidaCintura,
        'medidaQuadril': medidaQuadril,
        'medidaPescoco': medidaPescoco,
        'linkArquivo': linkArquivo,
      };
      final fromMap = AvaliacaoFisica.fromMap(map);

      expect(fromMap, isNotNull);
      expect(fromMap!.data, data);
      expect(fromMap.status, status);
      expect(fromMap.tipoAvaliacao, tipoAvaliacao);
      expect(fromMap.peso, peso);
      expect(fromMap.altura, altura);
      expect(fromMap.idade, idade);
      expect(fromMap.imc, imc);
      expect(fromMap.percentualGordura, percentualGordura);
      expect(fromMap.relacaoCinturaQuadril, relacaoCinturaQuadril);
      expect(fromMap.pesoGordura, pesoGordura);
      expect(fromMap.medidaCintura, medidaCintura);
      expect(fromMap.medidaQuadril, medidaQuadril);
      expect(fromMap.medidaPescoco, medidaPescoco);
      expect(fromMap.linkArquivo, linkArquivo);
    });

    test('should return null when converting from invalid map', () {
      final map = {
        'data': Timestamp.now(),
        'status': 'invalid',
        'tipoAvaliacao': 'invalid',
        'peso': 'invalid',
        'altura': 'invalid',
        'idade': 'invalid',
        'imc': 'invalid',
        'percentualGordura': 'invalid',
        'relacaoCinturaQuadril': 'invalid',
        'pesoGordura': 'invalid',
        'medidaCintura': 'invalid',
        'medidaQuadril': 'invalid',
        'medidaPescoco': 'invalid',
        'linkArquivo': 'invalid',
      };
      final fromMap = AvaliacaoFisica.fromMap(map);

      expect(fromMap, isNull);
    });

    test('should convert to map corretly', () {
      final data = DateTime(1990, 1, 1);
      final status = StatusAvaliacao.realizada;
      final tipoAvaliacao = TipoAvaliacao.pdf;
      final peso = 70.0;
      final altura = 175;
      final idade = 25;
      final imc = 22.86;
      final percentualGordura = 20.0;
      final relacaoCinturaQuadril = 0.8;
      final pesoGordura = 14.0;
      final medidaCintura = 80.0;
      final medidaQuadril = 100.0;
      final medidaPescoco = 40.0;
      final linkArquivo = 'http://example.com';

      final avaliacao = AvaliacaoFisica(
        data: data,
        status: status,
        tipoAvaliacao: tipoAvaliacao,
        peso: peso,
        altura: altura,
        idade: idade,
        imc: imc,
        percentualGordura: percentualGordura,
        relacaoCinturaQuadril: relacaoCinturaQuadril,
        pesoGordura: pesoGordura,
        medidaCintura: medidaCintura,
        medidaQuadril: medidaQuadril,
        medidaPescoco: medidaPescoco,
        linkArquivo: linkArquivo,
      );

      final map = avaliacao.toMap();

      expect(map['data'], data);
      expect(map['status'], status.name);
      expect(map['tipoAvaliacao'], tipoAvaliacao.name);
      expect(map['peso'], peso);
      expect(map['altura'], altura);
      expect(map['idade'], idade);
      expect(map['imc'], imc);
      expect(map['percentualGordura'], percentualGordura);
      expect(map['relacaoCinturaQuadril'], relacaoCinturaQuadril);
      expect(map['pesoGordura'], pesoGordura);
      expect(map['medidaCintura'], medidaCintura);
      expect(map['medidaQuadril'], medidaQuadril);
      expect(map['medidaPescoco'], medidaPescoco);
      expect(map['linkArquivo'], linkArquivo);
    });
  });
}
