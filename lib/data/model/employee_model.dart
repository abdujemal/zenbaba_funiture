// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  final String? id;
  final String? imgUrl;
  final String name;
  final String phoneNo;
  final String age;
  final String location;
  final String position;
  final String type;
  final String payment;
  final String salaryType;
  final String startFromDate;
  const EmployeeModel({
    required this.id,
    required this.imgUrl,
    required this.name,
    required this.phoneNo,
    required this.age,
    required this.location,
    required this.position,
    required this.type,
    required this.payment,
    required this.salaryType,
    required this.startFromDate,
  }) : super(
          id: id,
          imgUrl: imgUrl,
          name: name,
          phoneNo: phoneNo,
          age: age,
          location: location,
          position: position,
          type: type,
          payment: payment,
          salaryType: salaryType,
          startFromDate: startFromDate,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imgUrl': imgUrl,
      'name': name,
      'phoneNo': phoneNo,
      'age': age,
      'location': location,
      'position': position,
      'type': type,
      'payment': payment,
      'salaryType': salaryType,
      'startFromDate': startFromDate
    };
  }

  factory EmployeeModel.fromMap(DocumentSnapshot snap) {
    final map = snap.data() as Map<String, dynamic>;
    return EmployeeModel(
        id: snap.id,
        imgUrl: map['imgUrl'] as String,
        name: map['name'] as String,
        phoneNo: map['phoneNo'] as String,
        age: map['age'] as String,
        location: map['location'] as String,
        position: map['position'] as String,
        type: map['type'] as String,
        payment: map['payment'] as String,
        salaryType: map['salaryType'] as String,
        startFromDate:
            map['startFromDate'] ?? DateTime.now().toString().split(" ")[0]);
  }

  String toJson() => json.encode(toMap());

  EmployeeModel copyWith({
    String? id,
    String? imgUrl,
    String? name,
    String? phoneNo,
    String? age,
    String? location,
    String? position,
    String? type,
    String? payment,
    String? salaryType,
    String? startFromDate,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      name: name ?? this.name,
      phoneNo: phoneNo ?? this.phoneNo,
      age: age ?? this.age,
      location: location ?? this.location,
      position: position ?? this.position,
      type: type ?? this.type,
      payment: payment ?? this.payment,
      salaryType: salaryType ?? this.salaryType,
      startFromDate: startFromDate ?? this.startFromDate,
    );
  }
}
