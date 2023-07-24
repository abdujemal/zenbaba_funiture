import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../injection.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';
import 'bottom_nav_item.dart';

class BottomNav extends StatefulWidget {
  TabController controller;
  BottomNav({Key? key, required this.controller}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  LSController lsController = Get.put(di<LSController>());
  MainConntroller mainConntroller = Get.put(di<MainConntroller>());
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavItem(
                onTap: () {
                  widget.controller.index = 0;
                  mainConntroller.setCurrentTabIndex(0);
                },
                label: "Home",
                iconData: Icons.home_outlined,
                activeIcon: Icons.home_filled,
                index: 0,
              ),
              BottomNavItem(
                onTap: () {
                  widget.controller.index = 1;
                  mainConntroller.setCurrentTabIndex(1);
                },
                label: "Order",
                iconData: Icons.delivery_dining_outlined,
                activeIcon: Icons.delivery_dining,
                index: 1,
              ),
              const SizedBox(
                width: 40,
              ),
              BottomNavItem(
                onTap: () {
                  if (lsController.currentUser.value.priority !=
                      UserPriority.Admin) {
                    toast("You can't access budget.", ToastType.error);
                  } else {
                    widget.controller.index = 2;
                    mainConntroller.setCurrentTabIndex(2);
                  }
                },
                label: "Budget",
                iconData: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                index: 2,
              ),
              BottomNavItem(
                onTap: () {
                  widget.controller.index = 3;
                  mainConntroller.setCurrentTabIndex(3);
                },
                label: "Products",
                iconData: Icons.star_outline,
                activeIcon: Icons.star,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
