
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/stock_detail_page.dart';

import '../../constants.dart';
import '../../data/model/item_model.dart';
import '../controller/main_controller.dart';
import '../widget/item_card.dart';
import 'add_item.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

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
              Get.to(() => const AddItem());
            },
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          IconButton(
              onPressed: () {
                mainConntroller.getItems();
              },
              icon: const Icon(
                Icons.refresh_rounded,
                size: 30,
              ))
        ],
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
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
                  : SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: inStock.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: ItemCard(
                              onTap: () {
                                Get.to(
                                  () => StockDetailPage(
                                    index: mainConntroller.items
                                        .indexOf(inStock[index]),
                                  ),
                                );
                              },
                              itemModel: inStock[index],
                            ),
                          );
                        },
                      ),
                    ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
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
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: outOfStock.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
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
                                itemModel: outOfStock[index]),
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
