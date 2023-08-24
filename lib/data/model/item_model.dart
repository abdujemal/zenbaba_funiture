// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:zenbaba_funiture/data/model/time_line_model.dart';

import '../../domain/entity/item_entity.dart';

class ItemModel extends ItemEntity {
  final String? id;
  final String? image;
  final String name;
  final String category;
  final String unit;
  final double pricePerUnit;
  final String description, lastUsedFor;
  final int quantity;
  final List<TimeLineModel> timeLine;
  const ItemModel({
    required this.lastUsedFor,
    required this.timeLine,
    required this.id,
    required this.image,
    required this.name,
    required this.category,
    required this.unit,
    required this.pricePerUnit,
    required this.description,
    required this.quantity,
  }) : super(
          id: id,
          image: image,
          name: name,
          category: category,
          unit: unit,
          pricePerUnit: pricePerUnit,
          description: description,
          quantity: quantity,
          timeLine: timeLine,
          lastUsedFor: lastUsedFor,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'name': name,
      'category': category,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'description': description,
      'quantity': quantity,
      "lastUsedFor": lastUsedFor,
      'timeLine': timeLine.map((x) => x.toMap()).toList(),
    };
  }

  factory ItemModel.fromFirebase(DocumentSnapshot snap) {
    final map = snap.data() as Map;
    return ItemModel(
      id: snap.id,
      image: map['image'] != null ? map['image'] as String : null,
      name: map['name'] as String,
      category: map['category'] as String,
      unit: map['unit'] as String,
      pricePerUnit: map['pricePerUnit'] as double,
      description: map['description'] as String,
      lastUsedFor: map["lastUsedFor"] ?? "",
      quantity: map['quantity'] as int,
      timeLine: map['timeLine'] != null
          ? List<TimeLineModel>.from(
              (map['timeLine'] as List).map<TimeLineModel>(
                (x) => TimeLineModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  ItemModel copyWith({
    String? id,
    String? image,
    String? name,
    String? category,
    String? unit,
    double? pricePerUnit,
    String? description,
    String? lastUsedFor,
    int? quantity,
    List<TimeLineModel>? timeLine,
  }) {
    return ItemModel(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      lastUsedFor: lastUsedFor ?? this.lastUsedFor,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      timeLine: timeLine ?? this.timeLine,
    );
  }
}
