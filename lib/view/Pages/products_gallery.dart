import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/add_product.dart';

import '../../constants.dart';
import '../../data/model/product_model.dart';

class ProductGallery extends StatefulWidget {
  final List<ProductModel> products;
  final String? selectedSku;
  const ProductGallery({
    super.key,
    required this.products,
    required this.selectedSku,
  });

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  List<Map<String, Object?>> images = [];

  Map<String, Object?>? currentImage;

  @override
  void initState() {
    super.initState();
    if (widget.products.isNotEmpty) {
      for (ProductModel model in widget.products) {
        int i = 0;
        for (String url in model.images) {
          images.add({
            "url": url,
            'id': "${model.sku}$i",
            'sku': model.sku,
            'name': model.name,
            'price': model.price,
            'file': null,
            'model': model,
          });
          i++;
        }
      }
    } else {}

    if (widget.selectedSku != null) {
      currentImage = images.where(
        (element) {
          return element["sku"].toString().contains(widget.selectedSku!);
        },
      ).toList()[0];
    } else {}

    // setImageFile();
  }

  // setImageFile() async {
  //   int i = 0;
  //   for (var image in images) {
  //     File? file = await displayImage(
  //       image["url"].toString(),
  //       image["sku"].toString(),
  //       "${FirebaseConstants.products}/${widget.productModel.sku}",
  //     );
  //     images[i]['file'] = file;
  //     if (mounted) {
  //       setState(() {});
  //     }
  //     i++;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: PageView.builder(
        controller: PageController(initialPage: images.indexOf(currentImage!)),
        physics: const BouncingScrollPhysics(),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: title(images[index]['name'].toString()),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              actions: [
                RotatedBox(
                  quarterTurns: 2,
                  child: ClipPath(
                    clipper: BestSellerClipper(),
                    child: Container(
                      color: primaryColor,
                      padding: const EdgeInsets.only(
                          left: 10, top: 5, right: 20, bottom: 5),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Text(
                            "${images[index]['price']} Br",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: FutureBuilder(
                future: displayImage(
                  images[index]["url"].toString(),
                  images[index]["id"].toString(),
                  "${FirebaseConstants.products}/${images[index]["sku"].toString()}",
                ),
                builder: (context, snap) {
                  return snap.data != null
                      ? GestureDetector(
                          onTap: () {
                            Get.to(
                              () => AddProduct(
                                productModel:
                                    images[index]["model"] as ProductModel,
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: snap.data!.path != ""
                                ? BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: FileImage(
                                        snap.data!,
                                      ),
                                    ),
                                  )
                                : null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                snap.data!.path == ""
                                    ? const Text("No Network.")
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                }),
          );
        },
      ),
    );
  }
}

class BestSellerClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();

    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
