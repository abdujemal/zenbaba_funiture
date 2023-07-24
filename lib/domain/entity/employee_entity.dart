// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
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
  const EmployeeEntity({
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
  });

  @override
  List<Object?> get props => [
        id,
        imgUrl,
        name,
        phoneNo,
        age,
        location,
        position,
        type,
        payment,
        salaryType,
      ];
}
