import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_chart_model.dart';
import '../../data/model/line_chart_model.dart';
import '../../data/model/order_chart_model.dart';
import '../controller/main_controller.dart';
import '../widget/expense_category_card.dart';
import '../widget/line_chart.dart';
import '../widget/my_dropdown.dart';

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> with AutomaticKeepAliveClientMixin<BudgetTab> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  List<String> dataType = ['Month', "Year"];

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  List<String> years = [
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
    "2031",
    "2032",
    "2033",
    "2034",
    "2035",
  ];

  var selectedType = 1;

  List<ExpenseCategoryModel> categories = [];

  final colorList = <Color>[
    Colors.teal,
    Colors.red,
    Colors.blue,
    Colors.purple,
    Colors.yellow,
    Colors.black,
    Colors.brown
  ];

  double totalExpense = 0;

  double totalIncome = 0;

  double bigestPrice = 0;

  List<LineChartModel> data = [];

  List<ExpenseChartModel> expenseData = [];

  String selectedYear = "";

  String selectedMonth = "";

  String selectedYearForMonth = "";

  @override
  void initState() {
    selectedMonth = months[DateTime.now().month - 1];
    selectedYear = DateTime.now().year.toString();
    selectedYearForMonth = DateTime.now().year.toString();
    super.initState();
    getPrices();
    calculateForMonth();
  }

  calculateForDate() {
    totalExpense = 0;
    totalIncome = 0;
    bigestPrice = 0;
    data = [];
    expenseData = [];
    for (int i = 1; i <= 30; i++) {
      double expensePrice = 0;
      double incomePrice = 0;
      for (ExpenseChartModel expenseModel in mainConntroller.expensesChart) {
        if (i == DateTime.parse(expenseModel.date).day &&
            selectedMonth ==
                months[DateTime.parse(expenseModel.date).month - 1] &&
            DateTime.parse(expenseModel.date).year ==
                int.parse(selectedYearForMonth)) {
          expensePrice += expenseModel.price;
          totalExpense += expenseModel.price;
          expenseData.add(expenseModel);
        }
      }
      for (OrderChartModel orderModel in mainConntroller.ordersChart) {
        if (i == DateTime.parse(orderModel.date).day &&
            selectedMonth ==
                months[DateTime.parse(orderModel.date).month - 1] &&
            DateTime.parse(orderModel.date).year ==
                int.parse(selectedYearForMonth)) {
          incomePrice += orderModel.price;
          totalIncome += orderModel.price;
        }
      }
      if (bigestPrice < incomePrice) {
        bigestPrice = incomePrice;
      }
      if (bigestPrice < expensePrice) {
        bigestPrice = expensePrice;
      }
      data.add(
        LineChartModel(
          title: i.toString(),
          leftVal: incomePrice,
          rightVal: expensePrice,
        ),
      );
    }
    getPrices();
    setState(() {});
  }

  calculateForMonth() {
    totalExpense = 0;
    totalIncome = 0;
    bigestPrice = 0;
    data = [];
    expenseData = [];
    for (String month in months) {
      double expensePrice = 0;
      double incomePrice = 0;
      for (ExpenseChartModel expenseModel in mainConntroller.expensesChart) {
        if (month == months[DateTime.parse(expenseModel.date).month - 1] &&
            DateTime.parse(expenseModel.date).year == int.parse(selectedYear)) {
          expensePrice += expenseModel.price;
          totalExpense += expenseModel.price;
          expenseData.add(expenseModel);
        }
      }
      for (OrderChartModel orderModel in mainConntroller.ordersChart) {
        if (month == months[DateTime.parse(orderModel.date).month - 1] &&
            DateTime.parse(orderModel.date).year == int.parse(selectedYear)) {
          incomePrice += orderModel.price;
          totalIncome += orderModel.price;
        }
      }
      if (bigestPrice < incomePrice) {
        bigestPrice = incomePrice;
      }
      if (bigestPrice < expensePrice) {
        bigestPrice = expensePrice;
      }
      data.add(
        LineChartModel(
          title: month,
          leftVal: incomePrice,
          rightVal: expensePrice,
        ),
      );
    }
    getPrices();
    setState(() {});
  }

  getPrices() {
    categories = [];
    // for (String cat in ExpenseCategory.list) {
    //   categories.add(value);
    // }
    for (String cat in ExpenseCategory.list) {
      double price = 0;
      bool doesCatExist = false;
      int num = 0;
      for (ExpenseChartModel expense in expenseData) {
        if (cat == expense.category) {
          price += expense.price;
          doesCatExist = true;
          num++;
        }
      }
      if (doesCatExist) {
        categories.add(
          ExpenseCategoryModel(
              title: cat,
              persontage: (price / totalExpense) * 100,
              price: price,
              numOfTransaction: num),
        );
      }
      doesCatExist = false;
    }
  }

  myContainer(Color color, String title, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 15,
      ),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(140),
                spreadRadius: 2,
                blurRadius: 8)
          ]),
      child: Column(
        children: [
          Text(title),
          const SizedBox(
            height: 5,
          ),
          Text("$value Br")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Budget"),
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
                mainConntroller.getExpenseChart();
                mainConntroller.getOrderChart();
                setState(() {
                  calculateForMonth();
                  selectedType = 1;
                });
                getPrices();
              },
              icon: const Icon(
                Icons.refresh_rounded,
                size: 30,
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            selectedType == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyDropdown(
                        value: selectedMonth,
                        list: months,
                        title: "Months",
                        onChange: (val) {
                          setState(() {
                            selectedMonth = val!;
                            calculateForDate();
                          });
                        },
                        width: 200,
                        margin: 0,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MyDropdown(
                        value: selectedYearForMonth,
                        list: years,
                        title: "Years",
                        onChange: (val) {
                          setState(() {
                            selectedYearForMonth = val!;
                            calculateForDate();
                          });
                        },
                        width: 100,
                        margin: 0,
                      ),
                    ],
                  )
                : MyDropdown(
                    value: selectedYear,
                    list: years,
                    title: "Years",
                    onChange: (val) {
                      setState(() {
                        selectedYear = val!;
                        calculateForMonth();
                      });
                    },
                    width: 200,
                  ),
            const SizedBox(
              height: 20,
            ),
            AspectRatio(
              aspectRatio: 1.23,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    color: mainBgColor),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 37,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            dataType.length,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedType = index;
                                  if (selectedType == 0) {
                                    calculateForDate();
                                  } else {
                                    calculateForMonth();
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(
                                  dataType[index],
                                  style: TextStyle(
                                      color: selectedType == index
                                          ? textColor
                                          : Colors.black,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 37,
                        ),
                        Obx(() {
                          if (mainConntroller.getOrdersStatus.value ==
                              RequestState.loading) {
                            return Expanded(
                              child: SizedBox(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 16, left: 6),
                              child: LineChartSample(
                                bigPrice: bigestPrice,
                                isMonth: dataType[selectedType] == "Month",
                                data: data,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myContainer(Colors.brown, "Income", totalIncome),
                const SizedBox(
                  width: 15,
                ),
                myContainer(primaryColor, "Expense", totalExpense)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            title("Cateogries"),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              if (mainConntroller.getExpensesStatus.value ==
                  RequestState.loading) {
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                );
              }
              if (categories.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: Text("No Expenses"),
                  ),
                );
              }
              getPrices();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: categories.length * 90,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: List.generate(
                      categories.length,
                      (index) {
                        return ExpenseCategoryCard(
                          expenseCategoryModel: categories[index],
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
