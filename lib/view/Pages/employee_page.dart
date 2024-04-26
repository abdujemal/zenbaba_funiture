import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/Pages/add_emploee_page.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/view/widget/employee_item.dart';

import '../../constants.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  LSController lsController = Get.find<LSController>();

  @override
  void initState() {
    super.initState();
    mainConntroller.getEmployees();
  }

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
          ),
          IconButton(
            onPressed: () {
              mainConntroller.getEmployees();
            },
            icon: const Icon(
              Icons.refresh_rounded,
              size: 30,
            ),
          )
        ],
      ),
      floatingActionButton:
          lsController.currentUser.value.priority != UserPriority.AdminView
              ? FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    Get.to(() => const AddEmployeePage());
                  },
                  child: SvgPicture.asset(
                    "assets/plus.svg",
                    height: 20,
                    width: 20,
                  ),
                )
              : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await mainConntroller.getEmployees();
        },
        backgroundColor: mainBgColor,
        color: primaryColor,
        child: Obx(() {
          return mainConntroller.getEmployeeStatus.value == RequestState.loading
              ? Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
              : mainConntroller.employees.isEmpty
                  ? const Center(
                      child: Text("No Employee"),
                    )
                  : ListView.builder(
                      itemCount: mainConntroller.employees.length,
                      itemBuilder: (context, index) => EmployeeItem(
                          employeeModel: mainConntroller.employees[index]),
                    );
        }),
      ),
    );
  }
}
