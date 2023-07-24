import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/products_tab.dart';

import '../../constants.dart';
import '../../injection.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';
import '../widget/add_dialogue.dart';
import '../widget/bottom_nav.dart';
import 'budget_tab.dart';
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
    const BudgetTab(),
    const ProductTab()
  ];

  MainConntroller mainConntroller = Get.put(di<MainConntroller>());
  LSController lsController = Get.put(di<LSController>());

  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 4,
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: BottomNav(controller: tabController!),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          if (lsController.currentUser.value.priority !=
              UserPriority.Delivery) {
            mainConntroller.toggleAddDialogue();
          } else {
            toast("You can't add any thing.", ToastType.error);
          }
        },
        child: Card(
          color: whiteColor,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Obx(() {
              return Icon(
                mainConntroller.isAddDialogueOpen.value
                    ? FontAwesomeIcons.times
                    : FontAwesomeIcons.plus,
                size: 30,
                color: primaryColor,
              );
            }),
          ),
        ),
      ),
      body: Obx(
        () => Stack(
          children: [
            TabBarView(controller: tabController, children: tabBodies),
            // tabBodies[mainConntroller.currentTabIndex.value],
            AnimatedPositioned(
              curve: Curves.decelerate,
              bottom: mainConntroller.isAddDialogueOpen.value ? 50 : -280,
              right: MediaQuery.of(context).size.width / 2 - 115,
              duration: const Duration(seconds: 1),
              child: const AddDialogue(),
            )
          ],
        ),
      ),
    );
  }
}
