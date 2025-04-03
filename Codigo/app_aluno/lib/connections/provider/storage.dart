import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  static final _instance = FirebaseStorage.instance;

  static FirebaseStorage get instance => _instance;
}
