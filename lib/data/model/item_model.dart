// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/item_entity.dart';

class ItemModel extends ItemEntity {
  final String? id;
  final String? image;
  final String name;
  final String category;
  final String unit;
  final double pricePerUnit;
  final String description;
  final int quantity;
  final List<dynamic> history;
  const ItemModel({
    required this.id,
    required this.image,
    required this.name,
    required this.category,
    required this.unit,
    required this.pricePerUnit,
    required this.description,
    required this.quantity,
    required this.history,
  }) : super(
            id: id,
            image: image,
            name: name,
            category: category,
            unit: unit,
            pricePerUnit: pricePerUnit,
            description: description,
            quantity: quantity,
            history: history);

  factory ItemModel.fromFirebase(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ItemModel(
        id: snapshot.id,
        image: data['image'],
        name: data['name'],
        category: data['category'],
        unit: data['unit'],
        pricePerUnit: data['pricePerUnit'],
        description: data['description'],
        quantity: data['quantity'],
        history: data['history']);
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'category': category,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'description': description,
      'quantity': quantity,
      'history': history
    };
  }

  ItemModel copyWith({
    String? id,
    String? image,
    String? name,
    String? category,
    String? unit,
    double? pricePerUnit,
    String? description,
    int? quantity,
    List<dynamic>? history,
  }) {
    return ItemModel(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      history: history ?? this.history,
    );
  }
}
