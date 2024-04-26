import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/products_tab.dart';
import 'package:zenbaba_funiture/view/Pages/stock_page.dart';

import '../../constants.dart';
import '../../injection.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';
import '../widget/bottom_nav.dart';
import 'home_tab.dart';
import 'order_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  List<Widget> tabBodies = [
    const HomeTab(),
    const OrderTab(),
    const StockPage(),
    const ProductTab()
  ];

  List<String> icons = [
    'assets/home_tab.svg',
    'assets/orders.svg',
    'assets/items.svg',
    'assets/product_tab.svg',
  ];

  MainConntroller mainConntroller = Get.put(di<MainConntroller>());
  LSController lsController = Get.put(di<LSController>());

  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(
        length: 4,
        vsync: this,
        animationDuration: const Duration(
          milliseconds: 200,
        ));
    tabController!.addListener(_handleTabChange);
    super.initState();
  }

  void _handleTabChange() {
    print(tabController!.index);
    mainConntroller.setCurrentTabIndex(tabController!.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: BottomNav(
        controller: tabController!,
        icons: icons,
      ),
      body: TabBarView(
        controller: tabController,
        children: tabBodies,
      ),
    );
  }
}
