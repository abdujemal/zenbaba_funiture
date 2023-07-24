
import '../../domain/entity/product_category_entity.dart';

class ProductCategoryModel extends ProductCategoryEntity {
  final String name;
  final int quantity;
  final String assetImage;
  const ProductCategoryModel({
    required this.name,
    required this.assetImage,
    required this.quantity
  }) : super(
          assetImage: assetImage,
          name: name,
          quantity: quantity
        );

  ProductCategoryModel copyWith({
    String? name,
    int? quantity,
    String? assetImage,
  }) {
    return ProductCategoryModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      assetImage: assetImage ?? this.assetImage,
    );
  }
}
