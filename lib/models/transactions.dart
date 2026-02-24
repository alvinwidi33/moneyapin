import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String? id;
  final String category;
  final String title;
  final double amount;
  final DateTime date;
  final String? notes;
  List<String>? tags;

  Transactions({
    this.id,
    required this.category,
    required this.title,
    required this.amount,
    required this.date,
    this.notes,
    this.tags
  });

  factory Transactions.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return Transactions(
      id: doc.id,
      category: data['category'],
      title: data['title'],
      amount: data['amount'],
      date: (data['date'] as Timestamp).toDate(),
      notes:data['notes'],
      tags:_parseTags(data['tags'])
    );
  }
  static List<String> _parseTags(dynamic value){
    if (value == null) return [];

    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    if (value is String) {
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }
  Map<String, dynamic> toFirestore() {
    return {
      'category':category,
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'tags':tags
    };
  }
}