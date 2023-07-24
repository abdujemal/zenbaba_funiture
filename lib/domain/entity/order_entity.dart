// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String? id;
  final String customerName;
  final String customerGender;
  final String phoneNumber;
  final String productName;
  final double productPrice;
  final double payedPrice;
  final String productSku;
  final int quantity;
  final String orderedDate;
  final String finishedDate;
  final String status;
  final String sefer;
  final String customerSource;
  final String kk;
  final String location;
  final String paymentMethod;
  final String deliveryOption;
  final String imgUrl;
  final String productDescription;
  const OrderEntity({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.productName,
    required this.productPrice,
    required this.productSku,
    required this.quantity,
    required this.orderedDate,
    required this.finishedDate,
    required this.status,
    required this.sefer,
    required this.customerSource,
    required this.kk,
    required this.location,
    required this.paymentMethod,
    required this.deliveryOption,
    required this.customerGender,
    required this.imgUrl,
    required this.productDescription,
    required this.payedPrice,
  });

  @override
  List<Object?> get props => [
        id,
        customerName,
        phoneNumber,
        productName,
        productPrice,
        productSku,
        quantity,
        orderedDate,
        finishedDate,
        status,
        sefer,
        customerSource,
        kk,
        location,
        paymentMethod,
        deliveryOption,
        customerGender,
        imgUrl,
        productDescription,
        payedPrice,
      ];
}
