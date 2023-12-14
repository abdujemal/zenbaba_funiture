import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';

import '../../constants.dart';
import '../../data/model/expense_model.dart';
import '../controller/main_controller.dart';
import '../widget/date_item.dart';
import '../widget/expense_card.dart';
import 'add_expense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  LSController lsController = Get.find<LSController>();

  int selectedTabIndex = 0;

  ScrollController controller = ScrollController();

  int pageNum = 2;

  @override
  void initState() {
    super.initState();
    controller.addListener(handleScrolling);
  }

  void handleScrolling() {
    if (controller.offset >= controller.position.maxScrollExtent) {
      if (mainConntroller.getExpensesStatus.value != RequestState.loading) {
        mainConntroller.getExpenses(
            quantity: numOfDocToGet,
            status: ExpenseState.list[selectedTabIndex],
            isNew: false);
        pageNum = pageNum + 1;
        print("${mainConntroller.pendingOrders.length} expenses");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton:
          lsController.currentUser.value.priority != UserPriority.AdminView
              ? FloatingActionButton(
                  backgroundColor: primaryColor,
                  child: SvgPicture.asset(
                    "assets/plus.svg",
                    color: backgroundColor,
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {
                    Get.to(() => const AddExpense());
                  },
                )
              : null,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Expenses"),
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
            onPressed: () async {
              await mainConntroller.getExpenses(
                quantity: numOfDocToGet,
                status: ExpenseState.unpayed,
              );
              await mainConntroller.getExpenses(
                quantity: numOfDocToGet,
                status: ExpenseState.payed,
              );
            },
            icon: const Icon(
              Icons.refresh_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black54,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                ExpenseState.list.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: selectedTabIndex != index
                            ? Colors.transparent
                            : backgroundColor),
                    child: Text(
                      ExpenseState.list[index],
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              List<dynamic> expenses = [];
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

              for (ExpenseModel expeseModel in selectedTabIndex == 0
                  ? mainConntroller.payedExpenses
                  : mainConntroller.unPayedExpenses) {
                if (currentDate != expeseModel.date) {
                  if (today == expeseModel.date) {
                    expenses.add("Today");
                    currentDate = expeseModel.date;
                  } else {
                    expenses.add(expeseModel.date.replaceAll("-", "/"));
                    currentDate = expeseModel.date;
                  }
                }
                expenses.add(expeseModel);
              }

              if (selectedTabIndex == 0 &&
                  mainConntroller.payedExpenses.isEmpty) {
                return const Center(
                  child: Text("No Expenses."),
                );
              }
              if (selectedTabIndex == 1 &&
                  mainConntroller.unPayedExpenses.isEmpty) {
                return const Center(
                  child: Text("No Expenses."),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await mainConntroller.getExpenses(
                          quantity: numOfDocToGet,
                          status: ExpenseState.unpayed,
                        );
                        await mainConntroller.getExpenses(
                          quantity: numOfDocToGet,
                          status: ExpenseState.payed,
                        );
                      },
                      backgroundColor: backgroundColor,
                      color: primaryColor,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          bottom: 70,
                        ),
                        controller: controller,
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          if (expenses[index].runtimeType.toString() ==
                              "String") {
                            return DateItem(
                              date: expenses[index],
                              style: expenses[index] == "Unpayed Expenses"
                                  ? TextStyle(color: primaryColor, fontSize: 18)
                                  : null,
                            );
                          } else {
                            return ExpenseCard(
                              isPayed: expenses[index].expenseStatus ==
                                  ExpenseState.payed,
                              expenseModel: expenses[index],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  mainConntroller.getExpensesStatus.value ==
                          RequestState.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const SizedBox()
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
