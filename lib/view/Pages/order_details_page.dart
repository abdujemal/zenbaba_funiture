import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/data/data_src/database_data_src.dart';
import 'package:zenbaba_funiture/data/model/order_model.dart';
import 'package:zenbaba_funiture/data/model/review_model.dart';
import 'package:zenbaba_funiture/view/Pages/add_order.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/view/widget/order_dialog.dart';
import 'package:zenbaba_funiture/view/widget/review_item.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

import '../../constants.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetailsPage({super.key, required this.orderModel});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  double dividerThickness = 0.6;
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  LSController lsController = Get.find<LSController>();

  List<ReviewModel> reviews = [];

  late String selectedOrderStatus;

  @override
  void initState() {
    super.initState();

    selectedOrderStatus = widget.orderModel.status;
    setState(() {});

    // geting all reviews of this order
    mainConntroller
        .search(
      FirebaseConstants.reviews,
      'orderId',
      widget.orderModel.id!,
      SearchType.normalreviews,
    )
        .then((lst) {
      reviews = lst.map((e) => e as ReviewModel).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Order #${widget.orderModel.id}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                OrderDialog(
                  orderModel: widget.orderModel,
                ),
                barrierColor: const Color.fromARGB(200, 0, 0, 0),
              );
            },
            icon: const Icon(Icons.qr_code),
          ),
          UserPriority.canEditOrder(lsController.currentUser.value.priority)
              ? IconButton(
                  onPressed: () {
                    Get.to(
                      () => AddOrder(
                        orderModel: widget.orderModel,
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    'assets/edit.svg',
                    color: whiteColor,
                    height: 20,
                    width: 20,
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            section(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Product detail",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Spacer(),
                    widget.orderModel.withReciept
                        ? Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: primaryColor)),
                            child: Text(
                              "With Reciept",
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FutureBuilder(
                    future: displayImage(
                        widget.orderModel.imgUrl,
                        '${widget.orderModel.productSku}0',
                        "${FirebaseConstants.products}/${widget.orderModel.productSku}"),
                    builder: (context, snapshot) {
                      return widget.orderModel.imgUrl == ""
                          ? const Icon(
                              Icons.more_horiz,
                              size: 130,
                            )
                          : snapshot.data != null
                              ? snapshot.data!.path == ""
                                  ? Container(
                                      height: 130,
                                      width: 130,
                                      color: mainBgColor,
                                      child: const Center(
                                        child: Icon(Icons
                                            .wifi_tethering_error_rounded_rounded),
                                      ),
                                    )
                                  : Image.file(
                                      snapshot.data!,
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    )
                              : kIsWeb
                                  ? CachedNetworkImage(
                                      imageUrl: widget.orderModel.imgUrl,
                                      height: 130,
                                      width: 130,
                                    )
                                  : SizedBox(
                                      height: 130,
                                      width: 130,
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
                  height: 6,
                ),
                keyVal(
                  "Product",
                  widget.orderModel.productName,
                ),
                Divider(
                  color: greyColor,
                  thickness: dividerThickness,
                ),
                keyVal(
                  "Color",
                  widget.orderModel.color,
                ),
                Divider(
                  color: greyColor,
                  thickness: dividerThickness,
                ),
                keyVal(
                  "Size",
                  widget.orderModel.size,
                ),
                Divider(
                  color: greyColor,
                  thickness: dividerThickness,
                ),
                keyVal(
                  "Description",
                  widget.orderModel.productDescription,
                ),
                Divider(
                  color: greyColor,
                  thickness: dividerThickness,
                ),
                keyVal(
                  "Price",
                  UserPriority.canSeeOrderPrice(
                          lsController.currentUser.value.priority)
                      ? "#### br"
                      : formatNumber(widget.orderModel.productPrice.round()),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            section(
              paddingh: 28,
              children: [
                Row(
                  children: [
                    const Text(
                      "Order detail",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    SpecialDropdown(
                      title: '',
                      margin: 0,
                      noTitle: true,
                      value: selectedOrderStatus,
                      list: OrderStatus.list,
                      onChange: (value) {
                        if (UserPriority.canEditOrderStatus(
                            lsController.currentUser.value.priority)) {
                          mainConntroller.updateOrder(
                            widget.orderModel.copyWith(status: value),
                            selectedOrderStatus,
                          );
                          setState(() {
                            selectedOrderStatus = value!;
                          });
                        }
                      },
                      width: 140,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                keyVal(
                  "Workers",
                  widget.orderModel.employees.isEmpty
                      ? "No Workers"
                      : widget.orderModel.employees.join("\n"),
                  pl: 0,
                ),
                Divider(
                  color: greyColor,
                  thickness: dividerThickness,
                ),
                keyVal(
                  "Item used",
                  widget.orderModel.itemsUsed.isEmpty
                      ? "No Items used"
                      : widget.orderModel.itemsUsed.join("\n"),
                  pl: 0,
                ),
                Divider(
                  color: greyColor,
                  thickness: dividerThickness,
                ),
                Row(
                  children: [
                    keyVal(
                      "Order date",
                      DateFormat("EEE/MMM-dd").format(
                        DateTime.parse(
                          widget.orderModel.orderedDate,
                        ),
                      ),
                      pl: 0,
                    ),
                    const Spacer(),
                    keyVal(
                      "Delivery date",
                      DateFormat("EEE/MMM-dd").format(
                        DateTime.parse(
                          widget.orderModel.finishedDate,
                        ),
                      ),
                      pl: 0,
                    ),
                  ],
                ),
                Divider(
                  color: greyColor,
                  thickness: dividerThickness,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
            UserPriority.canEditOrder(lsController.currentUser.value.priority)
                ? section(
                    paddingh: 28,
                    children: [
                      const Text(
                        "Customer detail",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      keyVal(
                        "Name",
                        widget.orderModel.customerName,
                        pl: 0,
                      ),
                      Divider(
                        color: greyColor,
                        thickness: dividerThickness,
                      ),
                      Row(
                        children: [
                          keyVal(
                            "Phone no",
                            widget.orderModel.phoneNumber,
                            pl: 0,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                  "tel:${widget.orderModel.phoneNumber}",
                                ),
                              );
                            },
                            icon: SvgPicture.asset(
                              'assets/call.svg',
                              color: textColor,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: greyColor,
                        thickness: dividerThickness,
                      ),
                      widget.orderModel.bankAccount != null
                          ? keyVal(
                              "Bank Account",
                              widget.orderModel.bankAccount ?? "",
                              pl: 0,
                            )
                          : const SizedBox(),
                      widget.orderModel.bankAccount != null
                          ? Divider(
                              color: greyColor,
                              thickness: dividerThickness,
                            )
                          : const SizedBox(),
                      Row(
                        children: [
                          keyVal(
                            "Location",
                            "${widget.orderModel.sefer}\n${widget.orderModel.kk}",
                            pl: 0,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {
                              if (await canLaunchUrl(
                                Uri.parse(widget.orderModel.location),
                              )) {
                                await launchUrl(
                                  Uri.parse(widget.orderModel.location),
                                );
                              } else {
                                toast("The Url is not launchable.",
                                    ToastType.error);
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/pickup.svg',
                              color: textColor,
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: greyColor,
                        thickness: dividerThickness,
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )
                : const SizedBox(),
            reviews.isEmpty
                ? const SizedBox(
                    height: 40,
                  )
                : section(
                    paddingh: 20,
                    children: [
                      const Text(
                        "Review",
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ...List.generate(
                        reviews.length,
                        (index) => ReviewItem(
                          reviewModel: reviews[index],
                          showName: true,
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
