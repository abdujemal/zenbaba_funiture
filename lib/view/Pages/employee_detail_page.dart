import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/employee_model.dart';
import 'package:zenbaba_funiture/view/Pages/add_emploee_page.dart';
import 'package:zenbaba_funiture/view/Pages/employee_activities_page.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final EmployeeModel employeeModel;
  const EmployeeDetailsPage({
    super.key,
    required this.employeeModel,
  });

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  LSController lsController = Get.find<LSController>();

  double absent = 0;
  double late = 0;
  List<String> orders = [];
  List<String> itemsUsed = [];

  @override
  void initState() {
    super.initState();

    mainConntroller.getEmployeeActivity(widget.employeeModel.id!).then(
      (value) {
        for (final model in mainConntroller.employeesActivities) {
          orders = [...orders, ...model.orders];
          itemsUsed = [...itemsUsed, ...model.itemsUsed];

          if (model.morning == EmployeeAttendance.absent) {
            absent += 0.5;
          }
          if (model.afternoon == EmployeeAttendance.absent) {
            absent += 0.5;
          }

          if (model.morning == EmployeeAttendance.late) {
            late += 0.5;
          }
          if (model.afternoon == EmployeeAttendance.late) {
            late += 0.5;
          }
        }
      },
    );
  }

  Widget myKeyVal(String key, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: TextStyle(
            color: primaryColor,
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            val,
            style: TextStyle(
              color: whiteColor,
              fontSize: 17,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainBgColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
            "assets/back.svg",
            color: Colors.white,
            height: 21,
          ),
        ),
        actions: [
          lsController.currentUser.value.priority != UserPriority.AdminView
              ? IconButton(
                  onPressed: () {
                    Get.to(
                      () => AddEmployeePage(
                        employeeModel: widget.employeeModel,
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    "assets/edit.svg",
                    color: Colors.white,
                    height: 21,
                  ),
                )
              : const SizedBox(),
          IconButton(
            onPressed: () {
              launchUrl(Uri.parse("tel:${widget.employeeModel.phoneNo}"));
            },
            icon: SvgPicture.asset(
              "assets/call.svg",
              height: 21,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              decoration: BoxDecoration(
                color: mainBgColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FutureBuilder(
                        future: displayImage(
                          widget.employeeModel.imgUrl!,
                          widget.employeeModel.id!,
                          FirebaseConstants.employees,
                        ),
                        builder: (context, ds) {
                          return InkWell(
                            onTap: () {
                              if (lsController.currentUser.value.priority !=
                                  UserPriority.AdminView) {
                                Get.to(
                                  () => EmployeeActivityPage(
                                    employeeModel: widget.employeeModel,
                                  ),
                                );
                              }
                            },
                            child: Ink(
                              child: ds.data != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(ds.data!),
                                      radius: 25,
                                    )
                                  : kIsWeb
                                      ? CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            widget.employeeModel.imgUrl!,
                                          ),
                                          radius: 25,
                                        )
                                      : const CircleAvatar(
                                          child: CircularProgressIndicator(),
                                        ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.employeeModel.name,
                            style: TextStyle(
                              fontSize: 23,
                              color: whiteColor,
                            ),
                          ),
                          Text(
                            widget.employeeModel.position,
                            style: TextStyle(color: primaryColor, fontSize: 17),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      myKeyVal(
                        "Name",
                        widget.employeeModel.name,
                      ),
                      const Spacer(),
                      myKeyVal(
                        "Phone no",
                        widget.employeeModel.phoneNo,
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  myKeyVal(
                    "Age",
                    widget.employeeModel.age,
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  myKeyVal(
                    "Location",
                    widget.employeeModel.location,
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      myKeyVal(
                        "Postion",
                        widget.employeeModel.position,
                      ),
                      const Spacer(),
                      myKeyVal(
                        "Type",
                        widget.employeeModel.type,
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),
                  if (widget.employeeModel.type != EmployeeType.contract)
                    const SizedBox(
                      height: 10,
                    ),
                  if (widget.employeeModel.type != EmployeeType.contract)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        myKeyVal(
                          "Payment",
                          widget.employeeModel.payment,
                        ),
                        Text(
                          "   (${widget.employeeModel.salaryType})",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  if (widget.employeeModel.type != EmployeeType.contract)
                    const Divider(
                      thickness: 1,
                      color: Colors.white24,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  myKeyVal(
                    "Start Date",
                    DateFormat("dd MMM / yyyy").format(
                        DateTime.parse(widget.employeeModel.startFromDate)),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white24,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() {
              return mainConntroller.getEmployeeActivityStatus.value ==
                      RequestState.loading
                  ? Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: mainBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Overview",
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                              const Spacer(),
                              if (widget.employeeModel.type !=
                                  EmployeeType.contract)
                                Text(
                                  widget.employeeModel.salaryType ==
                                          SalaryType.weekly
                                      ? "This week"
                                      : "This month",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              const SizedBox(
                                width: 30,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.employeeModel.type !=
                                    EmployeeType.contract)
                                  myKeyVal("Absent", "$absent"),
                                if (widget.employeeModel.type !=
                                    EmployeeType.contract)
                                  const Divider(
                                    color: Colors.white24,
                                    thickness: 1,
                                  ),
                                if (widget.employeeModel.type !=
                                    EmployeeType.contract)
                                  myKeyVal("Late", "$late"),
                                if (widget.employeeModel.type !=
                                    EmployeeType.contract)
                                  const Divider(
                                    color: Colors.white24,
                                    thickness: 1,
                                  ),
                                if (widget.employeeModel.type !=
                                    EmployeeType.contract)
                                  const SizedBox(
                                    height: 15,
                                  ),
                                myKeyVal(
                                  "Orders",
                                  orders.isEmpty
                                      ? "No Orders"
                                      : orders.join("\n"),
                                ),
                                const Divider(
                                  color: Colors.white24,
                                  thickness: 1,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                myKeyVal(
                                  "Items",
                                  itemsUsed.isEmpty
                                      ? "No Items"
                                      : itemsUsed.join("\n"),
                                ),
                                const Divider(
                                  color: Colors.white24,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
