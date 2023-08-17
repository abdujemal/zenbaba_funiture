import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/data_src/database_data_src.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/view/widget/add_review_sheet.dart';
import 'package:zenbaba_funiture/view/widget/left_line.dart';
import 'package:zenbaba_funiture/view/widget/order_item.dart';
import 'package:zenbaba_funiture/view/widget/review_item.dart';

import '../../data/model/cutomer_model.dart';
import '../../data/model/order_model.dart';
import '../../data/model/review_model.dart';
import 'add_cutomer.dart';

class CustomerDetailsPage extends StatefulWidget {
  final CustomerModel customerModel;
  const CustomerDetailsPage({super.key, required this.customerModel});

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  List<ReviewModel> reviews = [];
  List<OrderModel> orders = [];

  double dividerThickness = 0.6;
  double textPadding = 15;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  refresh() {
    mainConntroller
        .search(
      FirebaseConstants.reviews,
      "customerId",
      widget.customerModel.id!,
      SearchType.normalreviews,
    )
        .then((lst) {
      reviews = lst.map((e) => e as ReviewModel).toList();
      setState(() {});
    });

    mainConntroller
        .search(
      FirebaseConstants.orders,
      "customerId",
      widget.customerModel.id!,
      SearchType.normalOrder,
    )
        .then((lst) {
      orders = lst.map((e) => e as OrderModel).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Customer"),
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/back.svg',
              color: whiteColor,
              height: 21,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => AddCutomer(
                  customerModel: widget.customerModel,
                ),
              );
            },
            icon: SvgPicture.asset(
              'assets/edit.svg',
              color: whiteColor,
              height: 21,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Customer detail",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            keyVal(
              pl: textPadding,
              pr: textPadding,
              "Name",
              widget.customerModel.name,
            ),
            Divider(
              indent: 15,
              endIndent: 15,
              color: greyColor,
              thickness: dividerThickness,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  keyVal(
                    "Phone no",
                    widget.customerModel.phone,
                    pl: textPadding,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse(
                          "tel:${widget.customerModel.phone}",
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
            ),
            Divider(
              indent: 15,
              endIndent: 15,
              color: greyColor,
              thickness: dividerThickness,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  keyVal(
                    "Location",
                    "${widget.customerModel.sefer}\n${widget.customerModel.kk}",
                    pl: textPadding,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      if (await canLaunchUrl(
                        Uri.parse(widget.customerModel.location),
                      )) {
                        await launchUrl(
                          Uri.parse(widget.customerModel.location),
                        );
                      } else {
                        toast("The Url is not launchable.", ToastType.error);
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
            ),
            const SizedBox(
              height: 30,
            ),
            orders.isEmpty
                ? const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text("No Order"),
                    ),
                  )
                : Expanded(
                    child: section(
                      paddingh: 20,
                      mh: 0,
                      mb: 30,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            bottom: 3,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Orders",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  refresh();
                                },
                                child: const Icon(Icons.refresh),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              DateTime currentDay =
                                  DateTime.parse(orders[index].finishedDate);
                              DateTime lastDay = index > 0
                                  ? DateTime.parse(
                                      orders[index - 1].finishedDate)
                                  : DateTime.parse(orders[index].finishedDate);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (currentDay.compareTo(lastDay) >= 0)
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  if (currentDay.compareTo(lastDay) >= 0)
                                    Text(
                                      DateFormat("EEE / dd - MMMM").format(
                                        (DateTime.parse(
                                            orders[index].finishedDate)),
                                      ),
                                      style: TextStyle(color: textColor),
                                    ),
                                  if (currentDay.compareTo(lastDay) >= 0)
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  LeftLined(
                                    pt: 0,
                                    topHeight: 55,
                                    circleColor: primaryColor,
                                    isLast: index == orders.length - 1,
                                    onTap: () {},
                                    child: Column(
                                      children: [
                                        OrderItem(
                                          isFinished: orders[index].status ==
                                              OrderStatus.completed,
                                          isDelivery:
                                              orders[index].deliveryOption ==
                                                  DeliveryOption.delivery,
                                          orderModel: orders[index],
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 30),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: textColor,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  const Text(
                                                    "Comments",
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Get.bottomSheet(
                                                            AddReviewSheet(
                                                          customerId: widget
                                                              .customerModel
                                                              .id!,
                                                          orderId:
                                                              orders[index].id!,
                                                          customerName: widget
                                                              .customerModel
                                                              .name,
                                                        ));
                                                      },
                                                      child: Icon(
                                                        Icons.add_comment,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ...reviews
                                                  .where(
                                                    (element) =>
                                                        element.customerId ==
                                                            widget.customerModel
                                                                .id &&
                                                        element.orderId ==
                                                            orders[index].id,
                                                  )
                                                  .toList()
                                                  .map(
                                                    (e) => ReviewItem(
                                                      reviewModel: e,
                                                      showName: false,
                                                    ),
                                                  )
                                                  .toList(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
