// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class EmployeeActivityEntity extends Equatable {
  final String? id;
  final String employeeId;
  final String employeeName;
  final double payment;
  final String date;
  final List<String> orders;
  final bool morning;
  final bool afternoon;
  final List<String> itemsUsed;
  const EmployeeActivityEntity({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.orders,
    required this.morning,
    required this.afternoon,
    required this.itemsUsed,
    required this.employeeName,
    required this.payment
  });

  @override
  List<Object?> get props => [
        id,
        employeeId,
        employeeName,
        date,
        orders,
        morning,
        afternoon,
        itemsUsed,
        payment
      ];
}
