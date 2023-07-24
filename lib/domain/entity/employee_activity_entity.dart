// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class EmployeeActivity extends Equatable {
  final String id;
  final String date;
  final String orderName;
  final String orderId;
  final bool morning;
  final bool afternoon;
  final List<String> itemsUsed;
  EmployeeActivity({
    required this.id,
    required this.date,
    required this.orderName,
    required this.orderId,
    required this.morning,
    required this.afternoon,
    required this.itemsUsed,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        orderName,
        morning,
        afternoon,
        itemsUsed,
      ];
}
