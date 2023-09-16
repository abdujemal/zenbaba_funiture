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
          FutureBuilder(
              future: displayImage(
                widget.productModel.images[0],
                '${widget.productModel.sku}0',
                "${FirebaseConstants.products}/${widget.productModel.sku}",
              ),
              builder: (context, snap) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: snap.data == null
                      ? SizedBox(
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
