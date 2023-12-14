// ignore_for_file: public_member_api_docs, sort_constructors_first, annotate_overrides, overridden_fields
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/order_entity.dart';

class OrderModel extends OrderEntity {
  final String? id;
  final String customerName;
  final String phoneNumber;
  final String productName;
  final double productPrice;
  final double payedPrice;
  final double deliveryPrice;
  final String productSku;
  final int quantity;
  final String color;
  final String size;
  final String orderedDate;
  final String finishedDate;
  final String status;
  final String sefer;
  final String customerSource;
  final String kk;
  final String location;
  final String paymentMethod;
  final String deliveryOption;
  final String customerGender;
  final String imgUrl;
  final String productDescription;
  final String? customerId;
  final String? bankAccount;
  final bool withReciept;
  final List<String> itemsUsed;
  final List<String> employees;
  const OrderModel({
    required this.itemsUsed,
    required this.employees,
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.phoneNumber,
    required this.productName,
    required this.productPrice,
    required this.deliveryPrice,
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
    required this.color,
    required this.size,
    required this.withReciept,
    this.bankAccount,
  }) : super(
          id: id,
          customerName: customerName,
          phoneNumber: phoneNumber,
          productName: productName,
          productPrice: productPrice,
          deliveryPrice: deliveryPrice,
          productSku: productSku,
          quantity: quantity,
          orderedDate: orderedDate,
          finishedDate: finishedDate,
          status: status,
          sefer: sefer,
          customerSource: customerSource,
          kk: kk,
          location: location,
          paymentMethod: paymentMethod,
          deliveryOption: deliveryOption,
          customerGender: customerGender,
          imgUrl: imgUrl,
          productDescription: productDescription,
          payedPrice: payedPrice,
          color: color,
          size: size,
          customerId: customerId,
          itemsUsed: itemsUsed,
          employees: employees,
          bankAccount: bankAccount,
          withReciept: withReciept,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'productName': productName,
      'productPrice': productPrice,
      'payedPrice': payedPrice,
      'deliveryPrice': deliveryPrice,
      'productSku': productSku,
      'quantity': quantity,
      'color': color,
      'size': size,
      'orderedDate': orderedDate,
      'finishedDate': finishedDate,
      'status': status,
      'sefer': sefer,
      'customerSource': customerSource,
      'kk': kk,
      'location': location,
      'paymentMethod': paymentMethod,
      'deliveryOption': deliveryOption,
      'customerGender': customerGender,
      'imgUrl': imgUrl,
      'productDescription': productDescription,
      'customerId': customerId,
      'itemsUsed': itemsUsed,
      'employees': employees,
      'bankAccount': bankAccount,
      'withReciept': withReciept,
    };
  }

  factory OrderModel.fromFirebase(DocumentSnapshot snap) {
    final map = snap.data() as Map;
    return OrderModel(
      id: snap.id,
      customerName: map['customerName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      productName: map['productName'] as String,
      productPrice: double.parse(map['productPrice'].toString()),
      payedPrice: double.parse(map['payedPrice'].toString()),
      deliveryPrice: double.parse(map['deliveryPrice'].toString()),
      productSku: map['productSku'] as String,
      quantity: map['quantity'] as int,
      color: map['color'] as String,
      size: map['size'] as String,
      orderedDate: map['orderedDate'] as String,
      finishedDate: map['finishedDate'] as String,
      status: map['status'] as String,
      sefer: map['sefer'] as String,
      customerSource: map['customerSource'] as String,
      kk: map['kk'] as String,
      location: map['location'] as String,
      paymentMethod: map['paymentMethod'] as String,
      deliveryOption: map['deliveryOption'] as String,
      customerGender: map['customerGender'] as String,
      imgUrl: map['imgUrl'] as String,
      productDescription: map['productDescription'] as String,
      customerId:
          map['customerId'] != null ? map['customerId'] as String : null,
      itemsUsed:
          (map['itemsUsed'] as List<dynamic>).map((e) => e as String).toList(),
      employees:
          (map['employees'] as List<dynamic>).map((e) => e as String).toList(),
      bankAccount: map['bankAccount'],
      withReciept: map['withReciept'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  OrderModel copyWith({
    String? id,
    String? customerName,
    String? phoneNumber,
    String? productName,
    double? productPrice,
    double? payedPrice,
    double? deliveryPrice,
    String? productSku,
    int? quantity,
    String? color,
    String? size,
    String? orderedDate,
    String? finishedDate,
    String? status,
    String? sefer,
    String? customerSource,
    String? kk,
    String? location,
    String? paymentMethod,
    String? deliveryOption,
    String? customerGender,
    String? imgUrl,
    String? productDescription,
    String? customerId,
    List<String>? itemsUsed,
    List<String>? employees,
    String? bankAccount,
    bool? withReciept,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      payedPrice: payedPrice ?? this.payedPrice,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      productSku: productSku ?? this.productSku,
      quantity: quantity ?? this.quantity,
      color: color ?? this.color,
      size: size ?? this.size,
      orderedDate: orderedDate ?? this.orderedDate,
      finishedDate: finishedDate ?? this.finishedDate,
      status: status ?? this.status,
      sefer: sefer ?? this.sefer,
      customerSource: customerSource ?? this.customerSource,
      kk: kk ?? this.kk,
      location: location ?? this.location,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      customerGender: customerGender ?? this.customerGender,
      imgUrl: imgUrl ?? this.imgUrl,
      productDescription: productDescription ?? this.productDescription,
      customerId: customerId ?? this.customerId,
      itemsUsed: itemsUsed ?? this.itemsUsed,
      employees: employees ?? this.employees,
      bankAccount: bankAccount ?? this.bankAccount,
      withReciept: withReciept ?? this.withReciept,
    );
  }
}
