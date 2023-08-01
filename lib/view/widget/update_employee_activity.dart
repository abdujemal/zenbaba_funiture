import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/data/model/order_model.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/view/widget/custom_btn.dart';
import 'package:zenbaba_funiture/view/widget/my_dropdown.dart';
import 'package:zenbaba_funiture/view/widget/sl_btn.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

class UpdateEmployeeActivity extends StatefulWidget {
  final EmployeeActivityModel employeeActivityModel;
  const UpdateEmployeeActivity({
    super.key,
    required this.employeeActivityModel,
  });

  @override
  State<UpdateEmployeeActivity> createState() => _UpdateEmployeeActivityState();
}

class _UpdateEmployeeActivityState extends State<UpdateEmployeeActivity> {
  bool morning = false;
  bool afternoon = false;

  bool isAdd = false;
  bool isRemove = false;

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  List<String> ordrs = [
    "Baby Bed(#194875)",
    "Chair(#892307)",
  ];

  String selectedOrder = "Baby Bed(#194875)";

  @override
  void initState() {
    super.initState();

    morning = widget.employeeActivityModel.morning;
    afternoon = widget.employeeActivityModel.afternoon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        color: mainBgColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat("EEE, MMM dd, yyyy").format(
              (DateTime.parse(widget.employeeActivityModel.date)),
            ),
            style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 18),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SpecialDropdown<String>(
                  value: selectedOrder,
                  list: ordrs,
                  title: "Orders",
                  onChange: (v) {
                    setState(() {
                      selectedOrder = v;
                    });
                  },
                  width: double.maxFinite,
                  margin: 0,
                  bgColor: backgroundColor,
                  titleColor: whiteColor,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRemove = !isRemove;
                    if (isAdd && isRemove) {
                      isAdd = false;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: isRemove
                        ? Border.all(
                            color: primaryColor,
                          )
                        : null,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAdd = !isAdd;
                    if (isAdd && isRemove) {
                      isRemove = false;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: isAdd
                        ? Border.all(
                            color: primaryColor,
                          )
                        : null,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: morning,
                    activeColor: primaryColor,
                    onChanged: (v) {
                      setState(() {
                        morning = v!;
                      });
                    },
                  ),
                  const Text("Morning")
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  Checkbox(
                    value: afternoon,
                    activeColor: primaryColor,
                    onChanged: (v) {
                      setState(() {
                        afternoon = v!;
                      });
                    },
                  ),
                  const Text("Afternon")
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                return mainConntroller.employeeActivityStatus.value ==
                        RequestState.loading
                    ? CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : CustomBtn(
                        btnState: Btn.filled,
                        color: primaryColor,
                        text: "Save",
                        tColor: backgroundColor,
                        onTap: () {
                          List<String> orders =
                              widget.employeeActivityModel.orders;
                          if (isRemove) {
                            orders = widget.employeeActivityModel.orders
                                .where((e) => e != selectedOrder)
                                .toList();
                          }
                          if (isAdd) {
                            orders = [
                              ...widget.employeeActivityModel.orders,
                              selectedOrder,
                            ];
                          }
                          mainConntroller.addUpdateEmployeeActivity(
                            widget.employeeActivityModel.copyWith(
                              orders: orders,
                              morning: morning,
                              afternoon: afternoon,
                            ),
                          );
                        },
                      );
              }),
              CustomBtn(
                btnState: Btn.filled,
                color: backgroundColor,
                text: "Cancel",
                onTap: () {
                  Get.back();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
