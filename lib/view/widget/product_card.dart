import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';

import '../../constants.dart';
import '../../data/model/product_model.dart';
import '../Pages/add_product.dart';
import '../Pages/search_page.dart';
import '../controller/main_controller.dart';

class ProductCard extends StatefulWidget {
  final ProductModel productModel;
  final void Function() onClickImage;
  const ProductCard(
      {super.key, required this.productModel, required this.onClickImage});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  LSController lsController = Get.find<LSController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
      child: InkWell(
        onLongPress: () {
          if (!UserPriority.canUpdateProduct(
              lsController.currentUser.value.priority)) {
            return;
          }
          Get.to(
            () => AddProduct(
              productModel: widget.productModel,
              isDuplicate: true,
            ),
          );
        },
        onTap: () {
          Get.to(
            () => AddProduct(
              productModel: widget.productModel,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: mainBgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(70),
                  blurRadius: 8,
                  offset: const Offset(-5, 5))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      widget.productModel.images.isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: backgroundColor,
                              ),
                              width: 110,
                              height: 110,
                              child: Icon(
                                Icons.image,
                                color: primaryColor,
                                size: 100,
                              ),
                            )
                          : FutureBuilder(
                              future: displayImage(
                                widget.productModel.images[0],
                                '${widget.productModel.sku}0',
                                "${FirebaseConstants.products}/${widget.productModel.sku}",
                              ),
                              builder: (context, snap) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: snap.data == null
                                      ? kIsWeb
                                          ? InkWell(
                                              onTap: widget.onClickImage,
                                              child: Ink(
                                                child: CachedNetworkImage(
                                                  imageUrl: widget
                                                      .productModel.images[0],
                                                  width: 110,
                                                  height: 110,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 110,
                                              width: 110,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: primaryColor,
                                                ),
                                              ),
                                            )
                                      : snap.data!.path == ""
                                          ? Container(
                                              height: 110,
                                              width: 110,
                                              color: mainBgColor,
                                              child: const Center(
                                                child: Text("No Network"),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: widget.onClickImage,
                                              child: Ink(
                                                child: Image.file(
                                                  snap.data!,
                                                  width: 110,
                                                  height: 110,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                );
                              }),
                      widget.productModel.images.length > 1
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: Card(
                                color: primaryColor,
                                shape: const CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "+${widget.productModel.images.length - 1}"),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productModel.name,
                          style: const TextStyle(fontSize: 22),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${lsController.currentUser.value.priority == UserPriority.WorkShopManager ? "????" : formatNumber(widget.productModel.price.round())} Br',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: primaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.productModel.sku,
                          style: TextStyle(fontSize: 20, color: textColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.productModel.description,
                style: const TextStyle(
                  fontSize: 17,
                ),
                overflow: TextOverflow.clip,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Size: ${widget.productModel.size}"),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      widget.productModel.tags.length,
                      (index) => GestureDetector(
                        onTap: () {
                          mainConntroller.searchProducts(
                              "name", "#${widget.productModel.tags[index]}", 5);
                          Get.to(() => SearchPage(
                                path: FirebaseConstants.products,
                                tag: "#${widget.productModel.tags[index]}",
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "#${widget.productModel.tags[index]} ",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 125, 196, 255)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
