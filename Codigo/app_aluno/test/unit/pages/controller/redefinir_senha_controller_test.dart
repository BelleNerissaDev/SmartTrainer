import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SmartTrainer/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer/pages/controller/redefinir_senha_controller.dart';

import 'redefinir_senha_controller_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  User,
  AlunoRepository,
  SharedPreferences,
  Aluno,
  FlutterSecureStorage,
])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockAlunoRepository mockAlunoRepository;
  late MockSharedPreferences mockPrefs;
  late MockFlutterSecureStorage mockSecureStorage;
  late RedefinirSenhaController controller;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockAlunoRepository = MockAlunoRepository();
    mockPrefs = MockSharedPreferences();
    mockSecureStorage = MockFlutterSecureStorage();
    controller = RedefinirSenhaController(
      auth: mockFirebaseAuth,
      alunoRepository: mockAlunoRepository,
      prefs: Future.value(mockPrefs),
      secureStorage: mockSecureStorage,
    );
  });

  group('RedefinirSenhaController', () {
    test('should return false if no user is logged in', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await controller.redefinirSenha('newPassword');

      expect(result, false);
    });

    test('should return true if password is successfully updated', () async {
      final aluno = MockAluno();
      when(aluno.id).thenReturn('id');
      when(aluno.uid).thenReturn('uid');
      when(aluno.email).thenReturn('email');
      when(mockUser.uid).thenReturn('uid');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.updatePassword(any)).thenAnswer((_) async => {});
      when(mockAlunoRepository.readBy(any, any)).thenAnswer((_) async => aluno);
      when(mockAlunoRepository.update(any)).thenAnswer((_) async => aluno);
      when(mockUser.getIdToken()).thenAnswer((_) async => 'mockToken');
      when(mockSecureStorage.write(
              key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => {});

      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      final result = await controller.redefinirSenha('newPassword');

      expect(result, true);
    });

    test('should return false if FirebaseAuthException is thrown', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.updatePassword(any))
          .thenThrow(FirebaseAuthException(code: 'error'));

      final result = await controller.redefinirSenha('newPassword');

      expect(result, false);
    });
  });
}
