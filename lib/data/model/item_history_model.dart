// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/item_history_entity.dart';

class ItemHistoryModel extends ItemHistoryEntity {
  final int quantity;
  final String type;
  final String date;
  final String? id;
  final String itemId;
  final String itemName;
  final String itemImg;
  final String unit;
  final String itemCategory;
  final String price; //empty string if it is used
  final String seller; //empty string if it is used
  final String employeeId; //empty string if it is buyed
  final String orderId;
  const ItemHistoryModel({
    required this.quantity,
    required this.type,
    required this.date,
    required this.id,
    required this.unit,
    required this.itemId,
    required this.itemName,
    required this.itemImg,
    required this.itemCategory,
    required this.price,
    required this.seller,
    required this.employeeId,
    required this.orderId,
  }) : super(
          date: date,
          type: type,
          quantity: quantity,
          id: id,
          unit: unit,
          itemId: itemId,
          itemName: itemName,
          itemImg: itemImg,
          itemCategory: itemCategory,
          price: price,
          seller: seller,
          employeeId: employeeId,
          orderId: orderId,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
      'type': type,
      'date': date,
      "unit": unit,
      'itemId': itemId,
      'itemName': itemName,
      'itemCategory': itemCategory,
      'itemImg': itemImg,
      'price': price,
      'seller': seller,
      'employeeId': employeeId,
      'orderId': orderId,
    };
  }

  factory ItemHistoryModel.fromMap(DocumentSnapshot snap) {
    final map = snap.data() as Map;
    return ItemHistoryModel(
      id: snap.id,
      orderId: map["orderId"] as String,
      itemId: map['itemId'] as String,
      itemImg: map['itemImg'] as String,
      itemName: map['itemName'] as String,
      unit: map['unit'] as String,
      itemCategory: map['itemCategory'] as String,
      quantity: map['quantity'] as int,
      type: map['type'] as String,
      date: map['date'] as String,
      price: map['price'] as String,
      seller: map['seller'] as String,
      employeeId: map['employeeId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  ItemHistoryModel copyWith({
    int? quantity,
    String? type,
    String? date,
    String? id,
    String? unit,
    String? itemId,
    String? itemName,
    String? itemImg,
    String? itemCategory,
    String? price,
    String? seller,
    String? employeeId,
    String? orderId,
  }) {
    return ItemHistoryModel(
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      date: date ?? this.date,
      id: id ?? this.id,
      unit: unit ?? this.unit,
      orderId: orderId ?? this.orderId,
      itemId: itemId ?? this.itemId,
      itemImg: itemImg ?? this.itemImg,
      itemCategory: itemCategory ?? this.itemCategory,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      seller: seller ?? this.seller,
      employeeId: employeeId ?? this.employeeId,
    );
  }
}
