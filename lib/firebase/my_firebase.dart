import 'package:firebase_core/firebase_core.dart';

class MyFirebase {
  static final instance = MyFirebase._();

  Future<FirebaseApp> firebaseApp;

  MyFirebase._() {
    this.firebaseApp = Firebase.initializeApp();
  }
}
