import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String? id;
  final String? image;
  final String name;
  final String category;
  final String unit;
  final double pricePerUnit;
  final String description;
  final int quantity;
  final List<dynamic> history;
  const ItemEntity({
    required this.id,
    required this.image,
    required this.name,
    required this.category,
    required this.unit,
    required this.pricePerUnit,
    required this.description,
    required this.quantity,
    required this.history,
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
        history
      ];
}
