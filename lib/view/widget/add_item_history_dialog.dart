import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/data_src/database_data_src.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';
import 'package:zenbaba_funiture/data/model/item_history_model.dart';
import 'package:zenbaba_funiture/data/model/order_model.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/view/widget/custom_btn.dart';
import 'package:zenbaba_funiture/view/widget/sl_input.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

import '../../data/model/expense_model.dart';
import '../../data/model/item_model.dart';

class AddItemHistoryDialog extends StatefulWidget {
  final String itemStatus;
  final ItemModel itemModel;
  const AddItemHistoryDialog(
      {super.key, required this.itemStatus, required this.itemModel});

  @override
  State<AddItemHistoryDialog> createState() => _AddItemHistoryDialogState();
}

class _AddItemHistoryDialogState extends State<AddItemHistoryDialog> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  OrderModel? selectedOrder;

  final TextEditingController _orderNameTc = TextEditingController();

  int quantity = 1;

  bool isLoading = false;

  final TextEditingController _itemTc = TextEditingController();

  final GlobalKey<FormState> _historyKey = GlobalKey<FormState>();

  final TextEditingController _descriptionTc = TextEditingController();

  final TextEditingController _sellerTc = TextEditingController();

  final TextEditingController _priceTc = TextEditingController();

  String expenseState = ExpenseState.payed;

  String selectedDate = DateTime.now().toString().split(" ")[0];

  EmployeeModel? selectedEmployee;

  bool withReciept = false;

  @override
  void initState() {
    mainConntroller.getEmployees().then((value) {
      selectedEmployee = mainConntroller.employees.isNotEmpty
          ? mainConntroller.employees[0]
          : null;
      setState(() {});
    });

    if (widget.itemStatus == ItemHistoryType.buyed) {
      _priceTc.text = widget.itemModel.pricePerUnit.toString();
    }

    super.initState();
  }

  @override
  dispose() {
    _orderNameTc.dispose();
    _itemTc.dispose();
    _descriptionTc.dispose();
    super.dispose();
  }

  Widget orderSearch() {
    return RawAutocomplete<OrderModel>(
      initialValue: TextEditingValue(text: _orderNameTc.text),
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
          title: "Order",
          hint: '...',
          bgColor: mainBgColor,
          margin: 0,
          keyboardType: TextInputType.text,
          controller: textEditingController,
          inputColor: whiteColor,
          otherColor: textColor,
          isOutlined: true,
          focusNode: focusNode,
          sufixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "assets/order.svg",
              color: textColor,
            ),
          ),
          onChanged: (val) {
            _orderNameTc.text = val;
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          void Function(OrderModel) onSelected, Iterable<OrderModel> options) {
        return Material(
          color: backgroundColor,
          child: SizedBox(
            height: 200,
            width: 100,
            child: SingleChildScrollView(
              child: Column(
                children: options.map((opt) {
                  return InkWell(
                    onTap: () {
                      onSelected(opt);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
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
          ),
        );
      },
    );
  }

  withAndQuantity({required Widget input}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: input,
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: mainBgColor,
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Text('$quantity'),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: textColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              },
                            );
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  sellerFeild() {
    return RawAutocomplete<ExpenseModel>(
      initialValue: TextEditingValue(text: _sellerTc.text),
      displayStringForOption: (option) {
        return option.seller ?? "";
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<ExpenseModel>.empty();
        } else {
          if (mainConntroller.getExpensesStatus.value != RequestState.loading) {
            await mainConntroller.searchExpense(textEditingValue.text);

            return mainConntroller.searchExpenses;
          } else {
            return const Iterable<ExpenseModel>.empty();
          }
        }
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return SLInput(
          margin: 10,
          title: "Seller",
          hint: 'Tofiq',
          keyboardType: TextInputType.text,
          controller: textEditingController,
          bgColor: mainBgColor,
          inputColor: whiteColor,
          otherColor: textColor,
          isOutlined: true,
          focusNode: focusNode,
          onChanged: (val) {
            _sellerTc.text = val;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          color: backgroundColor,
          child: Obx(() {
            print(options.length);
            return mainConntroller.getExpensesStatus.value ==
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
                                  child: Text(opt.seller ?? ""),
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

  Widget inputDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Date",
              style: TextStyle(color: textColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DateTimePicker(
            initialValue: selectedDate,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              suffix: SvgPicture.asset(
                'assets/calander icon.svg',
                height: 30,
                width: 30,
                color: textColor,
              ),
              filled: true,
              fillColor: mainBgColor,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            type: DateTimePickerType.date,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            dateLabelText: 'Date',
            dateMask: 'd MMM, yyyy',
            onChanged: (val) {
              selectedDate = val;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 60,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _historyKey,
            child: section(
              mb: 0,
              mh: 0,
              mv: 0,
              b: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              bgColor: backgroundColor,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
                withAndQuantity(
                  input: widget.itemStatus == ItemHistoryType.buyed
                      ? SLInput(
                          margin: 0,
                          title: "Item Price Per ${widget.itemModel.unit}",
                          hint: '300',
                          keyboardType: TextInputType.number,
                          controller: _priceTc,
                          bgColor: mainBgColor,
                          inputColor: whiteColor,
                          otherColor: textColor,
                          isOutlined: true,
                        )
                      : orderSearch(),
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  margin: 10,
                  title: "Description",
                  hint: 'description',
                  keyboardType: TextInputType.text,
                  controller: _descriptionTc,
                  bgColor: mainBgColor,
                  inputColor: whiteColor,
                  otherColor: textColor,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                widget.itemStatus == ItemHistoryType.used
                    ? selectedEmployee != null
                        ? SpecialDropdown<EmployeeModel>(
                            title: "Employee",
                            value: selectedEmployee!,
                            width: double.infinity,
                            margin: 10,
                            list: mainConntroller.employees,
                            items: mainConntroller.employees
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChange: (val) {
                              setState(() {
                                selectedEmployee = val;
                              });
                            })
                        : const Text("Loading Employees...")
                    : sellerFeild(),
                const SizedBox(
                  height: 15,
                ),
                if (widget.itemStatus == ItemHistoryType.buyed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      ExpenseState.list.length,
                      (index) {
                        return SizedBox(
                          width: 160,
                          child: RadioListTile(
                            activeColor: whiteColor,
                            title: Text(ExpenseState.list[index]),
                            value: ExpenseState.list[index],
                            groupValue: expenseState,
                            onChanged: (val) {
                              setState(() {
                                expenseState = val.toString();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                inputDate(),
                const SizedBox(
                  height: 35,
                ),
                const SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: CheckboxListTile(
                    title: const Text("With Reciept"),
                    value: withReciept,
                    activeColor: whiteColor,
                    onChanged: (v) {
                      setState(() {
                        withReciept = v!;
                      });
                    },
                  ),
                ),
                isLoading
                    ? CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : CustomBtn(
                        tColor: backgroundColor,
                        btnState: Btn.filled,
                        color: primaryColor,
                        onTap: () async {
                          if (_historyKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            if (widget.itemStatus == ItemHistoryType.buyed) {
                              await mainConntroller.increaseStock(
                                quantity,
                                widget.itemModel,
                                ItemHistoryModel(
                                    quantity: quantity,
                                    type: widget.itemStatus,
                                    date: selectedDate,
                                    id: null,
                                    unit: widget.itemModel.unit,
                                    itemId: widget.itemModel.id!,
                                    itemImg: widget.itemModel.image!,
                                    itemCategory: widget.itemModel.category,
                                    itemName: widget.itemModel.name,
                                    price: _priceTc.text,
                                    seller: _sellerTc.text,
                                    employeeId: "",
                                    orderId: ""),
                              );

                              // adding expense
                              await mainConntroller.addExpense(
                                  ExpenseModel(
                                    id: null,
                                    category: ExpenseCategory.rawMaterial,
                                    withReceipt: withReciept,
                                    description:
                                        "$quantity${widget.itemModel.unit} of ${widget.itemModel.name}",
                                    price: (double.parse(_priceTc.text) *
                                        quantity),
                                    expenseStatus: expenseState,
                                    seller: _sellerTc.text,
                                    date: selectedDate,
                                    employeeId: null,
                                  ),
                                  goBack: false);
                            } else {
                              if (selectedEmployee == null) {
                                toast("No Employee is selected.",
                                    ToastType.error);
                                setState(() {
                                  isLoading = false;
                                });

                                return;
                              }
                              if (selectedOrder == null) {
                                toast("No Order is selected.", ToastType.error);
                                setState(() {
                                  isLoading = false;
                                });
                                return;
                              }

                              if (widget.itemModel.quantity == 0) {
                                toast(
                                    "Please you do not have ${widget.itemModel.name}. Please consider buying it.",
                                    ToastType.error);
                                setState(() {
                                  isLoading = false;
                                });
                                return;
                              }

                              final ds = await FirebaseFirestore.instance
                                  .collection(
                                      FirebaseConstants.employeeActivity)
                                  .where(
                                    "employeeId",
                                    isEqualTo: selectedEmployee!.id!,
                                  )
                                  .where('date', isEqualTo: selectedDate)
                                  .get();
                              print("employee name: ${selectedEmployee!.name}");
                              print("date: $selectedDate");

                              if (ds.docs.isEmpty) {
                                toast(
                                    "No Employee Activity, Please consider go to employee Activity and add.",
                                    ToastType.error);
                                setState(() {
                                  isLoading = false;
                                });

                                return;
                              } else {
                                await FirebaseFirestore.instance
                                    .collection(
                                        FirebaseConstants.employeeActivity)
                                    .doc(ds.docs[0].id)
                                    .update(
                                  {
                                    "itemsUsed": FieldValue.arrayUnion([
                                      "${widget.itemModel.name} $quantity ${widget.itemModel.unit}"
                                    ])
                                  },
                                );
                              }

                              await mainConntroller.decreaseStock(
                                quantity,
                                widget.itemModel,
                                ItemHistoryModel(
                                  quantity: quantity,
                                  type: widget.itemStatus,
                                  date: selectedDate,
                                  id: null,
                                  itemId: widget.itemModel.id!,
                                  unit: widget.itemModel.unit,
                                  itemImg: widget.itemModel.image!,
                                  itemCategory: widget.itemModel.category,
                                  itemName: widget.itemModel.name,
                                  price: _priceTc.text,
                                  seller: _sellerTc.text,
                                  employeeId: selectedEmployee!.id!,
                                  orderId: selectedOrder!.id!,
                                ),
                                selectedOrder!.productName,
                              );

                              await mainConntroller.updateOrder(
                                selectedOrder!.copyWith(
                                  itemsUsed: [
                                    ...selectedOrder!.itemsUsed,
                                    "${widget.itemModel.name} * $quantity ${widget.itemModel.unit}"
                                  ],
                                ),
                                selectedOrder!.status,
                                isBack: false,
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            Get.back();
                          }
                        },
                        text: "Save",
                      ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
