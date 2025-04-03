import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  static final FirebaseAuth _instance = FirebaseAuth.instance;

  static get instance => _instance;
}
