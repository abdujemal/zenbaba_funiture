import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zenbaba_funiture/view/Pages/order_details_page.dart';
import '../../constants.dart';
import '../../data/model/order_model.dart';

class OrderItem extends StatefulWidget {
  final OrderModel orderModel;
  final bool isDelivery;
  final bool isFinished;
  final bool noAction;
  const OrderItem({
    super.key,
    required this.orderModel,
    required this.isDelivery,
    required this.isFinished,
    this.noAction = false,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  // File? file;
  bool isOverDue = false;
  int remainingDay = 0;

  @override
  Widget build(BuildContext context) {
    isOverDue = DateTime.parse(widget.orderModel.finishedDate)
            .difference(DateTime.now())
            .inDays <
        0;
    remainingDay = DateTime.parse(widget.orderModel.finishedDate)
        .difference(DateTime.now())
        .inDays;

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: InkWell(
          onTap: widget.noAction
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsPage(
                        orderModel: widget.orderModel,
                      ),
                    ),
                  );
                },
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: mainBgColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 8,
                  spreadRadius: 4,
                  offset: const Offset(0, 0),
                )
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FutureBuilder(
                    future: displayImage(
                        widget.orderModel.imgUrl,
                        '${widget.orderModel.productSku}0',
                        FirebaseConstants.products),
                    builder: (context, snapshot) {
                      return widget.orderModel.imgUrl == ""
                          ? const Icon(
                              Icons.more_horiz,
                              size: 70,
                            )
                          : snapshot.data != null
                              ? snapshot.data!.path == ""
                                  ? Container(
                                      height: 70,
                                      width: 70,
                                      color: mainBgColor,
                                      child: const Center(
                                        child: Icon(Icons
                                            .wifi_tethering_error_rounded_rounded),
                                      ),
                                    )
                                  : Image.file(
                                      snapshot.data!,
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    )
                              : SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: whiteColor,
                                    ),
                                  ),
                                );
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: constraints.maxWidth - 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.orderModel.productName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${widget.orderModel.productPrice} br",
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            widget.isDelivery
                                ? "assets/delivery icon.svg"
                                : "assets/pickup icon.svg",
                            width: 23,
                            height: 23,
                            color: textColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.orderModel.deliveryOption,
                            style: TextStyle(
                              color: textColor,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
