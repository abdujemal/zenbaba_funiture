import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/data/data_src/database_data_src.dart';
import 'package:zenbaba_funiture/data/model/item_history_model.dart';
import 'package:zenbaba_funiture/view/Pages/stock_detail_page.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';
import 'package:zenbaba_funiture/view/widget/stock_item_by_activity.dart';

import '../../constants.dart';
import '../../data/model/item_model.dart';
import '../controller/main_controller.dart';
import '../widget/item_card.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  double stockPadding = 10;

  List<String> displayOptions = ["By stock", "By activity"];

  String selectedDisplayOption = "By stock";

  List<ItemHistoryModel> itemHistories = [];

  bool isLoading = false;

  @override
  initState() {
    super.initState();

    refresh();
  }

  Future<void> refresh() async {
    if (selectedDisplayOption == "By stock") {
      mainConntroller.getItems();
    } else {
      setState(() {
        isLoading = true;
      });
      final lst = await mainConntroller.search(
        FirebaseConstants.itemsHistories,
        'date',
        "*",
        SearchType.normalItemHistories,
      );

      itemHistories = lst.map((e) => e as ItemHistoryModel).toList();
      setState(() {
        isLoading = false;
      });
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
        title: title("Stocks"),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/menu icon.svg',
            color: whiteColor,
            height: 21,
          ),
          onPressed: () {
            mainConntroller.z.value.open!();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Align(
            alignment: Alignment.bottomRight,
            child: SpecialDropdown<String>(
              title: "",
              isDense: true,
              textColor: textColor,
              value: selectedDisplayOption,
              width: 150,
              noTitle: true,
              list: displayOptions,
              onChange: (value) {
                setState(() {
                  selectedDisplayOption = value;
                });
                refresh();
              },
            ),
          ),
        ),
      ),
      body: Obx(
        () {
          List<ItemModel> inStock = [];
          List<ItemModel> outOfStock = [];

          for (ItemModel item in mainConntroller.items) {
            if (item.quantity == 0) {
              outOfStock.add(item);
            } else {
              inStock.add(item);
            }
          }

          if (mainConntroller.getItemsStatus.value == RequestState.loading) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          return selectedDisplayOption == "By stock"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                      child: Text(
                        "In Stock",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    inStock.isEmpty
                        ? const SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Center(
                              child: Text("No Item in Stock."),
                            ),
                          )
                        : Expanded(
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.all(stockPadding),
                              itemCount: inStock.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ItemCard(
                                  onTap: () {
                                    Get.to(
                                      () => StockDetailPage(
                                        index: mainConntroller.items.indexOf(
                                          inStock[index],
                                        ),
                                      ),
                                    );
                                  },
                                  itemModel: inStock[index],
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.16,
                              ),
                            ),
                          ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                      child: Text(
                        "Out of Stock",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    outOfStock.isEmpty
                        ? const SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Center(
                              child: Text("No Items out of stock."),
                            ),
                          )
                        : Expanded(
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.all(stockPadding),
                              itemCount: outOfStock.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ItemCard(
                                  onTap: () {
                                    Get.to(
                                      () => StockDetailPage(
                                        index: mainConntroller.items.indexOf(
                                          outOfStock[index],
                                        ),
                                      ),
                                    );
                                  },
                                  itemModel: outOfStock[index],
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.16,
                              ),
                            ),
                          ),
                  ],
                )
              : isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : itemHistories.isEmpty
                      ? const Center(
                          child: Text("No Activity"),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            refresh();
                          },
                          backgroundColor: backgroundColor,
                          color: primaryColor,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: itemHistories.length,
                            itemBuilder: (context, index) {
                              DateTime currentDay =
                                  DateTime.parse(itemHistories[index].date);

                              DateTime lastDay = index > 0
                                  ? DateTime.parse(
                                      itemHistories[index - 1].date)
                                  : DateTime.parse(itemHistories[index].date);

                              return StockItemByActivity(
                                itemHistoryModel: itemHistories[index],
                                showDate: currentDay.compareTo(lastDay) != 0 ||
                                    index == 0,
                              );
                            },
                          ),
                        );
        },
      ),
    );
  }
}
