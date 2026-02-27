import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transactions.dart';

class TransactionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var transactions = <Transactions>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();

    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      fetchTransactions(currentUser.uid);
    }

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        fetchTransactions(user.uid);
      } else {
        transactions.clear();
      }
    });
  }

  void fetchTransactions(String userId) {
    _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      transactions.assignAll(
        snapshot.docs
            .map((doc) => Transactions.fromFirestore(doc))
            .toList(),
      );
    });
  }

  Future<void> addTransaction(Transactions transaction) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userRef =
        _firestore.collection('users').doc(userId);

    final txRef =
        userRef.collection('transactions');

    await _firestore.runTransaction((trx) async {
      final userSnap = await trx.get(userRef);
      final currentBalance =
          (userSnap['balance'] ?? 0).toDouble();

      double newBalance = currentBalance;

      if (transaction.type == "income") {
        newBalance += transaction.amount;
      } else {
        newBalance -= transaction.amount;
      }

      trx.update(userRef, {
        'balance': newBalance,
        'updatedAt': Timestamp.now(),
      });

      trx.set(
        txRef.doc(),
        transaction.toFirestore(),
      );
    });
  }

  Future<void> deleteTransaction(String id) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(id)
        .delete();
  }
}