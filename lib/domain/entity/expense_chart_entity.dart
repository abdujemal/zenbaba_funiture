// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ExpenseChartEnitity extends Equatable {
  final String date;
  final double price;
  final String category;
  final String id;
  const ExpenseChartEnitity({
    required this.date,
    required this.price,
    required this.category,
    required this.id,

  });

  @override
  List<Object?> get props => [id, date, price, category];
}
