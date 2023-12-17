import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/data/model/item_model.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';

import '../../constants.dart';
import '../controller/main_controller.dart';
import '../widget/item_card.dart';
import 'add_item.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  LSController lsController = Get.find<LSController>();

  int selectCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Items"),
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
              mainConntroller.getItems();
            },
            icon: const Icon(
              Icons.refresh_rounded,
              size: 30,
            ),
          )
        ],
      ),
      floatingActionButton:
          lsController.currentUser.value.priority != UserPriority.AdminView
              ? FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    Get.to(() => const AddItem());
                  },
                  child: SvgPicture.asset(
                    'assets/plus.svg',
                    width: 15,
                    height: 15,
                  ),
                )
              : null,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: mainBgColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                ItemCategory.list.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: selectCategoryIndex == index
                          ? backgroundColor
                          : mainBgColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(ItemCategory.list[index]),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (mainConntroller.getItemsStatus.value ==
                    RequestState.loading) {
                  return Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }
                if (mainConntroller.items.isEmpty) {
                  return const Center(
                    child: Text("No Items"),
                  );
                }

                List<ItemModel> sortedItems = mainConntroller.items
                    .where(
                      (p0) =>
                          p0.category == ItemCategory.list[selectCategoryIndex],
                    )
                    .toList();

                return RefreshIndicator(
                  onRefresh: () async {
                    await mainConntroller.getItems();
                  },
                  backgroundColor: backgroundColor,
                  color: primaryColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: sortedItems.length,
                    itemBuilder: (context, index) {
                      return ItemCard(
                        itemModel: sortedItems[index],
                        isStock: false,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
