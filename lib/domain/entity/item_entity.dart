import 'package:equatable/equatable.dart';

import '../../data/model/time_line_model.dart';

class ItemEntity extends Equatable {
  final String? id;
  final String? image;
  final String name;
  final String category;
  final String unit;
  final double pricePerUnit;
  final String description, lastUsedFor;
  final int quantity;
  final List<TimeLineModel> timeLine;

  const ItemEntity({
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
  });

  @override
  List<Object?> get props => [
        id,
        image,
        name,
        category,
        unit,
        category,
        unit,
        pricePerUnit,
        description,
        quantity,
        timeLine,
        lastUsedFor,
      ];
}
