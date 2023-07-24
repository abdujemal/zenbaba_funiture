import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
            }),
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
            ),
          )
        ],
      ),
      body: Obx(
        () {
          if (mainConntroller.getItemsStatus.value == RequestState.loading) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          if (mainConntroller.items.isEmpty) {
            return const Center(
              child: Text("No Items"),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: mainConntroller.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                childAspectRatio: 1 / 1.25),
            itemBuilder: (context, index) {
              return ItemCard(itemModel: mainConntroller.items[index]);
            },
          );
        },
      ),
    );
  }
}
