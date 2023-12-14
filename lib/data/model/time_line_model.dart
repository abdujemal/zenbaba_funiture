// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class TimeLineModel extends Equatable {
  final String date;
  final double price;
  const TimeLineModel({
    required this.date,
    required this.price,
  });

  @override
  List<Object?> get props => [date, price];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'price': price,
    };
  }

  factory TimeLineModel.fromMap(Map<String, dynamic> map) {
    return TimeLineModel(
      date: map['date'] as String,
      price: double.parse(map['price'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeLineModel.fromJson(String source) =>
      TimeLineModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
