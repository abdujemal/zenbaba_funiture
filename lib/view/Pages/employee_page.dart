import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/add_emploee_page.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';

import '../../constants.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Employees"),
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/menu icon.svg',
              color: whiteColor,
              height: 21,
            ),
            onPressed: () {
              mainConntroller.z.value.open!();
            }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.to(() => const AddEmployeePage());
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
