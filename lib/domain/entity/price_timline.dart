// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PriceTimeline extends Equatable {
  final String date;
  final double price;
  final String itemId;
  const PriceTimeline({
    required this.date,
    required this.price,
    required this.itemId,
  });
  
  @override
  List<Object?> get props => [date, price, itemId];
}
