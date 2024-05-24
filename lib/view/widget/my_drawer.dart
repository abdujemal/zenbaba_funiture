import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../Pages/account_page.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  LSController lsController = Get.find<LSController>();
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  List<String> adminMenu = [
    "Main",
    "Expenses",
    "Employees",
    "Items",
    "Calender",
    "Customers",
    "Users",
  ];

  List<String> adminViewMenu = [
    "Main",
    "Expenses",
    "Employees",
    "Items",
    "Calender",
    "Customers",
  ];

  List<String> sellsMenu = [
    "Main",
    "Calender",
    "Customers",
  ];

  List<String> storeKeeperMenu = [
    "Main",
    "Items",
  ];

  List<String> workshopManagerMenu = [
    "Main",
    "Employees",
    "Calender",
  ];

  List<String> designerMenu = [
    "Main",
    "Items",
    "Calender",
  ];

  File? imageFile;

  @override
  void initState() {
    super.initState();
    setImageFile();
  }

  setImageFile() async {
    imageFile = await displayImage(lsController.currentUser.value.image!,
        lsController.currentUser.value.id!, FirebaseConstants.users);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 110,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const AccountPage());
              },
              child: Row(
                children: [
                  kIsWeb
                      ? CircleAvatar(
                          radius: 29,
                          backgroundImage: CachedNetworkImageProvider(
                            lsController.currentUser.value.image!,
                          ),
                          backgroundColor: backgroundColor,
                        )
                      : CircleAvatar(
                          radius: 29,
                          backgroundImage:
                              imageFile != null && imageFile!.path != ""
                                  ? FileImage(imageFile!)
                                  : null,
                          backgroundColor: backgroundColor,
                          child: Center(
                            child: imageFile == null
                                ? CircularProgressIndicator(
                                    color: primaryColor,
                                  )
                                : imageFile!.path == ""
                                    ? const Icon(
                                        Icons.signal_wifi_off_sharp,
                                        size: 29,
                                      )
                                    : const SizedBox(),
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 101,
                        child: Text(
                          lsController.currentUser.value.name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(lsController.currentUser.value.priority,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  getMenu(lsController.currentUser.value.priority).length,
                  (index) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(onTap: () {
                          mainConntroller.setMainIndex(index);
                          mainConntroller.z.value.close!();
                        }, child: Obx(() {
                          return Text(
                            getMenu(
                                lsController.currentUser.value.priority)[index],
                            style: TextStyle(
                                fontSize: 18,
                                color: whiteColor,
                                fontWeight:
                                    mainConntroller.mainIndex.value == index
                                        ? FontWeight.bold
                                        : FontWeight.w400),
                          );
                        })),
                      )),
            ),
            const Spacer(),
            Obx(() {
              return lsController.logoutState.value == RequestState.loading
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: whiteColor,
                      ),
                      title: const Text("Logout"),
                      onTap: () {
                        lsController.logout();
                      },
                    );
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  getMenu(String priority) {
    if (priority == UserPriority.Admin) {
      return adminMenu;
    } else if (priority == UserPriority.AdminView) {
      return adminViewMenu;
    } else if (priority == UserPriority.Sells) {
      return sellsMenu;
    } else if (priority == UserPriority.Storekeeper) {
      return storeKeeperMenu;
    } else if (priority == UserPriority.WorkShopManager) {
      return workshopManagerMenu;
    } else if (priority == UserPriority.HR ||
        priority == UserPriority.HrAndStoreKeeper) {
      return adminViewMenu;
    } else {
      return designerMenu;
    }
  }
}
