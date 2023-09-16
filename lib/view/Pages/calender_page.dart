import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/order_model.dart';
import '../controller/main_controller.dart';
import '../widget/event_dialog.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();

  var calController = EventController<OrderModel?>();

  List<String> weekDays = [
    "M",
    "T",
    "W",
    "T",
    "F",
    "S",
    "S",
  ];

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  getEvents() async {
    await mainConntroller.getOrders(status: OrderStatus.Pending);
    for (OrderModel orderModel in mainConntroller.pendingOrders) {
      calController.add(
        CalendarEventData(
          event: orderModel,
          title: orderModel.productName,
          date: DateTime.parse(
            orderModel.finishedDate,
          ),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Calender"),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/menu icon.svg',
            color: whiteColor,
            height: 21,
          ),
          onPressed: () {
            mainConntroller.z.value.open!();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              mainConntroller.getOrders(status: OrderStatus.Pending);
            },
            icon: const Icon(
              Icons.refresh,
              size: 30,
            ),
          ),
        ],
      ),
      body: MonthView<OrderModel?>(
        controller: calController,

        // to provide custom UI for month cells.
        cellBuilder: (date, events, isToday, isInMonth) {
          DateTime today =
              DateTime.parse(DateTime.now().toString().split(" ")[0]);
          // Return your widget to display as month cell.

          decoration() {
            if (date.toString() == today.toString()) {
              return BoxDecoration(
                color: whiteColor,
                shape: BoxShape.circle,
              );
            } else if (events.isNotEmpty) {
              return BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              );
            }
            return null;
          }

          return Center(
            child: Stack(
              children: [
                Container(
                  decoration: decoration(),
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: events.isNotEmpty ||
                                date.toString() == today.toString()
                            ? Colors.black
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        borderSize: 0,
        borderColor: backgroundColor,
        weekDayBuilder: (day) {
          return SizedBox(
            height: 60,
            child: Center(
                child: Text(
              weekDays[day],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            )),
          );
        },
        headerStyle: HeaderStyle(
            decoration: BoxDecoration(color: backgroundColor),
            leftIcon: const Icon(Icons.keyboard_arrow_left),
            rightIcon: const Icon(Icons.keyboard_arrow_right)),
        headerStringBuilder: (date, {secondaryDate}) {
          return "${months[date.month - 1]} ${date.year}";
        },
        minMonth: DateTime(1990),
        maxMonth: DateTime(2050),
        initialMonth: DateTime.now(),
        cellAspectRatio: 1,
        onCellTap: (events, date) {
          // Implement callback when user taps on a cell.
          // print(events);
          Get.bottomSheet(EventDialog(
            events: events,
            date: date,
            month: months[date.month - 1],
          ));
        },
        startDay: WeekDays.sunday, // To change the first day of the week.
      ),
    );
  }
}
