import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenbaba_funiture/data/model/employee_activity_model.dart';
import 'package:zenbaba_funiture/domain/entity/employee_activity_entity.dart';
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

  DateTime _selectedDate = DateTime.now();
  late DateTime startDateFrom;

  @override
  void initState() {
    super.initState();

    startDateFrom = DateTime.parse(widget.employeeModel.startFromDate);

    // getall the activities
    mainConntroller.getEmployeeActivity(widget.employeeModel.id!).then((value) {
      final today = DateTime.now().toString().split(" ")[0];
      final lastActivites = mainConntroller.employeesActivities.isNotEmpty
          ? mainConntroller.employeesActivities.last
          : null;
      final dnceTodaynLastDay = lastActivites != null
          ? DateTime.now().difference(DateTime.parse(lastActivites.date)).inDays
          : DateTime.parse(today).difference(startDateFrom).inDays;

      if (mainConntroller.employeesActivities.isEmpty) {
        // no activities it starts from today
        // mainConntroller.addUpdateEmployeeActivity(
        //   EmployeeActivityModel(
        //     id: null,
        //     employeeId: widget.employeeModel.id!,
        //     employeeName: widget.employeeModel.name,
        //     date: today,
        //     payment: 0,
        //     orders: const [],
        //     morning: EmployeeAttendance.present,
        //     afternoon: EmployeeAttendance.present,
        //     itemsUsed: const [],
        //   ),
        //   getBack: false,
        // );
        addActivitiesFromStartToNow(dnceTodaynLastDay);
      } else {
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
          morning: EmployeeAttendance.present,
          afternoon: EmployeeAttendance.present,
          itemsUsed: const [],
        ),
        getBack: false,
      );
      i--;
    }
  }

  addActivitiesFromStartToNow(int numOfDays) {
    print("numOfDays: $numOfDays");
    int i = 0;
    while (i <= numOfDays) {
      mainConntroller.addUpdateEmployeeActivity(
        EmployeeActivityModel(
          id: null,
          employeeId: widget.employeeModel.id!,
          date: startDateFrom.add(Duration(days: i)).toString().split(" ")[0],
          employeeName: widget.employeeModel.name,
          payment: 0,
          orders: const [],
          morning: EmployeeAttendance.present,
          afternoon: EmployeeAttendance.present,
          itemsUsed: const [],
        ),
        getBack: false,
      );
      i++;
    }
  }

  _scrollToItem(int nth, int totalNum) {
    _scrollController.animateTo(
      (nth * 50).toDouble(),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainBgColor,
        child: Icon(
          Icons.calendar_month,
          color: primaryColor,
        ),
        onPressed: () {
          Get.dialog(Dialog(
            child: Container(
              height: 100,
              // width: double.infinity,
              color: backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: ScrollDatePicker(
                      minimumDate: DateTime(2015),
                      maximumDate: DateTime(2100),
                      selectedDate: _selectedDate,
                      locale: const Locale('en'),
                      options: DatePickerOptions(
                        backgroundColor: backgroundColor,
                        isLoop: false,
                      ),
                      scrollViewOptions: const DatePickerScrollViewOptions(
                        month: ScrollViewDetailOptions(
                          textStyle: TextStyle(
                            fontSize: 13,
                          ),
                          selectedTextStyle: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        day: ScrollViewDetailOptions(
                          textStyle: TextStyle(
                            fontSize: 13,
                          ),
                          selectedTextStyle: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        year: ScrollViewDetailOptions(
                          textStyle: TextStyle(
                            fontSize: 13,
                          ),
                          selectedTextStyle: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                      onDateTimeChanged: (DateTime value) {
                        setState(() {
                          _selectedDate = value;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        String m = "${_selectedDate.month}";
                        if (_selectedDate.month < 10) {
                          m = "0$m";
                        }
                        mainConntroller
                            .searchEmployeeActivities(
                          widget.employeeModel.id!,
                          "${_selectedDate.year}",
                          m,
                        )
                            .then((lst) {
                          Future.delayed(const Duration(milliseconds: 200))
                              .then(
                            (value) {
                              _scrollToItem(
                                lst.indexWhere(
                                  (e) =>
                                      DateTime.parse(e.date).day ==
                                      _selectedDate.day,
                                ),
                                lst.length,
                              );
                            },
                          );
                        });
                        Get.back();
                      },
                      icon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));

          // _scrollToEnd();
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
                    child: ds.data != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(ds.data!),
                            radius: 25,
                          )
                        : kIsWeb
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.employeeModel.imgUrl!,
                                ),
                                radius: 25,
                              )
                            : const CircleAvatar(
                                radius: 25,
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
                  color: mainBgColor,
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
                  child: Stack(
                    children: [
                      Positioned.fill(
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
                              isSearchedItem: index ==
                                  mainConntroller.employeesActivities
                                      .indexWhere((e) =>
                                          DateTime.parse(e.date)
                                              .compareTo(_selectedDate) ==
                                          0),
                              employeeActivityModel:
                                  mainConntroller.employeesActivities[index],
                              isLast:
                                  mainConntroller.employeesActivities.length -
                                          1 ==
                                      index,
                              isDiffenrentMonth: currentMonth > lastMonth,
                            );
                          },
                        ),
                      ),
                      if (mainConntroller.employeesActivities.isEmpty)
                        const Center(
                          child: Text("No Activity"),
                        ),
                    ],
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
