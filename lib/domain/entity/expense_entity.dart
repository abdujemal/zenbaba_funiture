// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final String? id;
  final String category;
  final String description;
  final double price;
  final String expenseStatus;
  final String seller;
  final String date;
  final String? employeeId;
  const ExpenseEntity({
    required this.id,
    required this.category,
    required this.description,
    required this.price,
    required this.expenseStatus,
    required this.seller,
    required this.date,
    required this.employeeId,
  });
  @override
  List<Object?> get props => [
        id,
        category,
        description,
        price,
        expenseStatus,
        seller,
        date,
        employeeId,
      ];
}
