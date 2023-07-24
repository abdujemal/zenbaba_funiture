// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class OrderChartEntity extends Equatable {
  final String date;
  final double price;
  final String orderId;
  const OrderChartEntity({
    required this.date,
    required this.price,
    required this.orderId,
  });
  @override
  List<Object?> get props => [orderId, date, price];

}
