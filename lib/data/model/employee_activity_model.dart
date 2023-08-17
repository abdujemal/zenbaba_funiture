import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenbaba_funiture/domain/entity/employee_activity_entity.dart';

class EmployeeActivityModel extends EmployeeActivityEntity {
  final String? id;
  final String employeeId;
  final String employeeName;
  final double payment;
  final String date;
  final List<String> orders;
  final bool morning;
  final bool afternoon;
  final List<String> itemsUsed;
  const EmployeeActivityModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.orders,
    required this.morning,
    required this.afternoon,
    required this.itemsUsed,
    required this.payment,
  }) : super(
          id: id,
          employeeId: employeeId,
          employeeName: employeeName,
          date: date,
          orders: orders,
          morning: morning,
          afternoon: afternoon,
          itemsUsed: itemsUsed,
          payment: payment,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employeeId': employeeId,
      'employeeName': employeeName,
      'date': date,
      'orders': orders,
      'morning': morning,
      'afternoon': afternoon,
      'itemsUsed': itemsUsed,
      'payment': payment,
    };
  }

  factory EmployeeActivityModel.fromMap(DocumentSnapshot snap) {
    final map = snap.data() as Map<String, dynamic>;
    return EmployeeActivityModel(
      id: snap.id,
      employeeId: map['employeeId'] as String,
      employeeName: map['employeeName'] as String,
      date: map['date'] as String,
      payment: map['payment'],
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
    String? employeeName,
    String? date,
    double? payment,
    List<String>? orders,
    bool? morning,
    bool? afternoon,
    List<String>? itemsUsed,
  }) {
    return EmployeeActivityModel(
      id: id ?? this.id,
      employeeName: employeeName ?? this.employeeName,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      orders: orders ?? this.orders,
      morning: morning ?? this.morning,
      afternoon: afternoon ?? this.afternoon,
      itemsUsed: itemsUsed ?? this.itemsUsed,
      payment: payment ?? this.payment,
    );
  }
}
