import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/view/widget/left_line.dart';
import 'package:zenbaba_funiture/view/widget/update_employee_activity.dart';

class EmployeeActivityItem extends StatefulWidget {
  final bool isLast;
  final EmployeeActivityModel employeeActivityModel;
  final bool isDiffenrentMonth;

  const EmployeeActivityItem(
      {super.key,
      required this.employeeActivityModel,
      required this.isLast,
      required this.isDiffenrentMonth});

  @override
  State<EmployeeActivityItem> createState() => _EmployeeActivityItemState();
}

class _EmployeeActivityItemState extends State<EmployeeActivityItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String morning =
        widget.employeeActivityModel.morning ? "Present" : "Absent";
    String afternoon =
        widget.employeeActivityModel.afternoon ? "Present" : "Absent";

    return Column(
      children: [
        if (widget.isDiffenrentMonth)
          const SizedBox(
            height: 5,
          ),
        if (widget.isDiffenrentMonth)
          Chip(
            label: Text(
              DateFormat("MMMM").format(
                (DateTime.parse(widget.employeeActivityModel.date)),
              ),
            ),
          ),
        if (widget.isDiffenrentMonth)
          const SizedBox(
            height: 5,
          ),
        LeftLined(
          circleColor: widget.employeeActivityModel.orders.isEmpty
              ? Colors.red
              : primaryColor,
          onTap: () {
            Get.bottomSheet(
              UpdateEmployeeActivity(
                employeeActivityModel: widget.employeeActivityModel,
              ),
            );
          },
          isLast: widget.isLast,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    DateFormat("EEE, MMM dd, yyyy").format(
                      (DateTime.parse(widget.employeeActivityModel.date)),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w200),
                  ),
                  if (widget.employeeActivityModel.orders.isNotEmpty)
                    ...List.generate(
                      widget.employeeActivityModel.orders.length,
                      (index) => Text(
                        widget.employeeActivityModel.orders[index],
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  if (widget.employeeActivityModel.orders.isEmpty)
                    Center(
                      child: Text(
                        "...",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  if (widget.employeeActivityModel.itemsUsed.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Item used"),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: List.generate(
                              widget.employeeActivityModel.itemsUsed.length,
                              (index) => Text(
                                widget.employeeActivityModel.itemsUsed[index],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    "morning & afternoon",
                    style: TextStyle(color: primaryColor),
                  ),
                  Text(
                    "$morning | $afternoon",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.employeeActivityModel.payment > 0.5)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: primaryColor, width: 2),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.arrow_outward,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "${widget.employeeActivityModel.payment.round()} br",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
              const Spacer()
            ],
          ),
        )
        // Stack(
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         Get.bottomSheet(
        //           UpdateEmployeeActivity(
        //             employeeActivityModel: widget.employeeActivityModel,
        //           ),
        //         );
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //           border: Border(
        //             left: widget.isLast
        //                 ? BorderSide.none
        //                 : BorderSide(
        //                     color: primaryColor,
        //                     width: 1.5,
        //                   ),
        //           ),
        //         ),
        //         margin: const EdgeInsets.only(left: 2.7),
        //         child: Container(
        //           margin: const EdgeInsets.symmetric(horizontal: 20),
        //           padding: const EdgeInsets.symmetric(vertical: 10),
        //           decoration: BoxDecoration(
        //             border: Border(
        //               bottom: BorderSide(
        //                 color: whiteColor,
        //                 width: .2,
        //               ),
        //             ),
        //           ),
        //           child: Row(
        //             children: [
        //               Column(
        //                 children: [
        //                   Text(
        //                     DateFormat("EEE, MMM dd, yyyy").format(
        //                       (DateTime.parse(
        //                           widget.employeeActivityModel.date)),
        //                     ),
        //                     style: const TextStyle(fontWeight: FontWeight.w200),
        //                   ),
        //                   if (widget.employeeActivityModel.orders.isNotEmpty)
        //                     ...List.generate(
        //                       widget.employeeActivityModel.orders.length,
        //                       (index) => Text(
        //                         widget.employeeActivityModel.orders[index],
        //                         style: TextStyle(color: primaryColor),
        //                       ),
        //                     ),
        //                   if (widget.employeeActivityModel.orders.isEmpty)
        //                     Center(
        //                       child: Text(
        //                         "...",
        //                         style: TextStyle(color: primaryColor),
        //                       ),
        //                     ),
        //                   if (widget.employeeActivityModel.itemsUsed.isNotEmpty)
        //                     const Text("Item used"),
        //                   if (widget.employeeActivityModel.itemsUsed.isNotEmpty)
        //                     ...List.generate(
        //                       widget.employeeActivityModel.itemsUsed.length,
        //                       (index) => Text(
        //                         widget.employeeActivityModel.itemsUsed[index],
        //                       ),
        //                     ),
        //                 ],
        //               ),
        //               const Spacer(),
        //               Column(
        //                 children: [
        //                   Text(
        //                     "morning & afternoon",
        //                     style: TextStyle(color: primaryColor),
        //                   ),
        //                   Text(
        //                     "$morning | $afternoon",
        //                     style: const TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   )
        //                 ],
        //               ),
        //               const Spacer()
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     if (widget.isLast)
        //       Positioned(
        //         left: 2.7,
        //         child: Container(
        //           height: 35,
        //           width: 1.5,
        //           decoration: BoxDecoration(
        //             color: primaryColor,
        //           ),
        //         ),
        //       ),
        //     Positioned(
        //       top: 30,
        //       child: Container(
        //         height: 7,
        //         width: 7,
        //         decoration: BoxDecoration(
        //           color: widget.employeeActivityModel.orders.isEmpty
        //               ? Colors.red
        //               : primaryColor,
        //           shape: BoxShape.circle,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
