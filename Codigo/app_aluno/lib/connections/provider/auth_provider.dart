import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  static final _instance = FirebaseAuth.instance;

  static FirebaseAuth get instance => _instance;
}
