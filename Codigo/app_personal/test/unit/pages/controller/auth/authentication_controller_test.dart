import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SmartTrainer_Personal/pages/controller/auth/authentication_controller.dart';

import 'authentication_controller_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {
  group('AuthenticationController', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late AuthenticationController authenticationController;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authenticationController =
          AuthenticationController(auth: mockFirebaseAuth);
    });

    test('login returns true when signInAnonymously succeeds', () async {
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockFirebaseAuth.signInAnonymously())
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      final result = await authenticationController.login();

      expect(result, true);
      verify(mockFirebaseAuth.signInAnonymously()).called(1);
    });

    test('login returns false when signInAnonymously throws an exception',
        () async {
      when(mockFirebaseAuth.signInAnonymously())
          .thenThrow(Exception('Failed to sign in'));

      final result = await authenticationController.login();

      expect(result, false);
      verify(mockFirebaseAuth.signInAnonymously()).called(1);
    });

    test('login returns false when user is null', () async {
      final mockUserCredential = MockUserCredential();

      when(mockFirebaseAuth.signInAnonymously())
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(null);

      final result = await authenticationController.login();

      expect(result, false);
      verify(mockFirebaseAuth.signInAnonymously()).called(1);
    });
  });
}
