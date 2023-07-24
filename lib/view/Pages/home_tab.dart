import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../constants.dart';
import '../../data/model/cutomer_model.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_chart_model.dart';
import '../../data/model/line_chart_model.dart';
import '../../data/model/order_chart_model.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';
import '../widget/expense_card.dart';
import '../widget/line_chart.dart';
import '../widget/my_dropdown.dart';
import '../widget/order_item.dart';
import '../widget/sample_line_chart.dart';
import 'expenses_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin<HomeTab> {
  double bigestPrice = 0;
  List<ExpenseCategoryModel> categories = [];
  var colorList = [
    Colors.green,
    primaryColor,
    Colors.blue,
    Colors.yellow,
    Colors.pink,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.black,
    Colors.white,
    Colors.indigo,
    Colors.lime
  ];

  List<LineChartModel> data = [];
  List<String> dataType = ['Month', "Year"];
  List<ExpenseChartModel> expenseData = [];
  List<String> graphType = [
    "Week",
    "Year",
  ];

  List<Map<String, dynamic>> locations = [];
  LSController lsController = Get.find<LSController>();
  MainConntroller mainConntroller = Get.find<MainConntroller>();
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

  int numOfFemale = 0;
  int numOfMale = 0;
  var ringChatData = <String, double>{};
  int selectedGraphType = 1;
  String selectedMonth = "";
  var selectedType = 1;
  String selectedYear = "";
  String selectedYearForMonth = "";
  int totalCustomer = 0;
  double totalExpense = 0;
  double totalIncome = 0;
  List<String> weekDays = [
    "Mon",
    "Tues",
    "Wed",
    "Thurs",
    "Fri",
    "Sat",
    "Sun",
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

  @override
  void initState() {
    selectedMonth = months[DateTime.now().month - 1];
    selectedYear = DateTime.now().year.toString();
    selectedYearForMonth = DateTime.now().year.toString();
    super.initState();
    getPrices();
    calculateForMonth();
    calculateCustomers();
  }

  @override
  bool get wantKeepAlive => true;

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

  calculateCustomers() {
    for (String source in CustomerSource.list) {
      int numOfCustomers = 0;
      numOfFemale = 0;
      numOfMale = 0;
      for (CustomerModel customer in mainConntroller.customers) {
        if (customer.source == source) {
          numOfCustomers++;
        }

        if (customer.gender == Gender.Female) {
          numOfFemale++;
        } else if (customer.gender == Gender.Male) {
          numOfMale++;
        }
      }
      ringChatData.addAll({source: numOfCustomers.toDouble()});
    }
    locations = [];
    List<Map<String, dynamic>> newLocations = [];

    for (String kk in KK.list) {
      int numOfCustomers = 0;
      totalCustomer = 0;
      for (CustomerModel customer in mainConntroller.customers) {
        if (customer.kk == kk) {
          numOfCustomers++;
        }
        totalCustomer++;
      }
      newLocations.add({"kk": kk, "num": numOfCustomers});
    }
    setState(() {
      locations.addAll(newLocations);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Home"),
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
              mainConntroller.getCustomers();
              calculateCustomers();
            },
            icon: const Icon(
              Icons.refresh,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AspectRatio(
                aspectRatio: 1.23,
                child: Container(
                  padding: const EdgeInsets.only(right: 20, left: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    color: mainBgColor,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
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
            ),
            // const SizedBox(
            //   height: 15,
            // ),
            // if (lsController.currentUser.value.priority == UserPriority.Admin)
            //   Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 20),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(50),
            //       color: Colors.black54,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: List.generate(
            //         graphType.length,
            //         (index) => GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               selectedGraphType = index;
            //               if (graphType[index] == "Week") {
            //                 calculateForWeek();
            //               } else {
            //                 calculateForMonth();
            //               }
            //             });
            //           },
            //           child: Container(
            //             margin: const EdgeInsets.all(5),
            //             padding: const EdgeInsets.symmetric(
            //               vertical: 5,
            //               horizontal: 30,
            //             ),
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(50),
            //                 color: selectedGraphType != index
            //                     ? Colors.transparent
            //                     : backgroundColor),
            //             child: Text(
            //               graphType[index],
            //               style: const TextStyle(fontSize: 17),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // const SizedBox(
            //   height: 20,
            // ),
            // if (lsController.currentUser.value.priority == UserPriority.Admin)
            //   Obx(
            //     () {
            //       if (graphType[selectedGraphType] == "Week") {
            //         calculateForWeek();
            //       } else {
            //         calculateForMonth();
            //       }

            //       if (mainConntroller.getExpensesStatus.value ==
            //           RequestState.loading) {
            //         return Center(
            //           child: SizedBox(
            //             height: 200,
            //             child: Center(
            //               child: CircularProgressIndicator(
            //                 color: primaryColor,
            //               ),
            //             ),
            //           ),
            //         );
            //       }
            //       return SampleLineChart(
            //         data: data,
            //         biggetPrice: bigestPrice,
            //         totalExpense: totalExpense,
            //         totalIncome: totalIncome,
            //       );
            //     },
            //   ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 270,
              padding: const EdgeInsets.only(
                  top: 5, left: 15, right: 15, bottom: 20),
              decoration: BoxDecoration(
                  color: mainBgColor, borderRadius: BorderRadius.circular(40)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          "Recent order",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          mainConntroller.currentTabIndex.value = 1;
                        },
                        child: const Text("See all"),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (mainConntroller.getOrdersStatus.value ==
                        RequestState.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    }
                    return mainConntroller.pendingOrders.isEmpty
                        ? const SizedBox(
                            height: 100,
                            child: Center(
                              child: Text("No Pending Orders."),
                            ),
                          )
                        : Column(
                            children: List.generate(
                              mainConntroller.pendingOrders.length == 1 ? 1 : 2,
                              (index) => OrderItem(
                                orderModel:
                                    mainConntroller.pendingOrders[index],
                                isDelivery: mainConntroller
                                        .pendingOrders[index].deliveryOption ==
                                    DeliveryOption.delivery,
                                isFinished: mainConntroller
                                        .pendingOrders[index].status ==
                                    OrderStatus.Delivered,
                              ),
                            ),
                          );
                  })
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (lsController.currentUser.value.priority == UserPriority.Admin)
              Container(
                width: double.infinity,
                height: 270,
                padding: const EdgeInsets.only(
                    top: 5, left: 15, right: 15, bottom: 20),
                decoration: BoxDecoration(
                  color: mainBgColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            "Recent Transaction",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const ExpensesPage());
                          },
                          child: const Text("See all"),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (mainConntroller.getExpensesStatus.value ==
                          RequestState.loading) {
                        return Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        );
                      }
                      return mainConntroller.payedExpenses.isEmpty
                          ? const SizedBox(
                              height: 100,
                              child: Center(
                                child: Text("No Transactions."),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                mainConntroller.payedExpenses.length == 1
                                    ? 1
                                    : 2,
                                (index) => ExpenseCard(
                                  isPayed: mainConntroller
                                          .payedExpenses[index].expenseStatus ==
                                      ExpenseState.payed,
                                  expenseModel:
                                      mainConntroller.payedExpenses[index],
                                ),
                              ),
                            );
                    })
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            if (lsController.currentUser.value.priority == UserPriority.Admin)
              Container(
                width: double.infinity,
                height: 480,
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 20),
                decoration: BoxDecoration(
                    color: mainBgColor,
                    borderRadius: BorderRadius.circular(40)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        "Customer Source",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: PieChart(
                          dataMap: ringChatData,
                          baseChartColor: backgroundColor,
                          colorList: colorList,
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          legendOptions: const LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: false,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            if (lsController.currentUser.value.priority == UserPriority.Admin)
              Container(
                width: double.infinity,
                height: 270,
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 20),
                decoration: BoxDecoration(
                    color: mainBgColor,
                    borderRadius: BorderRadius.circular(40)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(
                              FontAwesomeIcons.male,
                              color: Color.fromARGB(255, 41, 101, 169),
                              size: 120,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(193, 0, 0, 0),
                                  blurRadius: 30,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Male",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "$numOfMale",
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(
                              FontAwesomeIcons.female,
                              color: Color.fromARGB(255, 248, 133, 171),
                              size: 120,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(193, 0, 0, 0),
                                  blurRadius: 30,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Female",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "$numOfFemale",
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            if (lsController.currentUser.value.priority == UserPriority.Admin)
              Container(
                width: double.infinity,
                height: 560,
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 20),
                decoration: BoxDecoration(
                    color: mainBgColor,
                    borderRadius: BorderRadius.circular(40)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        "Customer Location",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (locations.isNotEmpty)
                      Expanded(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: locations.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) {
                            return Card(
                              color: mainBgColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      locations[index]["kk"],
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      locations[index]["num"].toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                        "${(locations[index]["num"] / totalCustomer * 100 as double).roundToDouble()}%")
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
