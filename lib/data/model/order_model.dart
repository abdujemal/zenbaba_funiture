// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/order_entity.dart';

class OrderModel extends OrderEntity {
  final String? id;
  final String customerName;
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
  final String customerGender;
  final String imgUrl;
  final String productDescription;
  const OrderModel({
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
  }) : super(
          id: id,
          customerName: customerName,
          phoneNumber: phoneNumber,
          productName: productName,
          productPrice: productPrice,
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
        );

  factory OrderModel.fromFirebase(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      id: snapshot.id,
      customerName: data['customerName'],
      phoneNumber: data['phoneNumber'],
      productName: data['productName'],
      productPrice: data['productPrice'],
      productSku: data['productSku'],
      productDescription: data['productDescription'],
      quantity: data['quantity'],
      orderedDate: data['orderedDate'],
      finishedDate: data['finishedDate'],
      status: data['status'],
      sefer: data['sefer'],
      customerSource: data['customerSource'],
      kk: data['kk'],
      location: data['location'],
      paymentMethod: data['paymentMethod'],
      deliveryOption: data['deliveryOption'],
      customerGender: data['customerGender'],
      imgUrl: data['imgUrl'],
      payedPrice: data['payedPrice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'productName': productName,
      'productPrice': productPrice,
      'productSku': productSku,
      'productDescription': productDescription,
      'quantity': quantity,
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
      'payedPrice': payedPrice,
    };
  }


  OrderModel copyWith({
    String? id,
    String? customerName,
    String? phoneNumber,
    String? productName,
    double? productPrice,
    double? payedPrice,
    String? productSku,
    int? quantity,
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
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      payedPrice: payedPrice ?? this.payedPrice,
      productSku: productSku ?? this.productSku,
      quantity: quantity ?? this.quantity,
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
    );
  }
 }
