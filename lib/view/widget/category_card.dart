import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/product_category_model.dart';
import '../Pages/category_detail.dart';

class CategoryCard extends StatelessWidget {
  final ProductCategoryModel productCategoryModel;
  const CategoryCard({
    super.key,
    required this.productCategoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => CategoryDetail(
            categoryName: productCategoryModel.name,
          ),
        );
      },
      child: Card(
        shadowColor: Colors.black,
        elevation: 14,
        color: mainBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            //     child: Text(
            //       '${productCategoryModel.quantity}',
            //       style: TextStyle(
            //         color: whiteColor,
            //         fontSize: 17,
            //       ),
            //     ),
            //   ),
            // ),
          
            productCategoryModel.name != ProductCategory.Custom
                ? Image.asset(
                    productCategoryModel.assetImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.more_horiz,
                    size: 80,
                  ),
            
            Text(
              productCategoryModel.name,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
