import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/view/controller/main_controller.dart';
import 'package:zenbaba_funiture/view/widget/employee_activity_item.dart';

import '../../constants.dart';
import '../../data/model/employee_model.dart';

class EmployeeActivityPage extends StatefulWidget {
  final EmployeeModel employeeModel;
  const EmployeeActivityPage({super.key, required this.employeeModel});

  @override
  State<EmployeeActivityPage> createState() => _EmployeeActivityPageState();
}

class _EmployeeActivityPageState extends State<EmployeeActivityPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  final ScrollController _scrollController = ScrollController();

  bool isAtTheBottom = false;

  @override
  void initState() {
    super.initState();

    // getall the activities
    mainConntroller.getEmployeeActivity(widget.employeeModel.id!).then((value) {
      final today = DateTime.now().toString().split(" ")[0];
      final lastActivites = mainConntroller.employeesActivities.isNotEmpty
          ? mainConntroller.employeesActivities.last
          : null;
      final dnceTodaynLastDay = lastActivites != null
          ? DateTime.now().difference(DateTime.parse(lastActivites.date)).inDays
          : 0;

      if (mainConntroller.employeesActivities.isEmpty) {
        // no activities it starts from today
        mainConntroller.addUpdateEmployeeActivity(
          EmployeeActivityModel(
            id: null,
            employeeId: widget.employeeModel.id!,
            employeeName: widget.employeeModel.name,
            date: today,
            payment: 0,
            orders: const [],
            morning: false,
            afternoon: false,
            itemsUsed: const [],
          ),
          getBack: false,
        );
      } else if (dnceTodaynLastDay > 0) {
        // there is activities takes the last activity and
        // add activity until today
        addActivitiesUntilToday(dnceTodaynLastDay);
      }
    });
  }

  addActivitiesUntilToday(int numOfDays) {
    int i = numOfDays;
    while (i > 0) {
      print("Just added: ${DateTime.now().add(Duration(days: -(i - 1))).day}");
      mainConntroller.addUpdateEmployeeActivity(
          EmployeeActivityModel(
            id: null,
            employeeId: widget.employeeModel.id!,
            date: DateTime.now()
                .add(Duration(days: -(i - 1)))
                .toString()
                .split(" ")[0],
            employeeName: widget.employeeModel.name,
            payment: 0,
            orders: const [],
            morning: false,
            afternoon: false,
            itemsUsed: const [],
          ),
          getBack: false);
      i--;
    }
  }

  _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as desired
      curve: Curves.easeInOut, // Adjust the curve as desired
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isAtTheBottom
          ? null
          : FloatingActionButton(
              backgroundColor: mainBgColor,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
              ),
              onPressed: () {
                _scrollToEnd();
              },
            ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: mainBgColor,
        title: Row(
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
                    Get.to(
                      () => EmployeeActivityPage(
                        employeeModel: widget.employeeModel,
                      ),
                    );
                  },
                  child: Ink(
                    child: CircleAvatar(
                      backgroundImage:
                          ds.data != null ? FileImage(ds.data!) : null,
                      radius: 25,
                      child: ds.data == null
                          ? const Icon(
                              Icons.image,
                              size: 30,
                            )
                          : null,
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
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
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
          IconButton(
            onPressed: () {
              launchUrl(Uri.parse("tel:${widget.employeeModel.phoneNo}"));
            },
            icon: SvgPicture.asset(
              "assets/call.svg",
              height: 25,
              color: Colors.white70,
            ),
          )
        ],
      ),
      body: Obx(
        () {
          return mainConntroller.getEmployeeActivityStatus.value ==
                      RequestState.loading ||
                  mainConntroller.employeeStatus.value == RequestState.loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () async {
                    await mainConntroller.getEmployeeActivity(
                      widget.employeeModel.id!,
                      quantity: DateTime.parse(
                              mainConntroller.employeesActivities[0].date)
                          .add(const Duration(days: -2))
                          .day,
                      isNew: false,
                    );
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    padding: const EdgeInsets.all(15),
                    itemCount: mainConntroller.employeesActivities.length,
                    itemBuilder: (context, index) {
                      int currentMonth = int.parse(mainConntroller
                          .employeesActivities[index].date
                          .split("-")[1]);
                      int lastMonth = index > 0
                          ? int.parse(mainConntroller
                              .employeesActivities[index - 1].date
                              .split("-")[1])
                          : 0;

                      return EmployeeActivityItem(
                        employeeActivityModel:
                            mainConntroller.employeesActivities[index],
                        isLast:
                            mainConntroller.employeesActivities.length - 1 ==
                                index,
                        isDiffenrentMonth: currentMonth > lastMonth,
                      );
                    },
                  ),
                );
        },
      ),
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
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 17,
            ),
          ),
        )
      ],
    );
  }
}
