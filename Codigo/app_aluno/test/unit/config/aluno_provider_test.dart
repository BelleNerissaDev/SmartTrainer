import 'package:SmartTrainer/models/entity/pacote.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';

void main() {
  group('AlunoProvider', () {
    late Aluno aluno;


    setUp(() {
      aluno = Aluno(
          nome: 'nome',
          telefone: 'telefone',
          email: 'email',
          sexo: 'sexo',
          status: StatusAlunoEnum.ATIVO,
          peso: 75.9,
          altura: 180,
          uid: 'uid',
          primeiroAcesso: false,
          dataNascimento: DateTime(1990, 1, 1),
          pacote:
              Pacote(nome: 'nome', valorMensal: '200', numeroAcessos: '50'));
    });
    test('should set and get aluno', () {
      final alunoProvider = AlunoProvider();

      alunoProvider.setAluno(aluno);

      expect(alunoProvider.aluno, equals(aluno));
    });

    test('should clear aluno', () {
      final alunoProvider = AlunoProvider();

      alunoProvider.setAluno(aluno);
      alunoProvider.clearAluno();

      expect(alunoProvider.aluno, isNull);
    });

    test('should notify listeners when aluno is set', () {
      final alunoProvider = AlunoProvider();

      bool notified = false;

      alunoProvider.addListener(() {
        notified = true;
      });

      alunoProvider.setAluno(aluno);

      expect(notified, isTrue);
    });

    test('should notify listeners when aluno is cleared', () {
      final alunoProvider = AlunoProvider();

      bool notified = false;

      alunoProvider.setAluno(aluno);
      alunoProvider.addListener(() {
        notified = true;
      });

      alunoProvider.clearAluno();

      expect(notified, isTrue);
    });
  });
}
