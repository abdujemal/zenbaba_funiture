import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../Pages/add_expense.dart';
import '../Pages/add_item.dart';
import '../Pages/add_order.dart';
import '../Pages/add_product.dart';

class AddDialogue extends StatefulWidget {
  const AddDialogue({super.key});

  @override
  State<AddDialogue> createState() => _AddDialogueState();
}

class _AddDialogueState extends State<AddDialogue> {
  List<AddMenu> items = [
    AddMenu('assets/expense icon.svg', "Expense", const AddExpense()),
    AddMenu('assets/order icon.svg', "Order", const AddOrder()),
    AddMenu('assets/item icon.svg', "Item", const AddItem()),
    AddMenu('assets/product icon.svg', "Product", const AddProduct()),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(192, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 15,
            )
          ]),
      width: 230,
      height: 260,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: List.generate(
          items.length,
          (index) => InkWell(
            splashColor: mainBgColor,
            onTap: () {
              Get.to(() => items[index].page);
            },
            child: ListTile(
              leading: items[index].name == "Product"
                  ? const Icon(
                      Icons.star_outline,
                      size: 30,
                    )
                  : SvgPicture.asset(
                      items[index].icon,
                      height: 30,
                      color: whiteColor,
                    ),
              // tileColor: primaryColor,
              title: Text(
                items[index].name,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddMenu {
  String name, icon;
  Widget page;
  AddMenu(this.icon, this.name, this.page);
}
