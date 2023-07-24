import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../constants.dart';
import '../../data/model/product_model.dart';

class OrderProductCard extends StatefulWidget {
  final ProductModel productModel;
  const OrderProductCard({super.key, required this.productModel});

  @override
  State<OrderProductCard> createState() => _OrderProductCardState();
}

class _OrderProductCardState extends State<OrderProductCard> {
  File? file;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  loadImage() async {
    if (widget.productModel.images.isNotEmpty) {
      file = await displayImage(widget.productModel.images[0],
          '${widget.productModel.sku}0', FirebaseConstants.products);
      setState(() {});
    } else {
      file = File("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          file != null
              ? file!.path == ""
                  ? const Icon(
                      Icons.more_horiz,
                      size: 50,
                    )
                  : Image.file(
                      file!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
              : Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
          const SizedBox(
            width: 20,
          ),
          Text(
            widget.productModel.name,
            style: const TextStyle(
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
