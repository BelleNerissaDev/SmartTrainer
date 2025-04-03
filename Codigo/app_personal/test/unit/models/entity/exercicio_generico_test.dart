// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';

void main() {
  group('Exercicio', () {
    test(
        'toMap should return a valid map representation of the Exercicio object',
        () {
      final grupoMuscular = GrupoMuscular(nome: 'Peito', id: '1');
      final exercicio = Exercicio(
        id: '123',
        nome: 'Supino Reto',
        metodologia: MetodologiaExercicio.TRADICIONAL,
        descricao: 'Exercício para peito',
        carga: 50.0,
        repeticoes: 10,
        series: 4,
        intervalo: '1 min',
        gruposMusculares: [grupoMuscular],
        tipoCarga: 'kg',
        videoUrl: 'https://www.youtube.com/watch?v=K4TOrB7at0Y',
        imagem: 'https://example.com/image',
      );

      final map = exercicio.toMap();

      expect(map['id'], equals('123'));
      expect(map['nome'], equals('Supino Reto'));
      expect(map['metodologia'], equals('Tradicional'));
      expect(map['descricao'], equals('Exercício para peito'));
      expect(map['carga'], equals(50.0));
      expect(map['repeticoes'], equals(10));
      expect(map['series'], equals(4));
      expect(map['intervalo'], equals('1 min'));
      expect(map['videoUrl'],
          equals('https://www.youtube.com/watch?v=K4TOrB7at0Y'));
      expect(map['imagem'], equals('https://example.com/image'));
      expect(map['tipoCarga'], equals('kg'));
      expect(map['gruposMusculares'], equals(['1']));
    });

    test(
        'fromMap should return a valid Exercicio object from a map representation',
        () {
      final grupoMuscular = GrupoMuscular(nome: 'Peito', id: '1');
      final map = {
        'id': '123',
        'nome': 'Agachamento',
        'metodologia': 'Bi-set',
        'descricao': 'Exercício para pernas',
        'carga': 80.0,
        'repeticoes': 12,
        'series': 3,
        'intervalo': '90 seg',
        'videoUrl': 'https://www.youtube.com/watch?v=K4TOrB7at0Y',
        'imagem': 'https://example.com/image2',
        'tipoCarga': 'kg',
        'gruposMusculares': [grupoMuscular],
      };

      final exercicio = Exercicio.fromMap(map, '123');

      expect(exercicio.id, equals('123'));
      expect(exercicio.nome, equals('Agachamento'));
      expect(exercicio.metodologia.toString(), equals('Bi-set'));
      expect(exercicio.descricao, equals('Exercício para pernas'));
      expect(exercicio.carga, equals(80.0));
      expect(exercicio.repeticoes, equals(12));
      expect(exercicio.series, equals(3));
      expect(exercicio.intervalo, equals('90 seg'));
      expect(exercicio.videoUrl,
          equals('https://www.youtube.com/watch?v=K4TOrB7at0Y'));
      expect(exercicio.imagem, equals('https://example.com/image2'));
      expect(exercicio.tipoCarga, equals('kg'));
    });

    test('should correctly set and get all properties', () {
      final grupoMuscular = GrupoMuscular(nome: 'Costas', id: '3');
      final exercicio = Exercicio(
        id: '456',
        nome: 'Remada Curvada',
        metodologia: MetodologiaExercicio.TRADICIONAL,
        descricao: 'Exercício para costas',
        carga: 40.0,
        repeticoes: 10,
        series: 4,
        intervalo: '1 min',
        gruposMusculares: [grupoMuscular],
        tipoCarga: 'kg',
      );

      exercicio.nome = 'Remada Alternada';
      exercicio.metodologia = MetodologiaExercicio.BISET;
      exercicio.descricao = 'Exercício alternado para costas';
      exercicio.carga = 45.0;
      exercicio.repeticoes = 8;
      exercicio.series = 5;
      exercicio.intervalo = '1:30 min';
      exercicio.tipoCarga = 'lbs';

      expect(exercicio.nome, equals('Remada Alternada'));
      expect(exercicio.metodologia.toString(), equals('Bi-set'));
      expect(exercicio.descricao, equals('Exercício alternado para costas'));
      expect(exercicio.carga, equals(45.0));
      expect(exercicio.repeticoes, equals(8));
      expect(exercicio.series, equals(5));
      expect(exercicio.intervalo, equals('1:30 min'));
      expect(exercicio.tipoCarga, equals('lbs'));
    });

    test(
        'MetodologiaExercicio fromString should handle unknown values as PERSONALIZADO',
        () {
      final metodologia = MetodologiaExercicio.fromString('Supersets');
      expect(metodologia.toString(), equals('Supersets'));
    });
  });
}
