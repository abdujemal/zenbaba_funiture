import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/expense_model.dart';
import '../../data/model/item_history_model.dart';
import '../controller/main_controller.dart';
import '../widget/custom_btn.dart';
import '../widget/date_item.dart';
import '../widget/sl_input.dart';
import '../widget/stock_card.dart';

class StockDetailPage extends StatefulWidget {
  final int index;
  const StockDetailPage({super.key, required this.index});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  String? startDate;

  int numOfItems = 1;

  String selectedItemHistoryType = ItemHistoryType.used;

  var sellerTc = TextEditingController();

  String expenseState = ExpenseState.unpayed;

  File? imageFile;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.now().toString().split(" ")[0];

    mainConntroller.getItemHistories(mainConntroller.items[widget.index]);

    setImageFile();
  }

  setImageFile() async {
    imageFile = await displayImage(
        mainConntroller.items[widget.index].image!,
        mainConntroller.items[widget.index].name,
        FirebaseConstants.items);
    if (mounted) {
      setState(() {});
    }
  }

  inputDate() {
    return Container(
      margin: const EdgeInsets.only(right: 23),
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
            initialValue: startDate,
            decoration: InputDecoration(
              suffix: const Icon(Icons.event),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
              ),
            ),
            type: DateTimePickerType.date,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            dateLabelText: 'Date',
            dateMask: 'd MMM, yyyy',
            onChanged: (val) {
              setState(() {
                startDate = val;
              });
            },
          ),
        ],
      ),
    );
  }

  quantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "pcs",
            style: TextStyle(color: textColor),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: textColor, width: 1),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                '$numOfItems',
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        numOfItems++;
                      });
                    },
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          if (numOfItems > 1) {
                            numOfItems--;
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
        ),
      ],
    );
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
          title:"Seller",
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
                              padding: EdgeInsets.symmetric(horizontal: 23),
                              child: Card(
                                child: Container(
                                  color: mainBgColor,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  child: Text(opt.seller),
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Stocks"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await mainConntroller.getItems();
                mainConntroller
                    .getItemHistories(mainConntroller.items[widget.index]);
              },
              icon: const Icon(
                Icons.refresh_rounded,
                size: 30,
              ))
        ],
      ),
      body: Obx(
        () {
          return mainConntroller.getItemsStatus.value == RequestState.loading
              ? Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withAlpha(150),
                                  blurRadius: 5,
                                  offset: const Offset(-5, 5))
                            ],
                            color: mainBgColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: imageFile != null
                                  ? imageFile!.path == ""
                                      ? Container(
                                          color: backgroundColor,
                                          width: 150,
                                          height: 170,
                                          child: const Center(
                                            child: Text("No Network"),
                                          ),
                                        )
                                      : Image.file(
                                          imageFile!,
                                          width: 150,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        )
                                  : Container(
                                      color: backgroundColor,
                                      width: 150,
                                      height: 170,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    mainConntroller.items[widget.index].name,
                                    style: const TextStyle(fontSize: 24,),
                                    overflow: TextOverflow.clip,
                                    
                                  ),
                                ),
                                Text(
                                  mainConntroller.items[widget.index].category,
                                  style:
                                      TextStyle(color: textColor, fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Column(
                                    children: [
                                      Text(
                                        "In Stock",
                                        style: TextStyle(
                                            color: textColor, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Obx(() {
                                        return Text(
                                          "${mainConntroller.items[widget.index].quantity}",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 17),
                                        );
                                      })
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      selectedItemHistoryType == ItemHistoryType.buyed
                          ? sellerFeild()
                          : const SizedBox(),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 23),
                        child: Row(
                          children: [Expanded(child: inputDate()), quantity()],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          ItemHistoryType.list.length,
                          (index) {
                            return SizedBox(
                              width: 160,
                              child: RadioListTile(
                                activeColor: whiteColor,
                                title: Text(ItemHistoryType.list[index]),
                                value: ItemHistoryType.list[index],
                                groupValue: selectedItemHistoryType,
                                onChanged: (val) {
                                  setState(() {
                                    selectedItemHistoryType = val.toString();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      selectedItemHistoryType == ItemHistoryType.buyed
                          ? Row(
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
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 15,
                      ),
                      Obx(() {
                        if (mainConntroller.stockStatus.value ==
                            RequestState.loading) {
                          return Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: CustomBtn(
                            width: double.infinity,
                            btnState: Btn.filled,
                            color: primaryColor,
                            text: "Save",
                            onTap: () async {
                              if (selectedItemHistoryType ==
                                  ItemHistoryType.buyed) {
                                if (sellerTc.text.isNotEmpty) {
                                  // await mainConntroller.increaseStock(
                                  //   numOfItems,
                                  //   mainConntroller.items[widget.index],
                                  //   ItemHistoryModel(
                                  //     date: startDate!,
                                  //     quantity: numOfItems,
                                  //     type: selectedItemHistoryType,
                                  //     id: DateTime.now()
                                  //         .microsecondsSinceEpoch
                                  //         .toString(),
                                  //   ),
                                  // );
                                  await mainConntroller.addExpense(
                                    ExpenseModel(
                                        id: null,
                                        category: ExpenseCategory.rawMaterial,
                                        description:
                                            "name: ${mainConntroller.items[widget.index].name}, quantity: ${mainConntroller.items[widget.index].quantity}, pricePerUnit: ${mainConntroller.items[widget.index].pricePerUnit}",
                                        price: mainConntroller
                                                .items[widget.index]
                                                .pricePerUnit *
                                            numOfItems,
                                        expenseStatus: expenseState,
                                        date: startDate!,
                                        seller: sellerTc.text),
                                    goBack: false,
                                  );
                                } else {
                                  toast(
                                      "Seller Feild is Empty", ToastType.error);
                                }
                              } else {
                                // if you are using what you dont have
                                if (mainConntroller
                                            .items[widget.index].quantity -
                                        numOfItems >=
                                    0) {
                                  // await mainConntroller.decreaseStock(
                                  //   numOfItems,
                                  //   mainConntroller.items[widget.index],
                                  //   ItemHistoryModel(
                                  //     date: startDate!,
                                  //     quantity: numOfItems,
                                  //     type: selectedItemHistoryType,
                                  //     id: DateTime.now()
                                  //         .microsecondsSinceEpoch
                                  //         .toString(),
                                  //   ),
                                  // );
                                } else {
                                  toast("you don't have that much.",
                                      ToastType.error);
                                }
                              }
                            },
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(20),
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(150),
                              blurRadius: 5,
                              offset: const Offset(-5, 5),
                            )
                          ],
                          color: mainBgColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Obx(() {
                          List<dynamic> histories = [];
                          DateTime now = DateTime.now();
                          String today = "";
                          String day = "${now.day}";
                          String month = "${now.month}";
                          if (now.month < 10) {
                            month = '0${now.month}';
                          }
                          if (now.day < 10) {
                            day = '0${now.day}';
                          }
                          today = "${now.year}-$month-$day";
                          String currentDate = "";
                          print(today);
                          for (ItemHistoryModel itemHistoryModel
                              in mainConntroller.itemHistories) {
                            if (currentDate != itemHistoryModel.date) {
                              if (today == itemHistoryModel.date) {
                                histories.add("Today");
                                currentDate = itemHistoryModel.date;
                              } else {
                                histories.add(
                                    itemHistoryModel.date.replaceAll("-", "/"));
                                currentDate = itemHistoryModel.date;
                              }
                            }
                            histories.add(itemHistoryModel);
                          }
                          return ListView.builder(
                            itemCount: histories.length,
                            itemBuilder: (context, index) {
                              if (histories[index].runtimeType.toString() ==
                                  "String") {
                                return DateItem(date: histories[index]);
                              }
                              return StockCard(
                                name: mainConntroller.items[widget.index].name,
                                image: imageFile,
                                itemHistoryModel: histories[index],
                              );
                            },
                          );
                        }),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
