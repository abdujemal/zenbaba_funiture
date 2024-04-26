import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zenbaba_funiture/data/data_src/database_data_src.dart';
import 'package:zenbaba_funiture/data/model/cutomer_model.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/zigzag.dart';

import '../../constants.dart';
import '../../data/model/order_model.dart';

class OrderDialog extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDialog({
    super.key,
    required this.orderModel,
  });

  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  List<String> heads = [
    "PRODUCT",
    "QTY",
    "PRICE",
    "Total",
  ];

  double fontSize = 11;

  CustomerModel? customer;

  List<String> values = [];
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  late String startDate;
  late String finishDate;

  @override
  void initState() {
    super.initState();
    finishDate = DateFormat("MMM dd, yyyy")
        .format(DateTime.parse(widget.orderModel.finishedDate));
    startDate = DateFormat("MMM dd, yyyy")
        .format(DateTime.parse(widget.orderModel.orderedDate));
    values.add(widget.orderModel.productName);
    values.add(widget.orderModel.quantity.toString());
    values.add('${formatNumber(widget.orderModel.productPrice.round())} Br');
    values.add(
        '${formatNumber((widget.orderModel.productPrice * widget.orderModel.quantity).round())} Br');

    getCustomer();
  }

  getCustomer() {
    mainConntroller
        .search(
      FirebaseConstants.customers,
      'name',
      widget.orderModel.customerName,
      SearchType.normalCustomer,
    )
        .then(
      (value) {
        if (value.isNotEmpty) {
          print("works");
          customer = value.map((e) => e as CustomerModel).toList().first;
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      // width: 250,
      // height: 400,
      padding: const EdgeInsets.only(
        bottom: 15,
        top: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: mainBgColor,
      ),
      child: CustomPaint(
        // size: const Size(183.63, 364.59),
        size: Size(
            MediaQuery.of(context).size.width,
            ((MediaQuery.of(context).size.width - 10) * 1.9854598921744813)
                .toDouble()),
        painter: RPSCustomPainter(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  27,
                  50,
                  27,
                  90,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/logo.png',
                          height: 75,
                          width: 75,
                        ),
                        const Spacer(),
                        Text(
                          "Order No #${widget.orderModel.id}",
                          style: TextStyle(
                            color: mainBgColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        heads.length,
                        (index) => Flexible(
                          flex: index == 0 ? 2 : 1,
                          fit: FlexFit.tight,
                          child: Text(
                            heads[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: mainBgColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        values.length,
                        (index) => Flexible(
                          flex: index == 0 ? 2 : 1,
                          fit: FlexFit.tight,
                          child: Text(
                            values[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: mainBgColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      color: backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "TOTAL",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // color: t,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              values.last,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                // color: t,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      color: Colors.black12,
                      width: MediaQuery.of(context).size.width - 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Prepayed: ${formatNumber(widget.orderModel.payedPrice.round())} Br",
                                        style: TextStyle(
                                          color: mainBgColor,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "Unpayed: ${formatNumber(((widget.orderModel.productPrice * widget.orderModel.quantity) - widget.orderModel.payedPrice).round())} Br",
                                        style: TextStyle(
                                          color: mainBgColor,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "Delivery type: ${widget.orderModel.deliveryOption}",
                                        style: TextStyle(
                                          color: mainBgColor,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "Customer name: ${customer != null ? customer!.name : "..."}",
                                        style: TextStyle(
                                          color: mainBgColor,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "Customer no: ${customer != null ? customer!.phone : "..."}",
                                        style: TextStyle(
                                          color: mainBgColor,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                QrImageView(
                                  backgroundColor: Colors.white12,
                                  data: widget.orderModel.id!,
                                  version: QrVersions.auto,
                                  size: 80.0,
                                  dataModuleStyle: QrDataModuleStyle(
                                    color: mainBgColor,
                                  ),
                                  eyeStyle: QrEyeStyle(
                                    eyeShape: QrEyeShape.square,
                                    color: mainBgColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Customer address: ${customer != null ? "${customer!.kk}, ${customer!.sefer}" : "..."}",
                              style: TextStyle(
                                color: mainBgColor,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "$startDate     -     $finishDate",
                      style: TextStyle(
                        backgroundColor: const Color(0xfff3f3f3),
                        color: mainBgColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer()
                  ],
                ),
              ),
              const Positioned(
                bottom: 0,
                right: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          "0930331313",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "0996994690",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
