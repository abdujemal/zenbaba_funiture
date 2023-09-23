// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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

class _StockPageState extends State<StockPage>
    with AutomaticKeepAliveClientMixin<StockPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  double stockPadding = 10;

  List<String> displayOptions = ["By stock", "By activity"];

  String selectedDisplayOption = "By stock";

  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    scrollController.addListener(handleScrolling);
    refresh();
  }

  Future<void> refresh() async {
    if (selectedDisplayOption == "By stock") {
      mainConntroller.getItems();
    } else {
      mainConntroller.getStockActivities(numOfDocToGet, true);
    }
  }

  handleScrolling() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      if (mainConntroller.getNewStockActivityStatus.value !=
              RequestState.loading ||
          mainConntroller.getAddStockActivityStatus.value !=
              RequestState.loading) {
        mainConntroller.getStockActivities(numOfDocToGet, false);
      }
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
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
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
                        : SizedBox(
                            height: 170,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  EdgeInsets.symmetric(vertical: stockPadding),
                              itemCount: outOfStock.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ItemCard(
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
                                  ),
                                );
                              },
                            ),
                          ),
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
                  ],
                )
              : mainConntroller.getNewStockActivityStatus.value.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : mainConntroller.itemHistories.isEmpty
                      ? const Center(
                          child: Text("No Activity"),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  refresh();
                                },
                                backgroundColor: backgroundColor,
                                color: primaryColor,
                                child: ListView.builder(
                                  controller: scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount:
                                      mainConntroller.itemHistories.length,
                                  itemBuilder: (context, index) {
                                    DateTime currentDay = DateTime.parse(
                                        mainConntroller
                                            .itemHistories[index].date);

                                    DateTime lastDay = index > 0
                                        ? DateTime.parse(mainConntroller
                                            .itemHistories[index - 1].date)
                                        : DateTime.parse(mainConntroller
                                            .itemHistories[index].date);

                                    return StockItemByActivity(
                                      itemHistoryModel:
                                          mainConntroller.itemHistories[index],
                                      showDate:
                                          currentDay.compareTo(lastDay) != 0 ||
                                              index == 0,
                                    );
                                  },
                                ),
                              ),
                            ),
                            mainConntroller
                                    .getAddStockActivityStatus.value.isLoading
                                ? CircularProgressIndicator(
                                    color: primaryColor,
                                  )
                                : const SizedBox()
                          ],
                        );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
