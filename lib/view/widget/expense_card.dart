import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';

import '../../constants.dart';
import '../../data/model/expense_model.dart';
import '../Pages/add_expense.dart';

class ExpenseCard extends StatefulWidget {
  final ExpenseModel expenseModel;
  final bool isPayed;
  const ExpenseCard({
    super.key,
    required this.isPayed,
    required this.expenseModel,
  });

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  LSController lsController = Get.find<LSController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: textColor,
            width: .7,
          ),
        ),
      ),
      child: ListTile(
        onTap: () {
          if (lsController.currentUser.value.priority !=
              UserPriority.AdminView) {
            Get.to(
              () => AddExpense(
                expenseModel: widget.expenseModel,
              ),
            );
          }
        },
        leading: Icon(
          Icons.keyboard_arrow_up,
          color: whiteColor,
          size: 45,
        ),
        title: Text(
          widget.expenseModel.category,
          // style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        trailing: Text(
          '${formatNumber(widget.expenseModel.price.round())} Br',
          // style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(
          widget.expenseModel.category == ExpenseCategory.employee
              ? "Name: ${widget.expenseModel.seller}"
              : "Seller: ${widget.expenseModel.seller}",
          style: TextStyle(
            color: textColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
