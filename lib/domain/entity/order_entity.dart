// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String? id;
  final String? customerId;
  final List<String> itemsUsed;
  final List<String> employees;
  final String customerName;
  final String customerGender;
  final String phoneNumber;
  final String productName;
  final double productPrice;
  final double deliveryPrice;
  final double payedPrice;
  final String productSku;
  final int quantity;
  final String orderedDate;
  final String finishedDate;
  final String status;
  final String color;
  final String size;
  final String sefer;
  final String customerSource;
  final String kk;
  final String location;
  final String paymentMethod;
  final String deliveryOption;
  final String imgUrl;
  final String productDescription;
  final String? bankAccount;
  final bool withReciept;
  const OrderEntity({
    required this.itemsUsed,
    required this.employees,
    required this.deliveryPrice,
    required this.customerId,
    required this.color,
    required this.size,
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
    required this.withReciept,
    this.bankAccount,
  });

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        phoneNumber,
        productName,
        productPrice,
        deliveryPrice,
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
        color,
        size,
        itemsUsed,
        employees,
        bankAccount,
        withReciept,
      ];
}
