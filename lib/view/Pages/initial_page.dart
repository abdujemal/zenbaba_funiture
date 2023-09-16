import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/employee_page.dart';
import 'package:zenbaba_funiture/view/Pages/users_page.dart';
import '../../constants.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';
import '../widget/my_drawer.dart';
import 'calender_page.dart';
import 'cutomers_page.dart';
import 'expenses_page.dart';
import 'items_page.dart';
import 'main_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  LSController lsController = Get.find<LSController>();

  List<Widget> adminTabs = [
    const MainPage(),
    const ExpensesPage(),
    const EmployeePage(),
    const ItemsPage(),
    const CalenderPage(),
    const CustomersPage(),
    const UsersPage(),
  ];

  List<Widget> adminViewTabs = [
    const MainPage(),
    const ExpensesPage(),
    const EmployeePage(),
    const ItemsPage(),
    const CalenderPage(),
    const CustomersPage()
  ];

  List<Widget> sellsTabs = [
    const MainPage(),
    const CalenderPage(),
    const CustomersPage()
  ];

  List<Widget> storeKeeperTabs = [
    const MainPage(),
    const ItemsPage(),
  ];

  List<Widget> workShopManagerTabs = [
    const MainPage(),
    const EmployeePage(),
    const CalenderPage(),
  ];

  List<Widget> designerTabs = [
    const MainPage(),
    const ItemsPage(),
    const CalenderPage(),
  ];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    await mainConntroller.getExpenses(
      quantity: numOfDocToGet,
      status: ExpenseState.unpayed,
    );
    await mainConntroller.getExpenses(
      quantity: numOfDocToGet,
      status: ExpenseState.payed,
    );
    await mainConntroller.getItems();
    await mainConntroller.getOrders(
      quantity: numOfDocToGet,
      status: OrderStatus.Pending,
    );
    await mainConntroller.getOrders(
      quantity: numOfDocToGet,
      status: OrderStatus.proccessing,
    );
    await mainConntroller.getOrders(
      quantity: numOfDocToGet,
      status: OrderStatus.Delivered,
    );
    // mainConntroller.getProducts();
    await mainConntroller.getUsers();
    await mainConntroller.getExpenseChart();
    await mainConntroller.getOrderChart();
    await mainConntroller.getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mainConntroller.mainIndex.value != 0) {
          mainConntroller.mainIndex.value = 0;
          mainConntroller.update();
          return false;
        } else {
          return true;
        }
      },
      child: ZoomDrawer(
        controller: mainConntroller.z.value,
        borderRadius: 24,
        style: DrawerStyle.defaultStyle,
        showShadow: true,
        shadowLayer1Color: backgroundColor,
        shadowLayer2Color: backgroundColor,
        menuScreenWidth: 200,
        boxShadow: [
          BoxShadow(
              color: primaryColor.withAlpha(15),
              blurRadius: 30,
              spreadRadius: 30,
              offset: const Offset(0, 4))
        ],
        openCurve: Curves.fastOutSlowIn,
        slideWidth: MediaQuery.of(context).size.width * 0.6,
        duration: const Duration(milliseconds: 500),
        angle: 0.0,
        menuBackgroundColor: mainBgColor,
        mainScreen: GetBuilder<MainConntroller>(
            builder: (controller) =>
                getTabs(lsController.currentUser.value.priority)[
                    controller.mainIndex.value]),
        menuScreen: const MyDrawer(),
      ),
    );
  }

  List<Widget> getTabs(String priority) {
    if (priority == UserPriority.Admin) {
      return adminTabs;
    } else if (priority == UserPriority.AdminView) {
      return adminViewTabs;
    } else if (priority == UserPriority.Sells) {
      return sellsTabs;
    } else if (priority == UserPriority.Storekeeper) {
      return storeKeeperTabs;
    } else if (priority == UserPriority.WorkShopManager) {
      return workShopManagerTabs;
    } else if (priority == UserPriority.HR) {
      return adminViewTabs;
    } else {
      return designerTabs;
    }
  }
}
