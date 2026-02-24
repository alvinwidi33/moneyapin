import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyapin/models/users.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  var user = Rxn<Users>();

  Future<void> register(
      String email, String password, String fullName) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .set({
      'email': email,
      'fullName': fullName,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> loadUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final doc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (doc.exists) {
      user.value = Users.fromFirestore(doc);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}