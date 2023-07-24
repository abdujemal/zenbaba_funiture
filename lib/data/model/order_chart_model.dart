import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/order_chart_entity.dart';

class OrderChartModel extends OrderChartEntity {
  final String date;
  final double price;
  final String orderId;
  const OrderChartModel({
    required this.date,
    required this.price,
    required this.orderId,
  }) : super(
          date: date,
          price: price,
          orderId: orderId,
        );

  factory OrderChartModel.fromMap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return OrderChartModel(date: data["date"], price: data["price"], orderId: data['orderId']);
  }

  toMap() {
    return {
      'date': date,
      'price': price,
      'orderId': orderId,
    };
  }
}
