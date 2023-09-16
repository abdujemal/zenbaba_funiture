import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

import '../../constants.dart';
import '../../data/model/employee_model.dart';
import '../../data/model/expense_model.dart';
import '../controller/main_controller.dart';
import '../widget/custom_btn.dart';
import '../widget/sl_input.dart';

class AddExpense extends StatefulWidget {
  final ExpenseModel? expenseModel;
  const AddExpense({super.key, this.expenseModel});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController descriptionTc = TextEditingController();
  TextEditingController expenseCategoryTc = TextEditingController();
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  TextEditingController priceTc = TextEditingController();

  var sellerTc = TextEditingController();

  var expenseState = ExpenseState.payed;

  String currentDate = "";

  var expenseCategory = ExpenseCategory.electricity;

  var expenseFormState = GlobalKey<FormState>();

  List<EmployeeModel> employees = [];

  EmployeeModel? selectedEmployee;

  bool withReciept = false;

  @override
  void dispose() {
    descriptionTc.dispose();
    expenseCategoryTc.dispose();
    priceTc.dispose();
    sellerTc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    mainConntroller.getEmployees().then((value) {
      employees = mainConntroller.employees;
      if (widget.expenseModel != null) {
        if (widget.expenseModel!.category == ExpenseCategory.employee) {
          selectedEmployee = employees
                  .where(
                    (element) => element.id == widget.expenseModel!.employeeId,
                  )
                  .toList()
                  .isNotEmpty
              ? employees
                  .where(
                    (element) => element.id == widget.expenseModel!.employeeId,
                  )
                  .toList()[0]
              : null;
          setState(() {});
        }
      }
      setState(() {});
    });

    currentDate = DateTime.now().toString().split(' ')[0];

    if (widget.expenseModel != null) {
      expenseCategory = widget.expenseModel!.category;
      descriptionTc.text = widget.expenseModel!.description;
      priceTc.text = widget.expenseModel!.price.toString();
      sellerTc.text = widget.expenseModel!.seller;
      expenseState = widget.expenseModel!.expenseStatus;
      currentDate = widget.expenseModel!.date;
      withReciept = widget.expenseModel!.withReceipt;
      setState(() {});
    }
  }

  sellerFeild() {
    return RawAutocomplete<ExpenseModel>(
      initialValue: TextEditingValue(text: sellerTc.text),
      displayStringForOption: (option) {
        return option.seller;
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
          title: expenseCategory == ExpenseCategory.employee
              ? "Employee"
              : "Seller",
          hint: "Tofiq",
          keyboardType: TextInputType.text,
          inputColor: whiteColor,
          otherColor: textColor,
          controller: textEditingController,
          isOutlined: true,
          focusNode: focusNode,
          onChanged: (val) {
            sellerTc.text = val;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          color: backgroundColor,
          child: Obx(
            () {
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
                          children: options.map(
                            (opt) {
                              return InkWell(
                                onTap: () {
                                  onSelected(opt);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 23,
                                  ),
                                  child: Card(
                                    child: Container(
                                      color: mainBgColor,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(opt.seller),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title(
            widget.expenseModel != null ? "Expense Detail" : "New Expense"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: expenseFormState,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SpecialDropdown<String>(
                    value: expenseCategory,
                    width: double.infinity,
                    list: ExpenseCategory.list,
                    title: "Expense Category",
                    onChange: (value) {
                      setState(() {
                        expenseCategory = value!;
                        if (value == ExpenseCategory.employee) {
                          selectedEmployee = employees[0];
                        } else {
                          selectedEmployee = null;
                        }
                      });
                    }),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Description",
                  hint: 'description',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.text,
                  controller: descriptionTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                SLInput(
                  title: "Price",
                  hint: '1000',
                  inputColor: whiteColor,
                  otherColor: textColor,
                  keyboardType: TextInputType.number,
                  controller: priceTc,
                  isOutlined: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                expenseCategory != ExpenseCategory.employee
                    ? sellerFeild()
                    : selectedEmployee != null
                        ? SpecialDropdown<EmployeeModel>(
                            title: "Employee",
                            value: selectedEmployee!,
                            width: double.infinity,
                            list: employees,
                            onChange: (v) {
                              setState(() {
                                selectedEmployee = v;
                                sellerTc.text = selectedEmployee!.name;
                              });
                            },
                            items: employees
                                .map(
                                  (e) => DropdownMenuItem<EmployeeModel>(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                          )
                        : const Text("Loading Employee"),
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 23),
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
                        initialValue: currentDate,
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
                          currentDate = val;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: CheckboxListTile(
                    title: const Text("With Reciept"),
                    value: withReciept,
                    onChanged: (v) {
                      setState(() {
                        withReciept = v!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Obx(() {
                  if (mainConntroller.expenseStatus.value ==
                      RequestState.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomBtn(
                        btnState: Btn.filled,
                        color: primaryColor,
                        text: 'Save',
                        onTap: () {
                          if (expenseFormState.currentState!.validate()) {
                            if (widget.expenseModel == null) {
                              mainConntroller.addExpense(
                                ExpenseModel(
                                  id: null,
                                  withReceipt: withReciept,
                                  category: expenseCategory,
                                  description: descriptionTc.text,
                                  price: double.parse(priceTc.text),
                                  expenseStatus: expenseState,
                                  seller: sellerTc.text,
                                  date: currentDate,
                                  employeeId: selectedEmployee == null
                                      ? null
                                      : selectedEmployee!.id,
                                ),
                              );
                            } else {
                              mainConntroller.updateExpense(
                                widget.expenseModel!.copyWith(
                                  withRecipt: withReciept,
                                  category: expenseCategory,
                                  description: descriptionTc.text,
                                  price: double.parse(priceTc.text),
                                  expenseStatus: expenseState,
                                  seller: sellerTc.text,
                                  date: currentDate,
                                  employeeId: selectedEmployee == null
                                      ? null
                                      : selectedEmployee!.id,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      widget.expenseModel != null
                          ? Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("or"),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomBtn(
                                    btnState: Btn.outlined,
                                    color: textColor,
                                    onTap: () {
                                      if (widget.expenseModel != null) {
                                        mainConntroller.delete(
                                            FirebaseConstants.expenses,
                                            widget.expenseModel!.id!,
                                            widget.expenseModel!.category,
                                            false,
                                            null);
                                      }
                                    },
                                    text: "Delete")
                              ],
                            )
                          : const SizedBox()
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
