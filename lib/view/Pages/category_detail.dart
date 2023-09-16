import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/products_gallery.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';

import '../../constants.dart';
import '../controller/main_controller.dart';
import '../widget/product_card.dart';
import 'add_product.dart';

class CategoryDetail extends StatefulWidget {
  final String categoryName;
  const CategoryDetail({required this.categoryName, super.key});

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  LSController lsController = Get.find<LSController>();

  // List<ProductModel> products = [];

  ScrollController controller = ScrollController();

  int pageNum = 2;

  @override
  void initState() {
    super.initState();
    controller.addListener(handleScrolling);
    mainConntroller.getProducts(
        category: widget.categoryName, quantity: numOfDocToGet);
  }

  void handleScrolling() {
    if (controller.offset >= controller.position.maxScrollExtent) {
      if (mainConntroller.getProductsStatus.value != RequestState.loading) {
        mainConntroller.getProducts(
          quantity: numOfDocToGet,
          category: widget.categoryName,
          isNew: false,
        );
        pageNum = pageNum + 1;
        print("${mainConntroller.products.length} products");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title(widget.categoryName),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          lsController.currentUser.value.priority != UserPriority.AdminView
              ? IconButton(
                  onPressed: () {
                    Get.to(
                      () => AddProduct(
                        category: widget.categoryName,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                )
              : SizedBox(),
          IconButton(
            onPressed: () {
              mainConntroller.getProducts(
                  category: widget.categoryName, quantity: numOfDocToGet);
            },
            icon: const Icon(
              Icons.refresh_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Obx(() {
        if (mainConntroller.products.isEmpty &&
            mainConntroller.getProductsStatus.value != RequestState.loading) {
          return Center(
            child: Text("No Products in ${widget.categoryName}."),
          );
        }
        if (mainConntroller.products.isEmpty &&
            mainConntroller.getProductsStatus.value == RequestState.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                  controller: controller,
                  itemCount: mainConntroller.products.length,
                  // physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      onClickImage: () {
                        Get.to(
                          () => ProductGallery(
                            products: mainConntroller.products,
                            selectedSku: mainConntroller.products[index].sku,
                          ),
                        );
                      },
                      productModel: mainConntroller.products[index],
                    );
                  }),
            ),
            mainConntroller.getProductsStatus.value == RequestState.loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : SizedBox(),
          ],
        );
      }),
    );
  }
}
