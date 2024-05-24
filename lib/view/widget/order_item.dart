import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
  final bool showPrice;
  const OrderItem({
    super.key,
    required this.orderModel,
    required this.isDelivery,
    required this.isFinished,
    required this.showPrice,
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

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          InkWell(
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
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: mainBgColor,
                borderRadius: BorderRadius.circular(15),
                border: widget.orderModel.status == OrderStatus.Delivered
                    ? Border.all(
                        color: primaryColor,
                      )
                    : isOverDue
                        ? Border.all(
                            color: Colors.red,
                          )
                        : null,
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
                          "${FirebaseConstants.products}/${widget.orderModel.productSku}"),
                      builder: (context, snapshot) {
                        return widget.orderModel.imgUrl.isEmpty
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
                                : kIsWeb
                                    ? CachedNetworkImage(
                                        imageUrl: widget.orderModel.imgUrl,
                                        height: 70,
                                        width: 70,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            widget.orderModel.productName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          widget.showPrice
                              ? "${formatNumber(widget.orderModel.productPrice.round())} br"
                              : "#### br",
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
                            ),
                            const Spacer(),
                            if (widget.orderModel.status ==
                                    OrderStatus.completed &&
                                remainingDay != 0)
                              Text(
                                isOverDue
                                    ? "${remainingDay.abs()} days late"
                                    : "$remainingDay days left",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            if (widget.orderModel.status ==
                                    OrderStatus.completed &&
                                remainingDay == 0)
                              Text(
                                "Today",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            if (widget.orderModel.status == OrderStatus.ready)
                              Text(
                                "Ready",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.orderModel.withReciept
              ? const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      right: 5,
                    ),
                    child: Icon(
                      Icons.receipt,
                      size: 20,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
