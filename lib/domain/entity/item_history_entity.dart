// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ItemHistoryEntity extends Equatable {
  final int quantity;
  final String type;
  final String date;
  final String? id;
  final String itemName;
  final String itemCategory;
  final String itemImg;
  final String itemId;
  final String unit;
  final String price; //empty string if it is used
  final String seller; //empty string if it is used
  final String employeeId; //empty string if it is buyed
  final String orderId; //empty string if it is buyed
  const ItemHistoryEntity({
    required this.quantity,
    required this.type,
    required this.date,
    required this.unit,
    required this.id,
    required this.price,
    required this.seller,
    required this.itemId,
    required this.itemName,
    required this.itemCategory,
    required this.itemImg,
    required this.employeeId,
    required this.orderId,
  });
  @override
  List<Object?> get props => [
        quantity,
        type,
        date,
        id,
        unit,
        orderId,
        price,
        seller,
        itemId,
        itemName,
        itemImg,
        itemCategory,
        employeeId,
      ];
}
