import 'package:firebase_auth/firebase_auth.dart';
import 'package:SmartTrainer_Personal/connections/provider/auth.dart' as Auth;

class AuthenticationController {
  final FirebaseAuth _auth;

  AuthenticationController({FirebaseAuth? auth})
      : _auth = auth ?? Auth.AuthProvider.instance;

  Future<bool> login() async {
    try {
      final user = await _auth.signInAnonymously();

      if (user.user != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
