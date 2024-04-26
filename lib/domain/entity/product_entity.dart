// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../data/model/product_model.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String name;
  final String sku;
  final String size;
  final String category;
  final String description;
  final String? pdfLink;
  final double? labourCost;
  final double? overhead;
  final double? profit;
  final List<dynamic> images;
  final double price;
  final List<dynamic> tags;
  final List<RawMaterial> rawMaterials;
  final List<String> rawMaterialIds;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.size,
    required this.category,
    required this.description,
    required this.pdfLink,
    required this.labourCost,
    required this.overhead,
    required this.profit,
    required this.images,
    required this.price,
    required this.tags,
    required this.rawMaterials,
    required this.rawMaterialIds,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        category,
        description,
        pdfLink,
        images,
        price,
        tags,
        size,
        rawMaterials,
        labourCost,
        overhead,
        profit,
        rawMaterialIds,
      ];
}
