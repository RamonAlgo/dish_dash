import 'package:firebase_auth/firebase_auth.dart';

class ServeiAuth {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> loginAmbEmailIPassword(String email, password) async {
    try {
      print("serveiauth");

      UserCredential creadencialUsuari = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return creadencialUsuari;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> tancarSessio() async {
    return await _auth.signOut();
  }

  User? getUsuarisActual() {
    return _auth.currentUser;
  }
}