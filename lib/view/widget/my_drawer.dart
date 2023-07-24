import 'dart:io';

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

  List<String> menu = [
    "Main",
    "Expenses",
    "Employees",
    "Items",
    "Stock",
    "Calender",
    "Customers",
    "Users",
  ];

  List<String> menu2 = [
    "Main",
    "Items",
    "Stock",
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
                  CircleAvatar(
                    radius: 29,
                    backgroundImage: imageFile != null && imageFile!.path != ""
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
                                : const SizedBox()),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lsController.currentUser.value.name,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(lsController.currentUser.value.priority,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400)),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  lsController.currentUser.value.priority == UserPriority.Admin
                      ? menu.length
                      : menu2.length,
                  (index) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(onTap: () {
                          mainConntroller.setMainIndex(index);
                          mainConntroller.z.value.close!();
                        }, child: Obx(() {
                          return Text(
                            lsController.currentUser.value.priority ==
                                    UserPriority.Admin
                                ? menu[index]
                                : menu2[index],
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
                      leading: const Icon(Icons.logout),
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
}
