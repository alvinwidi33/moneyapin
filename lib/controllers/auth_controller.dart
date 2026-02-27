import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyapin/models/users.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  var user = Rxn<Users>();
  @override
  void onInit() {
    super.onInit();

    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        loadUser(firebaseUser.uid);
      } else {
        user.value = null;
      }
    });
  }
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
      'balance':0.0,
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

  void loadUser(String uid) {

    _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        user.value = Users.fromFirestore(doc);
      }
    });
  }
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );

      await currentUser.reauthenticateWithCredential(cred);

      await currentUser.updatePassword(newPassword);

    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Failed to change password");
    }
  }
  Future<void> logout() async {
    await _auth.signOut();
    user.value = null;

    Get.offAllNamed('/login');
  }
}