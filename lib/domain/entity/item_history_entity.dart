// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ItemHistoryEntity extends Equatable {
  final int quantity;
  final String type;
  final String date;
  final String id;
  final String price; //empty string if it is used
  final String seller; //empty string if it is used 
  final String employeeId; //empty string if it is buyed
  const ItemHistoryEntity({
    required this.quantity,
    required this.type,
    required this.date,
    required this.id,
    required this.price,
    required this.seller,
    required this.employeeId,
  });
  @override
  List<Object?> get props => [
        quantity,
        type,
        date,
        id,
        price,
        seller,
        employeeId,
      ];
}
