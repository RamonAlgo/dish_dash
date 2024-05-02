import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServeiAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> loginAmbEmailIPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userUid = userCredential.user?.uid;

      DocumentSnapshot restaurantSnapshot = await _firestore
          .collection('restaurantes')
          .doc(userUid)
          .get();

      if (restaurantSnapshot.exists) {
        print('Restaurante encontrado: ${restaurantSnapshot.data()}');
        return userCredential;
      } else {
        throw Exception('No se encontró un restaurante con ese UID');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> tancarSessio() async {
    return await _auth.signOut();
  }

  User? getUsuarisActual() {
    return _auth.currentUser;
  }
}
