import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/data_src/database_data_src.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/data/model/order_model.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/view/widget/custom_btn.dart';
import 'package:zenbaba_funiture/view/widget/sl_input.dart';

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

  OrderModel? selectedOrder;

  TextEditingController _orderTc = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _orderTc.dispose();
  }

  @override
  void initState() {
    super.initState();

    morning = widget.employeeActivityModel.morning;
    afternoon = widget.employeeActivityModel.afternoon;
  }

  Widget orderSearch() {
    return RawAutocomplete<OrderModel>(
      initialValue: TextEditingValue(text: _orderTc.text),
      displayStringForOption: (option) {
        return "${option.productName}(#${option.id})";
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<OrderModel>.empty();
        } else {
          if (mainConntroller.getOrdersStatus.value != RequestState.loading) {
            final lst = await mainConntroller.search(
              FirebaseConstants.orders,
              "productName",
              textEditingValue.text,
              SearchType.normalOrder,
              key2: 'status',
              val2: OrderStatus.proccessing,
            );

            return lst.map((e) => e as OrderModel);
          } else {
            return const Iterable<OrderModel>.empty();
          }
        }
      },
      onSelected: (OrderModel orderModel) {
        setState(() {
          selectedOrder = orderModel;
        });
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return SLInput(
          title: "Search Order",
          hint: '...',
          inputColor: whiteColor,
          otherColor: whiteColor,
          bgColor: backgroundColor,
          keyboardType: TextInputType.text,
          controller: textEditingController,
          isOutlined: true,
          focusNode: focusNode,
          onChanged: (val) {
            _orderTc.text = val;
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          void Function(OrderModel) onSelected, Iterable<OrderModel> options) {
        return Material(
          color: backgroundColor,
          child: Obx(() {
            return mainConntroller.getCustomersStatus.value ==
                    RequestState.loading
                ? Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: options.map((opt) {
                          return InkWell(
                            onTap: () {
                              onSelected(opt);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 23),
                              child: Card(
                                child: Container(
                                  color: mainBgColor,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  child: Text("${opt.productName}(#${opt.id})"),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: mainBgColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
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
                  child: orderSearch(),
                ),
                const SizedBox(
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
                            if (selectedOrder != null) {
                              final strSelectedOrder =
                                  "${selectedOrder!.productName}(#${selectedOrder!.id})";
                              List<String> orders =
                                  widget.employeeActivityModel.orders;
                              if (isRemove) {
                                orders = widget.employeeActivityModel.orders
                                    .where((e) => e != strSelectedOrder)
                                    .toList();

                                // updateing order
                                // removeing the employee from the selected order
                                mainConntroller.updateOrder(
                                  selectedOrder!.copyWith(
                                    employees: selectedOrder!.employees
                                        .where((element) =>
                                            element !=
                                            widget.employeeActivityModel
                                                .employeeName)
                                        .toList(),
                                  ),
                                  selectedOrder!.status,
                                  isBack: false,
                                );
                              }
                              if (isAdd) {
                                orders = [
                                  ...widget.employeeActivityModel.orders,
                                  strSelectedOrder,
                                ];

                                // updateing order
                                // adding the employee to the selected order
                                mainConntroller.updateOrder(
                                  selectedOrder!.copyWith(
                                    employees:
                                        selectedOrder!.employees.contains(
                                      widget.employeeActivityModel.employeeName,
                                    )
                                            ? selectedOrder!.employees
                                            : [
                                                widget.employeeActivityModel
                                                    .employeeName,
                                                ...selectedOrder!.employees,
                                              ],
                                  ),
                                  selectedOrder!.status,
                                  isBack: false,
                                );
                              }
                              mainConntroller.addUpdateEmployeeActivity(
                                widget.employeeActivityModel.copyWith(
                                  orders: orders,
                                  morning: morning,
                                  afternoon: afternoon,
                                ),
                              );
                            } else {
                              mainConntroller.addUpdateEmployeeActivity(
                                widget.employeeActivityModel.copyWith(
                                  orders: widget.employeeActivityModel.orders,
                                  morning: morning,
                                  afternoon: afternoon,
                                ),
                              );
                            }
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
      ),
    );
  }
}
