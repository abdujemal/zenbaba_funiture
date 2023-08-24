import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../injection.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';

// ignore: must_be_immutable
class BottomNavItem extends StatelessWidget {
  final String label;
  final IconData iconData;
  final IconData activeIcon;
  final int index;
  final void Function() onTap;

BottomNavItem(
      {Key? key,
      required this.activeIcon,
      required this.label,
      required this.iconData,
      required this.index,
      required this.onTap,})
      : super(key: key);

  LSController lsController = Get.put(di<LSController>());
  MainConntroller mainConntroller = Get.put(di<MainConntroller>());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        height: 70,
        width: 60,
        child: Center(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  mainConntroller.currentTabIndex.value == index
                      ? activeIcon
                      : iconData,
                  color: whiteColor,
                  size: 40,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  label,
                  style: TextStyle(color: whiteColor, fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
