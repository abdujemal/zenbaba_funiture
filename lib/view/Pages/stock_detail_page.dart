import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zenbaba_funiture/data/data_src/database_data_src.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';
import 'package:zenbaba_funiture/view/widget/add_item_history_dialog.dart';
import 'package:zenbaba_funiture/view/widget/left_line.dart';

import '../../constants.dart';
import '../../data/model/item_history_model.dart';
import '../controller/main_controller.dart';

class StockDetailPage extends StatefulWidget {
  final int index;
  const StockDetailPage({super.key, required this.index});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  LSController lsController = Get.find<LSController>();

  String? startDate;

  int numOfItems = 1;

  String selectedItemHistoryType = ItemHistoryType.used;

  var sellerTc = TextEditingController();

  String expenseState = ExpenseState.unpayed;

  File? imageFile;

  bool isExpanded = false;

  List<ItemHistoryModel> itemHistories = [];

  bool showIcons = false;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.now().toString().split(" ")[0];

    setImageFile();

    refresh();
  }

  refresh() async {
    final lst = await mainConntroller.search(
      FirebaseConstants.itemsHistories,
      "itemId",
      mainConntroller.items[widget.index].id!,
      SearchType.normalItemHistories,
    );

    itemHistories = lst.map((e) => e as ItemHistoryModel).toList();

    itemHistories.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    setState(() {});
  }

  setImageFile() async {
    imageFile = await displayImage(mainConntroller.items[widget.index].image!,
        mainConntroller.items[widget.index].id!, FirebaseConstants.items);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title(mainConntroller.items[widget.index].name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      floatingActionButton:
          lsController.currentUser.value.priority != UserPriority.AdminView
              ? AnimatedContainer(
                  onEnd: () {
                    setState(() {
                      showIcons = !showIcons;
                    });
                  },
                  height: isExpanded ? 180 : 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: primaryColor,
                  ),
                  duration: const Duration(
                    milliseconds: 500,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      if (isExpanded && showIcons)
                        UserPriority.isAdmin(
                                lsController.currentUser.value.priority)
                            ? IconButton(
                                onPressed: () {
                                  Get.dialog(
                                    AddItemHistoryDialog(
                                      itemStatus: ItemHistoryType.buyed,
                                      itemModel:
                                          mainConntroller.items[widget.index],
                                    ),
                                    barrierDismissible: false,
                                    transitionDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                  );
                                },
                                icon: SvgPicture.asset(
                                  'assets/buy.svg',
                                  color: backgroundColor,
                                  height: 40,
                                  width: 40,
                                ),
                              )
                            : const SizedBox(),
                      const Spacer(),
                      if (isExpanded && showIcons)
                        IconButton(
                          onPressed: () {
                            Get.dialog(
                              AddItemHistoryDialog(
                                itemStatus: ItemHistoryType.used,
                                itemModel: mainConntroller.items[widget.index],
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/used.svg',
                            color: backgroundColor,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                            if (showIcons) {
                              showIcons = false;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(100),
                                blurRadius: 10,
                                spreadRadius: 5,
                                offset: const Offset(0, 0),
                              )
                            ],
                          ),
                          child: isExpanded
                              ? Icon(
                                  Icons.close,
                                  size: 20,
                                  color: backgroundColor,
                                )
                              : SvgPicture.asset(
                                  "assets/plus.svg",
                                  color: backgroundColor,
                                  height: 20,
                                  width: 20,
                                ),
                        ),
                      )
                    ],
                  ),
                )
              : null,
      body: Obx(
        () {
          return RefreshIndicator(
            onRefresh: () async {
              await refresh();
            },
            color: primaryColor,
            backgroundColor: backgroundColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 10,
                              offset: const Offset(-5, 5),
                            )
                          ],
                          color: mainBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: imageFile != null
                                  ? imageFile!.path == ""
                                      ? Container(
                                          color: backgroundColor,
                                          width: 150,
                                          height: 150,
                                          child: const Center(
                                            child: Text("No Network"),
                                          ),
                                        )
                                      : Image.file(
                                          imageFile!,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )
                                  : Container(
                                      color: backgroundColor,
                                      width: 150,
                                      height: 150,
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    mainConntroller.items[widget.index].name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Text(
                                      mainConntroller
                                          .items[widget.index].category,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 23,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              '${mainConntroller.items[widget.index].quantity}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  section(
                    b: 15,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                        ),
                        child: Text(
                          "History",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (itemHistories.isEmpty)
                        const SizedBox(
                          height: 200,
                          child: Center(
                            child: Text("No History"),
                          ),
                        ),
                      ...List.generate(
                        itemHistories.length,
                        (index) {
                          DateTime currentDay =
                              DateTime.parse(itemHistories[index].date);

                          DateTime lastDay = index > 0
                              ? DateTime.parse(itemHistories[index - 1].date)
                              : DateTime.parse(itemHistories[index].date);

                          DateTime nextDay = index < itemHistories.length - 1
                              ? DateTime.parse(itemHistories[index + 1].date)
                              : DateTime.parse(itemHistories[index].date);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (currentDay.compareTo(lastDay) != 0 ||
                                  index == 0)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Text(
                                    DateFormat("EEE / dd - MMMM").format(
                                      DateTime.parse(itemHistories[index].date),
                                    ),
                                    style: TextStyle(
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              LeftLined(
                                circleColor: primaryColor,
                                isLast: index == itemHistories.length - 1 ||
                                    nextDay.compareTo(currentDay) > 0,
                                onTap: () {},
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${itemHistories[index].quantity} pcs ${itemHistories[index].type}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      if (itemHistories[index].type ==
                                          ItemHistoryType.used)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Row(
                                            children: [
                                              Text(
                                                "For order",
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                " #${itemHistories[index].orderId}",
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (itemHistories[index].type ==
                                          ItemHistoryType.buyed)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: lsController.currentUser.value
                                                      .priority ==
                                                  UserPriority.Designer
                                              ? Text(
                                                  "${formatNumber(double.parse(itemHistories[index].price).round())} br",
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              : Text(
                                                  "???? br",
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
