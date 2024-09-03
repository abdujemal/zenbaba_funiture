import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../data/model/product_model.dart';

class OrderProductCard extends StatefulWidget {
  final ProductModel productModel;
  const OrderProductCard({super.key, required this.productModel});

  @override
  State<OrderProductCard> createState() => _OrderProductCardState();
}

class _OrderProductCardState extends State<OrderProductCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          widget.productModel.images.isEmpty
              ? Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: mainBgColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                )
              : FutureBuilder(
                  future: displayImage(
                    widget.productModel.images[0],
                    '${widget.productModel.sku}0',
                    "${FirebaseConstants.products}/${widget.productModel.sku}",
                  ),
                  builder: (context, snap) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: snap.data == null
                              ? kIsWeb
                                  ? CachedNetworkImage(
                                      width: 50,
                                      height: 50,
                                      imageUrl: widget.productModel.images[0],
                                    )
                                  : SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(
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
                                  : Image.file(
                                      snap.data!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                        Positioned.fill(
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromARGB(136, 0, 0, 0),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                widget.productModel.sku,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.productModel.name,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text("Size: ${widget.productModel.size}")
            ],
          )
        ],
      ),
    );
  }
}
