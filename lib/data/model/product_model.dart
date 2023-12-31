// ignore_for_file: public_member_api_docs, sort_constructors_first, annotate_overrides, overridden_fields
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenbaba_funiture/domain/entity/product_entity.dart';

class ProductModel extends ProductEntity {
  final String? id;
  final String name;
  final String sku;
  final String category;
  final String description;
  final double? labourCost;
  final double? overhead;
  final double? profit;
  final String size;
  final List<dynamic> images;
  final double price;
  final List<dynamic> tags;
  final List<RawMaterial> rawMaterials;
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.description,
    required this.labourCost,
    required this.overhead,
    required this.profit,
    required this.images,
    required this.price,
    required this.tags,
    required this.size,
    required this.rawMaterials,
  }) : super(
          id: id,
          name: name,
          sku: sku,
          category: category,
          description: description,
          images: images,
          price: price,
          labourCost: labourCost,
          overhead: overhead,
          profit: profit,
          tags: tags,
          size: size,
          rawMaterials: rawMaterials,
        );

  factory ProductModel.fromFirebase(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductModel(
      id: snapshot.id,
      name: data['name'],
      sku: data['sku'],
      category: data['category'],
      description: data['description'],
      images: data['images'],
      price: double.parse(data['price'].toString()),
      labourCost: double.parse(data['labourCost'].toString()),
      overhead: double.parse(data["overhead"].toString()),
      profit: double.parse(data['profit'].toString()),
      tags: data['tags'],
      size: data["size"] ?? "",
      rawMaterials: List.from(data["rawMaterials"] ?? [])
          .map((e) => RawMaterial(
                name: e["name"],
                unit: e['unit'],
                unitPrice: e['unitPrice'],
                quantity: e['quantity'],
                totalPrice: e['totalPrice'],
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sku': sku,
      'category': category,
      'description': description,
      'images': images,
      'price': price,
      'labourCost': labourCost,
      'overhead': overhead,
      'profit': profit,
      'tags': tags,
      "size": size,
      'rawMaterials': rawMaterials.map((e) => e.toMap()),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    double? overhead,
    double? profit,
    double? labourCost,
    String? description,
    List<dynamic>? images,
    double? price,
    List<dynamic>? tags,
    String? size,
    List<RawMaterial>? rawMaterials,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      description: description ?? this.description,
      images: images ?? this.images,
      price: price ?? this.price,
      profit: profit ?? this.profit,
      overhead: overhead ?? this.overhead,
      labourCost: labourCost ?? this.labourCost,
      tags: tags ?? this.tags,
      size: size ?? this.size,
      rawMaterials: rawMaterials ?? this.rawMaterials,
    );
  }
}

class RawMaterial {
  final String name;
  final String unit;
  final double unitPrice;
  final double quantity;
  final double totalPrice;
  const RawMaterial({
    required this.name,
    required this.unit,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });

  RawMaterial copyWith({
    String? name,
    String? unit,
    double? unitPrice,
    double? quantity,
    double? totalPrice,
  }) {
    return RawMaterial(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'unit': unit,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  factory RawMaterial.fromMap(Map<String, dynamic> map) {
    return RawMaterial(
      name: map['name'] as String,
      unit: map['unit'] as String,
      unitPrice: double.parse(map['unitPrice'].toString()),
      quantity: double.parse(map['quantity'].toString()),
      totalPrice: double.parse(map['totalPrice'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory RawMaterial.fromJson(String source) =>
      RawMaterial.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RawMaterial(name: $name, unit: $unit, unitPrice: $unitPrice, quantity: $quantity, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(covariant RawMaterial other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.unit == unit &&
        other.unitPrice == unitPrice &&
        other.quantity == quantity &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        unit.hashCode ^
        unitPrice.hashCode ^
        quantity.hashCode ^
        totalPrice.hashCode;
  }
}
