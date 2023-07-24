import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  ];

  List<String> values = [];

  @override
  void initState() {
    super.initState();
    values.add(widget.orderModel.productName);
    values.add(widget.orderModel.quantity.toString());
    values.add('${widget.orderModel.productPrice} Br');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 100,
        horizontal: 30,
      ),
      width: 250,
      height: 400,
      child: Scaffold(
        backgroundColor: mainBgColor,
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "ZENBABA\nFURNITURE",
                  style: TextStyle(fontSize: 26),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: const Color(0xffaf7c4d),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            heads.length,
                            (index) => Text(
                              heads[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: whiteColor,
                        child: Column(
                          children: [
                            const Divider(
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    values.length,
                                    (index) => Text(
                                          values[index],
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Divider(
                              color: Colors.grey,
                              endIndent: 0,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 80,
                                color: const Color(0xffaf7c4d),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: const Center(
                                  child: Text(
                                    "TOTAL",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: const Color(0xffaf7c4d),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        child: const Text(
                          "TOTAL",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                            '${widget.orderModel.productPrice * widget.orderModel.quantity} Br'),
                      ),
                      const SizedBox(
                        height: 110,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                            '${widget.orderModel.productPrice * widget.orderModel.quantity} Br'),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              color: whiteColor,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: QrImageView(
                        backgroundColor: Colors.white,
                        data: widget.orderModel.id!,
                        version: QrVersions.auto,
                        size: 120.0,
                        dataModuleStyle: const QrDataModuleStyle(
                          color: Colors.brown,
                        ),
                        eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square, color: Colors.brown)),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Order date: ${widget.orderModel.orderedDate.replaceAll("-", "/")}",
                        style: const TextStyle(
                          color: Colors.brown,
                        ),
                      ),
                      Text(
                        "End date: ${widget.orderModel.finishedDate.replaceAll("-", "/")}",
                        style: const TextStyle(
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                     const Text(
                        "Customer Name:",
                        style: TextStyle(color: Colors.brown),
                      ),
                      Text(
                        widget.orderModel.customerName,
                        style: const TextStyle(color: Colors.brown),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 180,
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: primaryColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: const [
                          Text("+251 9 96 99 46 90"),
                          Text("+251 9 84 98 32 21"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
