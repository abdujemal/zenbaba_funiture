import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../injection.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';

class BottomNav extends StatefulWidget {
  final TabController controller;
  final List<String> icons;
  const BottomNav({
    Key? key,
    required this.controller,
    required this.icons,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  LSController lsController = Get.put(di<LSController>());
  MainConntroller mainConntroller = Get.put(di<MainConntroller>());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        right: 10.0,
        left: 10.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          color: primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                widget.icons.length,
                (index) => GestureDetector(
                  onTap: () {
                    if (index == 2) {
                      if (lsController.currentUser.value.priority !=
                          UserPriority.Sells) {
                        widget.controller.index = index;
                        mainConntroller.setCurrentTabIndex(index);
                      } else {
                        toast("You can't access this.", ToastType.error);
                      }
                    } else if (index == 1) {
                      if (lsController.currentUser.value.priority !=
                          UserPriority.Storekeeper) {
                        widget.controller.index = index;
                        mainConntroller.setCurrentTabIndex(index);
                      } else {
                        toast("You can't access this.", ToastType.error);
                      }
                    } else if (index == 3) {
                      if (lsController.currentUser.value.priority !=
                          UserPriority.Storekeeper) {
                        widget.controller.index = index;
                        mainConntroller.setCurrentTabIndex(index);
                      } else {
                        toast("You can't access this.", ToastType.error);
                      }
                    } else {
                      widget.controller.index = index;
                      mainConntroller.setCurrentTabIndex(index);
                    }
                  },
                  child: Obx(() {
                    return SvgPicture.asset(
                      widget.icons[index],
                      color: mainConntroller.currentTabIndex.value == index
                          ? whiteColor
                          : backgroundColor,
                      width: 36,
                      height: 36,
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
