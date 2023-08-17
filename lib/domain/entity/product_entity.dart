// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String name;
  final String sku;
  final String size;
  final String category;
  final String description;
  final List<dynamic> images;
  final double price;
  final List<dynamic> tags;
  const ProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.description,
    required this.images,
    required this.price,
    required this.tags,
    required this.size,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        category,
        description,
        images,
        price,
        tags,
        size,
      ];
}
