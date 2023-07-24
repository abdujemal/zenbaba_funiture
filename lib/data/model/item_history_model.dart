// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import '../../domain/entity/item_history_entity.dart';

class ItemHistoryModel extends ItemHistoryEntity {
  final int quantity;
  final String type;
  final String date;
  final String id;
  final String price; //empty string if it is used
  final String seller; //empty string if it is used
  final String employeeId; //empty string if it is buyed
  const ItemHistoryModel({
    required this.quantity,
    required this.type,
    required this.date,
    required this.id,
    required this.price,
    required this.seller,
    required this.employeeId,
  }) : super(
          date: date,
          type: type,
          quantity: quantity,
          id: id,
          price: price,
          seller: seller,
          employeeId: employeeId,
        );

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
      'type': type,
      'date': date,
      'id': id,
      'price': price,
      'seller': seller,
      'employeeId': employeeId,
    };
  }

  factory ItemHistoryModel.fromMap(Map<String, dynamic> map) {
    return ItemHistoryModel(
      quantity: map['quantity'] as int,
      type: map['type'] as String,
      date: map['date'] as String,
      id: map['id'] as String,
      price: map['price'] as String,
      seller: map['seller'] as String,
      employeeId: map['employeeId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemHistoryModel.fromJson(String source) => ItemHistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ItemHistoryModel copyWith({
    int? quantity,
    String? type,
    String? date,
    String? id,
    String? price,
    String? seller,
    String? employeeId,
  }) {
    return ItemHistoryModel(
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      date: date ?? this.date,
      id: id ?? this.id,
      price: price ?? this.price,
      seller: seller ?? this.seller,
      employeeId: employeeId ?? this.employeeId,
    );
  }
}
