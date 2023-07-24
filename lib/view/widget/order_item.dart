import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/order_model.dart';
import '../Pages/add_order.dart';

class OrderItem extends StatefulWidget {
  final OrderModel orderModel;
  final bool isDelivery;
  final bool isFinished;
  const OrderItem({
    super.key,
    required this.orderModel,
    required this.isDelivery,
    required this.isFinished,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  File? file;
  bool isOverDue = false;
  int remainingDay = 0;

  setImageFile() async {
    if (widget.orderModel.imgUrl != "") {
      file = await displayImage(widget.orderModel.imgUrl,
          '${widget.orderModel.productSku}0', FirebaseConstants.products);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isOverDue = DateTime.parse(widget.orderModel.finishedDate)
            .difference(DateTime.now())
            .inDays <
        0;
    remainingDay = DateTime.parse(widget.orderModel.finishedDate)
        .difference(DateTime.now())
        .inDays;

    setImageFile();
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: isOverDue
                  ? widget.isFinished
                      ? primaryColor
                      : Colors.red
                  : primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 8,
                    offset: const Offset(0, 8))
              ]),
          child: ListTile(
            onTap: () => Get.to(
              () => AddOrder(orderModel: widget.orderModel),
            ),
            leading: widget.orderModel.imgUrl == ""
                ? const Icon(
                    Icons.more_horiz,
                    size: 50,
                  )
                : file != null
                    ? file!.path == ""
                        ? Container(
                            height: 50,
                            width: 50,
                            color: mainBgColor,
                            child: const Center(
                              child: Icon(
                                  Icons.wifi_tethering_error_rounded_rounded),
                            ),
                          )
                        : Image.file(
                            file!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                    : SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        ),
                      ),
            title: Text(
              widget.orderModel.productName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${widget.orderModel.productPrice} Br',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(
                  height: 5,
                ),
                if (!widget.isFinished)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: isOverDue ? primaryColor : Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      isOverDue
                          ? "$remainingDay".replaceAll("-", "") +
                              " days Overdue"
                          : remainingDay == 0
                              ? "Last day: Today"
                              : "$remainingDay days left",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  )
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    widget.isDelivery
                        ? "assets/delivery icon.svg"
                        : "assets/pickup icon.svg",
                    width: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.orderModel.deliveryOption,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 30,
          top: 0,
          child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: widget.isFinished
                      ? mainColor
                      : const Color.fromARGB(255, 146, 111, 99),
                  shape: BoxShape.circle),
              child: Icon(
                widget.isFinished ? Icons.check : Icons.more_horiz,
                size: 20,
              )),
        )
      ],
    );
  }
}
