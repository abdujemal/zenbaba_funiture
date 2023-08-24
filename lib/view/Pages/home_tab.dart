import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:zenbaba_funiture/data/data_src/database_data_src.dart';
import 'package:zenbaba_funiture/data/model/expense_model.dart';
import 'package:zenbaba_funiture/data/model/item_model.dart';
import 'package:zenbaba_funiture/data/model/order_model.dart';
import 'package:zenbaba_funiture/view/Pages/stock_detail_page.dart';
import 'package:zenbaba_funiture/view/widget/expense_category_card.dart';
import 'package:zenbaba_funiture/view/widget/item_card.dart';
import 'package:zenbaba_funiture/view/widget/left_line.dart';
import 'package:zenbaba_funiture/view/widget/order_item.dart';

import '../../constants.dart';
import '../../data/model/cutomer_model.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_chart_model.dart';
import '../../data/model/line_chart_model.dart';
import '../../data/model/order_chart_model.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';
import '../widget/line_chart.dart';
import '../widget/my_dropdown.dart';
import '../widget/special_dropdown.dart';
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

  int selectedIndex = 0;
  List<String> menus = ["Yesterday", "Today", "Tomorrow"];

  List<List<OrderModel>> orderDays = [];

  int numOfFemale = 0;
  int numOfMale = 0;
  List<Map<String, dynamic>> customerSources = [];
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

    refresh();
  }

  refresh() {
    mainConntroller.getExpenseChart();
    mainConntroller.getOrderChart();
    mainConntroller.getCustomers();
    mainConntroller.getOrders(
      quantity: numOfDocToGet,
      status: OrderStatus.Pending,
    );
    mainConntroller.getOrders(
      quantity: numOfDocToGet,
      status: OrderStatus.proccessing,
    );
    mainConntroller.getOrders(
      quantity: numOfDocToGet,
      status: OrderStatus.completed,
    );
    mainConntroller.getExpenses(
      quantity: numOfDocToGet,
      status: ExpenseState.payed,
    );
    mainConntroller.getItems();
    calculateCustomers();

    loadOrders();
  }

  loadOrders() async {
    final todaylst = await mainConntroller.search(
      FirebaseConstants.orders,
      'finishedDate',
      DateTime.now().toString().split(" ")[0],
      SearchType.specificOrder,
    );
    final yesterdaylst = await mainConntroller.search(
      FirebaseConstants.orders,
      'finishedDate',
      DateTime.now().add(const Duration(days: -1)).toString().split(" ")[0],
      SearchType.specificOrder,
    );
    final tomorrowlst = await mainConntroller.search(
      FirebaseConstants.orders,
      'finishedDate',
      DateTime.now().add(const Duration(days: 1)).toString().split(" ")[0],
      SearchType.specificOrder,
    );

    orderDays = [
      yesterdaylst.map((e) => e as OrderModel).toList(),
      todaylst.map((e) => e as OrderModel).toList(),
      tomorrowlst.map((e) => e as OrderModel).toList(),
    ];
    setState(() {});
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
    customerSources = [];
    List<Map<String, dynamic>> newCustomerSources = [];

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
      newCustomerSources.add({"source": source, "value": numOfCustomers});
    }
    setState(() {
      customerSources.addAll(newCustomerSources);
    });

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
              refresh();
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
                      SpecialDropdown<String>(
                        value: selectedMonth,
                        list: months,
                        title: "Months",
                        onChange: (val) {
                          setState(() {
                            selectedMonth = val!;
                            calculateForDate();
                          }); //0972503987
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
            const SizedBox(
              height: 13,
            ),
            GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 20,
              crossAxisSpacing: 25,
              padding: const EdgeInsets.all(10),
              children: [
                section(
                  mh: 0,
                  mv: 0,
                  mb: 0,
                  b: 30,
                  paddingh: 15,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/income.svg",
                          color: whiteColor,
                          width: 30,
                          height: 30,
                        ),
                        const Text(
                          "income",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                section(
                  mh: 0,
                  mv: 0,
                  mb: 0,
                  b: 30,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/expense.svg",
                          color: whiteColor,
                          width: 30,
                          height: 30,
                        ),
                        const Text(
                          "expense",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                section(
                  mh: 0,
                  mv: 0,
                  mb: 0,
                  b: 30,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/order.svg",
                          color: whiteColor,
                          width: 30,
                          height: 30,
                        ),
                        const Text(
                          "order",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox()
                      ],
                    ),
                  ],
                ),
                section(
                  mh: 0,
                  mv: 0,
                  mb: 0,
                  b: 30,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/customer.svg",
                          color: whiteColor,
                          width: 30,
                          height: 30,
                        ),
                        const Text(
                          "customers",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            section(
              mv: 0,
              mb: 20,
              mh: 10,
              b: 30,
              children: [
                Stack(
                  children: [
                    PieChart(
                      chartRadius: 150,
                      ringStrokeWidth: 10,
                      colorList: [whiteColor, primaryColor],
                      dataMap: {
                        "lose": 5,
                        'profit': 5,
                      },
                      chartType: ChartType.ring,
                      legendOptions: const LegendOptions(
                        showLegends: false,
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValues: false,
                      ),
                    ),
                    const Positioned.fill(
                      child: Center(
                        child: Text(
                          "Profit",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Obx(() {
              return section(
                mv: 0,
                mb: 25,
                mh: 10,
                paddingh: 15,
                b: 30,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Transaction History",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const ExpensesPage());
                        },
                        child: Text(
                          "See all",
                          style: TextStyle(fontSize: 18, color: textColor),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (mainConntroller.getExpensesStatus.value ==
                      RequestState.loading)
                    Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  if (mainConntroller.getExpensesStatus.value !=
                      RequestState.loading)
                    ...mainConntroller.payedExpenses.isNotEmpty
                        ? List.generate(
                            mainConntroller.payedExpenses.length < 3
                                ? mainConntroller.payedExpenses.length
                                : 3, (index) {
                            ExpenseModel expenseModel =
                                mainConntroller.payedExpenses[index];
                            return LeftLined(
                              circleColor: primaryColor,
                              onTap: () {},
                              isLast: index == 2,
                              showBottomBorder: index != 2,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expenseModel.category,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          top: 3,
                                        ),
                                        child: Text(
                                          expenseModel.category ==
                                                  ExpenseCategory.rawMaterial
                                              ? expenseModel.description
                                              : expenseModel.seller,
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${expenseModel.price} Br",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
                        : [
                            const Text("No Transaction"),
                          ],
                ],
              );
            }),
            section(
              mv: 0,
              mb: 25,
              mh: 10,
              paddingh: 15,
              b: 30,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/male.svg",
                              color: textColor,
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Male",
                              style: TextStyle(
                                fontSize: 17,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "$numOfMale",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${((numOfMale / (numOfMale + numOfFemale)) * 100).round()}%",
                          style: TextStyle(
                            fontSize: 17,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 70,
                      child: VerticalDivider(
                        color: textColor,
                        thickness: 0.6,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/female.svg",
                              color: textColor,
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Female",
                              style: TextStyle(
                                fontSize: 17,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "$numOfFemale",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${((numOfFemale / (numOfMale + numOfFemale)) * 100).round()}%",
                          style: TextStyle(
                            fontSize: 17,
                            color: primaryColor,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            section(
              mv: 0,
              mb: 25,
              mh: 10,
              paddingh: 15,
              b: 30,
              children: [
                const Text(
                  "Customer source",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Source",
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                    Text(
                      "Amount",
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: textColor,
                  thickness: 0.6,
                ),
                ...List.generate(
                  customerSources.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(builder: (context, ct) {
                      final w = ct.maxWidth - 200;
                      return Row(
                        children: [
                          Text(
                            customerSources[index]["source"],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${customerSources[index]["value"]}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: w,
                            height: 5,
                            decoration: BoxDecoration(
                              color: greyColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: (customerSources[index]["value"] /
                                          (numOfFemale + numOfMale)) *
                                      w,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                )
              ],
            ),
            section(
              mv: 0,
              mb: 25,
              mh: 10,
              paddingh: 15,
              b: 30,
              children: [
                const Text(
                  "Out of stock items",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    List<ItemModel> outOfStockItems = mainConntroller.items
                        .where((p0) => p0.quantity == 0)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: List.generate(
                          outOfStockItems.length,
                          (index) => ItemCard(
                            itemModel: outOfStockItems[index],
                            isStock: false,
                            isHome: true,
                            showBottomBorder:
                                outOfStockItems.length - 1 != index,
                            onTap: () {
                              Get.to(
                                () => StockDetailPage(
                                  index: mainConntroller.items.indexOf(
                                    outOfStockItems[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            section(
              mv: 0,
              mb: 25,
              mh: 10,
              paddingh: 15,
              b: 30,
              children: [
                const Text(
                  "Order",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            bottom: -40,
                            child: Divider(
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              menus.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: index == selectedIndex
                                            ? primaryColor
                                            : backgroundColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(menus[index]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (orderDays.isEmpty)
                      const Center(
                        child: SizedBox(
                          height: 60,
                          child: Center(child: Text("Loading...")),
                        ),
                      ),
                    if (orderDays.isNotEmpty)
                      Column(
                        children: [
                          if (orderDays[selectedIndex].isNotEmpty)
                            ...List.generate(orderDays[selectedIndex].length,
                                (index) {
                              OrderModel model =
                                  orderDays[selectedIndex][index];
                              return OrderItem(
                                isFinished:
                                    model.status == OrderStatus.completed,
                                isDelivery: model.deliveryOption ==
                                    DeliveryOption.delivery,
                                orderModel: model,
                              );
                            }),
                          if (orderDays[selectedIndex].isEmpty)
                            const Center(
                              child: SizedBox(
                                height: 60,
                                child: Center(
                                  child: Text("No order"),
                                ),
                              ),
                            )
                        ],
                      ),
                  ],
                )
              ],
            ),
            section(
              mv: 0,
              mb: 25,
              mh: 10,
              paddingh: 15,
              b: 30,
              children: [
                const Text(
                  "Expense",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
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
                  return Column(
                    children: List.generate(
                      categories.length,
                      (index) {
                        return ExpenseCategoryCard(
                          expenseCategoryModel: categories[index],
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
            section(
              mv: 0,
              mb: 25,
              mh: 10,
              paddingh: 15,
              b: 30,
              children: [
                const Text(
                  "Customer location",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      "Source",
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Amount",
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      "100%",
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                ),
                Divider(
                  color: textColor,
                  thickness: 0.6,
                ),
                ...List.generate(
                  locations.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          locations[index]["kk"],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${locations[index]["num"]}",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "${(((locations[index]["num"] / totalCustomer) as double) * 100).round()}%",
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }
}
