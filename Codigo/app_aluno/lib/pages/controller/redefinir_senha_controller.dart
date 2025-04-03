import 'package:SmartTrainer/connections/repository/aluno_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SmartTrainer/connections/provider/auth_provider.dart' as Auth;

class RedefinirSenhaController {
  final FirebaseAuth _auth;
  final AlunoRepository _alunoRepository;
  final Future<SharedPreferences> _prefs;
  final FlutterSecureStorage _secureStorage;

  RedefinirSenhaController({
    FirebaseAuth? auth,
    AlunoRepository? alunoRepository,
    Future<SharedPreferences>? prefs,
    FlutterSecureStorage? secureStorage,
  })  : _auth = auth ?? Auth.AuthProvider.instance,
        _alunoRepository = alunoRepository ?? AlunoRepository(),
        _prefs = prefs ?? SharedPreferences.getInstance(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<bool> redefinirSenha(String senha) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return false;
      }

      await user.updatePassword(senha);

      final aluno = await _alunoRepository.readBy('uid', user.uid);

      aluno.primeiroAcesso = false;

      await _alunoRepository.update(aluno);

      final prefs = await _prefs;

      String? token = await user.getIdToken();

      if (token != null) {
        DateTime now = DateTime.now();
        DateTime expiryTime = DateTime(now.year, now.month, now.day, 23, 59);

        prefs.setString('token', token);
        prefs.setString('tokenExpiry', expiryTime.toIso8601String());
        prefs.setString('userId', aluno.id!);
        _secureStorage.write(key: 'email', value: aluno.email);
        _secureStorage.write(key: 'password', value: senha);
      }

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
