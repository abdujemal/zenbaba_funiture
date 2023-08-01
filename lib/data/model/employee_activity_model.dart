// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:zenbaba_funiture/domain/entity/employee_activity_entity.dart';

class EmployeeActivityModel extends EmployeeActivityEntity {
  final String? id;
  final String employeeId;
  final String date;
  final List<String> orders;
  final bool morning;
  final bool afternoon;
  final List<String> itemsUsed;
  const EmployeeActivityModel({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.orders,
    required this.morning,
    required this.afternoon,
    required this.itemsUsed,
  }) : super(
          id: id,
          employeeId: employeeId,
          date: date,
          orders: orders,
          morning: morning,
          afternoon: afternoon,
          itemsUsed: itemsUsed,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employeeId': employeeId,
      'date': date,
      'orders': orders,
      'morning': morning,
      'afternoon': afternoon,
      'itemsUsed': itemsUsed,
    };
  }

  factory EmployeeActivityModel.fromMap(DocumentSnapshot snap) {
    final map = snap.data() as Map<String, dynamic>;
    return EmployeeActivityModel(
      id: snap.id,
      employeeId: map['employeeId'] as String,
      date: map['date'] as String,
      orders:
          (map['orders'] as List<dynamic>).map((e) => e.toString()).toList(),
      morning: map['morning'] as bool,
      afternoon: map['afternoon'] as bool,
      itemsUsed:
          (map['itemsUsed'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  EmployeeActivityModel copyWith({
    String? id,
    String? employeeId,
    String? date,
    List<String>? orders,
    bool? morning,
    bool? afternoon,
    List<String>? itemsUsed,
  }) {
    return EmployeeActivityModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      orders: orders ?? this.orders,
      morning: morning ?? this.morning,
      afternoon: afternoon ?? this.afternoon,
      itemsUsed: itemsUsed ?? this.itemsUsed,
    );
  }

  @override
  String toString() {
    return 'EmployeeActivityModel(id: $id, employeeId: $employeeId, date: $date, orders: $orders, morning: $morning, afternoon: $afternoon, itemsUsed: $itemsUsed)';
  }

  @override
  bool operator ==(covariant EmployeeActivityModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.employeeId == employeeId &&
        other.date == date &&
        listEquals(other.orders, orders) &&
        other.morning == morning &&
        other.afternoon == afternoon &&
        listEquals(other.itemsUsed, itemsUsed);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        employeeId.hashCode ^
        date.hashCode ^
        orders.hashCode ^
        morning.hashCode ^
        afternoon.hashCode ^
        itemsUsed.hashCode;
  }
}
