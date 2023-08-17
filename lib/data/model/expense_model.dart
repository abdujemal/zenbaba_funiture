// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenbaba_funiture/domain/entity/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  final String? id;
  final String category;
  final String description;
  final double price;
  final String expenseStatus;
  final String date;
  final String seller;
  final String? employeeId;
  const ExpenseModel({
    required this.id,
    required this.category,
    required this.description,
    required this.price,
    required this.expenseStatus,
    required this.seller,
    required this.date,
    required this.employeeId,
  }) : super(
          id: id,
          category: category,
          description: description,
          price: price,
          expenseStatus: expenseStatus,
          date: date,
          seller: seller,
          employeeId: employeeId,
        );

  factory ExpenseModel.fromFirebase(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ExpenseModel(
        id: snapshot.id,
        seller: data['seller'],
        employeeId: data['employeeId'],
        date: data['date'],
        category: data['category'],
        description: data['description'],
        price: data['price'],
        expenseStatus: data['expenseStatus']);
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'price': price,
      'expenseStatus': expenseStatus,
      'seller': seller,
      'date': date,
      'employeeId': employeeId,
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? category,
    String? description,
    double? price,
    String? expenseStatus,
    String? date,
    String? seller,
    String? employeeId,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      expenseStatus: expenseStatus ?? this.expenseStatus,
      date: date ?? this.date,
      seller: seller ?? this.seller,
    );
  }
}
