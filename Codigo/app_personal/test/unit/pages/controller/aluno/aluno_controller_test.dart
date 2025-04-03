import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:SmartTrainer_Personal/pages/controller/aluno/aluno_controller.dart';

import 'aluno_controller_test.mocks.dart';

@GenerateMocks([FirebaseAuth, AlunoRepository, UserCredential, User])
void main() {
  group('NovoAlunoController', () {
    late NovoAlunoController controller;
    late MockFirebaseAuth mockAuth;
    late MockAlunoRepository mockAlunoRepository;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockAlunoRepository = MockAlunoRepository();
      controller = NovoAlunoController(
        auth: mockAuth,
        alunoRepository: mockAlunoRepository,
      );
    });

    test('salvarAluno should return true when successful', () async {
      const email = 'test@example.com';
      const senha = 'password';
      const nome = 'John Doe';
      const dataNascimento = '10/10/2010';
      const telefone = '123456789';
      const sexo = 'Male';
      final pacoteTreino = Pacote(
        nome: 'pacote 1',
        valorMensal: '200.0',
        numeroAcessos: '50',
      );

      final userCredential = MockUserCredential();
      final user = MockUser();

      when(mockAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      )).thenAnswer((_) async => userCredential);

      when(userCredential.user).thenReturn(user);
      when(user.uid).thenReturn('user_id');
      when(user.sendEmailVerification()).thenAnswer((_) async {});
      when(mockAlunoRepository.create(any)).thenAnswer((_) async => Aluno(
            primeiroAcesso: true,
            nome: 'John Doe',
            telefone: '123456789',
            email: 'john.doe@example.com',
            sexo: 'Male',
            imagem: null,
            status: StatusAlunoEnum.ATIVO,
            peso: 70.5,
            altura: 180,
            uid: 'uid',
            dataNascimento: DateTime.now(),
            pacote: Pacote(
              nome: 'pacote 1',
              valorMensal: '200.0',
              numeroAcessos: '50',
            ),
          ));

      // Act
      final result = await controller.salvarAluno(
        email: email,
        senha: senha,
        nome: nome,
        dataNascimento: dataNascimento,
        telefone: telefone,
        sexo: sexo,
        pacoteTreino: pacoteTreino,
      );

      // Assert
      expect(result, true);
      verify(mockAlunoRepository.create(any)).called(1);
      verify(user.sendEmailVerification()).called(1);
    });

    test('salvarAluno should return false when an error occurs', () async {
      const email = 'test@example.com';
      const senha = 'password';
      const nome = 'John Doe';
      const dataNascimento = '1990-01-01';
      const telefone = '123456789';
      const sexo = 'Male';
      final pacoteTreino = Pacote(
        nome: 'pacote 1',
        valorMensal: '200.0',
        numeroAcessos: '50',
      );

      final userCredential = MockUserCredential();
      final user = MockUser();

      when(mockAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      )).thenAnswer((_) async => userCredential);

      when(userCredential.user).thenReturn(user);
      when(user.uid).thenReturn('user_id');
      when(user.sendEmailVerification()).thenAnswer((_) async {});
      when(mockAlunoRepository.create(any)).thenThrow(Exception());

      when(user.delete()).thenAnswer((_) async {});

      // Act
      final result = await controller.salvarAluno(
        email: email,
        senha: senha,
        nome: nome,
        dataNascimento: dataNascimento,
        telefone: telefone,
        sexo: sexo,
        pacoteTreino: pacoteTreino,
      );

      // Assert
      expect(result, false);
      verify(user.delete()).called(1);
    });
  });
}
