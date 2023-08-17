import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String orderId;
  final String customerId;
  final String customerName;
  final double ratings;
  final String messege;
  final String date;

  const ReviewEntity({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.ratings,
    required this.messege,
    required this.date,
  });
  @override
  List<Object?> get props => [
        id,
        orderId,
        customerId,
        customerName,
        ratings,
        messege,
        date,
      ];
}
