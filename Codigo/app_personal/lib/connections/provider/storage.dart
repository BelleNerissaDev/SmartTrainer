import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  static final _instance = FirebaseStorage.instance;

  static get instance => _instance;
}
