// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenbaba_funiture/domain/entity/review_entity.dart';

class ReviewModel extends ReviewEntity {
  final String id;
  final String orderId;
  final String customerId;
  final String customerName;
  final double ratings;
  final String messege;
  final String date;
  const ReviewModel({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.ratings,
    required this.messege,
    required this.date,
  }) : super(
          id: id,
          orderId: orderId,
          customerId: customerId,
          customerName: customerName,
          ratings: ratings,
          messege: messege,
          date: date,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'ratings': ratings,
      'messege': messege,
      'date': date,
    };
  }

  factory ReviewModel.fromMap(DocumentSnapshot snap) {
    final map = snap.data() as Map;
    return ReviewModel(
      id: snap.id,
      orderId: map['orderId'] as String,
      customerId: map['customerId'] as String,
      customerName: map['customerName'] as String,
      ratings: map['ratings'] as double,
      messege: map['messege'] as String,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  ReviewModel copyWith({
    String? id,
    String? orderId,
    String? customerId,
    String? customerName,
    double? ratings,
    String? messege,
    String? date,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      ratings: ratings ?? this.ratings,
      messege: messege ?? this.messege,
      date: date ?? this.date,
    );
  }
}
