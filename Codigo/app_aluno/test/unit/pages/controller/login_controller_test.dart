import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';

import 'package:SmartTrainer/pages/controller/login_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SmartTrainer/connections/repository/aluno_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_controller_test.mocks.dart';

@GenerateMocks([
  AlunoRepository,
  SharedPreferences,
  UserCredential,
  FirebaseAuth,
  User,
  FlutterSecureStorage,
])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockSharedPreferences mockSharedPreferences;
  late MockAlunoRepository mockAlunoRepository;
  late MockUser mockUser;
  late MockUserCredential userCredential;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockUser = MockUser();

    userCredential = MockUserCredential();
    mockFirebaseAuth = MockFirebaseAuth();
    mockSharedPreferences = MockSharedPreferences();
    mockAlunoRepository = MockAlunoRepository();
    mockSecureStorage = MockFlutterSecureStorage();
  });

  setUpAll(() {
    dotenv.testLoad(mergeWith: {
      'AMQP_HOST': 'mocked_host',
      'AMQP_PORT': '1234',
      'AMQP_VIRTUAL_HOST': 'mocked_virtual_host',
      'AMQP_USER': 'mocked_user',
      'AMQP_PASSWORD': 'mocked_password',
      'AMQP_CONNECTION_NAME': 'connection_name_test',
      'AMQP_MAX_CONNECTION_ATTEMPTS': '1',
    });
  });

  group('LoginController', () {
    test('Login com sucesso e usuário existente', () async {
      Aluno aluno = Aluno(
        primeiroAcesso: false,
        nome: 'John Doe',
        telefone: '123456789',
        email: 'test@example',
        sexo: 'Male',
        status: StatusAlunoEnum.ATIVO,
        peso: 70.5,
        altura: 180,
        uid: '12345',
        id: '1',
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      );
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .thenAnswer((_) => Future.value(userCredential));

      when(userCredential.user).thenReturn(mockUser);

      when(mockUser.emailVerified).thenReturn(true);
      when(mockUser.uid).thenReturn('uid');

      when(mockAlunoRepository.readBy('uid', 'uid'))
          .thenAnswer((_) async => aluno);
      when(mockUser.getIdToken()).thenAnswer((_) async => 'token');

      when(mockSharedPreferences.getInt(any)).thenReturn(1);
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      when(mockSharedPreferences.setInt(any, any))
          .thenAnswer((_) async => true);

      when(mockAlunoRepository.update(any)).thenAnswer((_) async => aluno);

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      when(mockSecureStorage.write(
              key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => true);

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
        secureStorage: mockSecureStorage,
      );
      final result =
          await loginController.login('test@example.com', 'password123');

      expect(result, LoginStatus.logado);
      verify(mockSharedPreferences.setString('token', 'token')).called(1);
      verify(mockSharedPreferences.setString('userId', '1')).called(1);
      verify(mockSharedPreferences.setString('tokenExpiry', any)).called(1);
    });

    test('Login com sucesso e limite de login excedido', () async {
      Aluno aluno = Aluno(
        primeiroAcesso: false,
        nome: 'John Doe',
        telefone: '123456789',
        email: 'test@example',
        sexo: 'Male',
        status: StatusAlunoEnum.ATIVO,
        peso: 70.5,
        altura: 180,
        uid: '12345',
        id: '1',
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
        acessosUsadosSemana: 5,
      );
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .thenAnswer((_) => Future.value(userCredential));

      when(userCredential.user).thenReturn(mockUser);

      when(mockUser.emailVerified).thenReturn(true);
      when(mockUser.uid).thenReturn('uid');

      when(mockAlunoRepository.readBy('uid', 'uid'))
          .thenAnswer((_) async => aluno);
      when(mockUser.getIdToken()).thenAnswer((_) async => 'token');

      when(mockSharedPreferences.getInt(any)).thenReturn(1);
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      when(mockSharedPreferences.setInt(any, any))
          .thenAnswer((_) async => true);

      when(mockAlunoRepository.update(any)).thenAnswer((_) async => aluno);

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      when(mockSecureStorage.write(
              key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => true);

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
        secureStorage: mockSecureStorage,
      );
      final result =
          await loginController.login('test@example.com', 'password123');

      expect(result, LoginStatus.limiteAcessosExcedido);
      verifyNever(mockSharedPreferences.setString('token', 'token'));
      verifyNever(mockSharedPreferences.setString('userId', '1'));
      verifyNever(mockSharedPreferences.setString('tokenExpiry', any));
    });

    test('Login com sucesso e primeiro login', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .thenAnswer((_) => Future.value(userCredential));

      when(userCredential.user).thenReturn(mockUser);

      when(mockUser.emailVerified).thenReturn(true);
      when(mockUser.uid).thenReturn('uid');

      when(mockAlunoRepository.readBy('uid', 'uid'))
          .thenAnswer((_) => Future.value(Aluno(
                primeiroAcesso: true,
                nome: 'John Doe',
                telefone: '123456789',
                email: 'test@example',
                sexo: 'Male',
                status: StatusAlunoEnum.ATIVO,
                peso: 70.5,
                altura: 180,
                uid: '12345',
                id: '1',
                dataNascimento: DateTime(1990, 1, 1),
                pacote: Pacote(
                  nome: 'pacote 1',
                  valorMensal: '200',
                  numeroAcessos: '20',
                ),
              )));
      when(mockUser.getIdToken()).thenAnswer((_) async => 'token');

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
        secureStorage: mockSecureStorage,
      );
      final result =
          await loginController.login('test@example.com', 'password123');

      expect(result, LoginStatus.logadoPrimeiraVez);
      verifyNever(mockSharedPreferences.setString('token', 'token'));
      verifyNever(mockSharedPreferences.setString('userId', '1'));
      verifyNever(mockSharedPreferences.setString('tokenExpiry', any));
      verifyNever(mockSecureStorage.write(
          key: anyNamed('key'), value: anyNamed('value')));
    });

    test('Login falha - senha incorreta', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'wrongpassword'))
          .thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
      );

      final result =
          await loginController.login('test@example.com', 'wrongpassword');

      expect(result, LoginStatus.senhaIncorreta);
    });

    test('Logout limpa o token e userId', () async {
      when(mockFirebaseAuth.signOut())
          .thenAnswer((_) async => (Future<void>.value()));
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);
      when(mockSecureStorage.delete(key: anyNamed('key')))
          .thenAnswer((_) async => true);

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
        secureStorage: mockSecureStorage,
      );
      await loginController.logout();

      verify(mockFirebaseAuth.signOut()).called(1);
      verify(mockSharedPreferences.remove('token')).called(1);
      verify(mockSharedPreferences.remove('userId')).called(1);
      verify(mockSecureStorage.delete(key: 'email')).called(1);
      verify(mockSecureStorage.delete(key: 'password')).called(1);
    });

    test('Token válido', () async {
      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
      );
      when(mockSharedPreferences.getString('tokenExpiry')).thenReturn(
          DateTime.now().add(const Duration(hours: 1)).toIso8601String());

      final isValid = await loginController.isTokenValid();
      expect(isValid, true);
    });

    test('Token expirado', () async {
      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
      );
      when(mockSharedPreferences.getString('tokenExpiry')).thenReturn(
          DateTime.now().subtract(const Duration(hours: 1)).toIso8601String());

      final isValid = await loginController.isTokenValid();
      expect(isValid, false);
    });

    test('Login falha - email não verificado', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .thenAnswer((_) => Future.value(userCredential));

      when(userCredential.user).thenReturn(mockUser);
      when(mockUser.emailVerified).thenReturn(false);

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
      );

      final result =
          await loginController.login('test@example.com', 'password123');

      expect(result, LoginStatus.emailNaoVerificado);
    });

    test('Login falha - erro desconhecido', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .thenThrow(Exception('Unknown error'));

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
      );

      final result =
          await loginController.login('test@example.com', 'password123');

      expect(result, LoginStatus.erroDesconhecido);
    });

    test('Login from token - token válido', () async {
      when(mockSharedPreferences.getString('token')).thenReturn('valid_token');
      when(mockSharedPreferences.getString('tokenExpiry')).thenReturn(
          DateTime.now().add(const Duration(hours: 1)).toIso8601String());
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.reauthenticateWithCredential(any))
          .thenAnswer((_) async => MockUserCredential());
      when(mockSecureStorage.read(key: 'email'))
          .thenAnswer((_) async => 'email@example.com');
      when(mockSecureStorage.read(key: 'password')).thenAnswer((_) async {
        return 'asdfgdgadahjghj8313';
      });

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
        secureStorage: mockSecureStorage,
      );

      final result = await loginController.loginFromToken();
      expect(result, true);
    });

    test('Login from token - token inválido', () async {
      when(mockSharedPreferences.getString('token'))
          .thenReturn('invalid_token');
      when(mockSecureStorage.read(key: 'email'))
          .thenAnswer((_) async => 'email@example.com');
      when(mockSecureStorage.read(key: 'password')).thenAnswer((_) async {
        return 'asdfgdgadahjghj8313';
      });
      when(mockSharedPreferences.getString('tokenExpiry')).thenReturn(
          DateTime.now().subtract(const Duration(hours: 1)).toIso8601String());

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
        secureStorage: mockSecureStorage,
      );

      final result = await loginController.loginFromToken();
      expect(result, false);
    });

    test('Esqueci senha - sucesso', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'))
          .thenAnswer((_) async => Future.value());

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
      );

      final result = await loginController.esqueciSenha('test@example.com');

      expect(result, true);
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'))
          .called(1);
    });

    test('Esqueci senha - falha', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
      );

      final result = await loginController.esqueciSenha('test@example.com');

      expect(result, false);
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'))
          .called(1);
    });
    test('ehNovaSemana - nova semana', () {
      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
        secureStorage: mockSecureStorage,
      );

      DateTime ultimoAcesso = DateTime.now().subtract(const Duration(days: 8));
      DateTime agora = DateTime.now();

      final result = loginController.ehNovaSemana(ultimoAcesso, agora);

      expect(result, true);
    });

    test('ehNovaSemana - mesma semana', () {
      LoginController loginController = LoginController(
        auth: mockFirebaseAuth,
        alunoRepository: mockAlunoRepository,
        prefs: Future.value(mockSharedPreferences),
        secureStorage: mockSecureStorage,
      );

      DateTime ultimoAcesso = DateTime(2024, 10, 01);
      DateTime agora = DateTime(2024, 10, 03);

      final result = loginController.ehNovaSemana(ultimoAcesso, agora);

      expect(result, false);
    });
  });
}
