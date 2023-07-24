import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/expense_chart_entity.dart';

class ExpenseChartModel extends ExpenseChartEnitity {
  final String date;
  final double price;
  final String category;
  final String id;
  const ExpenseChartModel({
    required this.date,
    required this.price,
    required this.category,
    required this.id,
  }) : super(
          id: id,
          date: date,
          price: price,
          category: category,
        );

  factory ExpenseChartModel.fromMap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return ExpenseChartModel(
      id: snap.id,
      date: data["date"],
      price: data["price"],
      category: data['category'],
    );
  }

  toMap() {
    return {
      'date': date,
      'price': price,
      'category': category,
    };
  }
}
