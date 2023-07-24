import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../data/model/order_model.dart';
import 'order_item.dart';

class EventDialog extends StatefulWidget {
  final List<CalendarEventData<OrderModel?>> events;
  final DateTime date;
  final String month;
  const EventDialog({
    super.key,
    required this.events,
    required this.date,
    required this.month,
  });

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  DateTime today = DateTime.parse(DateTime.now().toString().split(" ")[0]);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        right: 10,
        left: 10,
        bottom: 10,
      ),
      height: 400,
      decoration: BoxDecoration(
        color: mainBgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          title(widget.date.toString() == today.toString()
              ? "Orders today"
              : "Orders in ${widget.date.day} ${widget.month}"),
          const SizedBox(
            height: 20,
          ),
          widget.events.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    "No orders.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: widget.events.length,
                    itemBuilder: (context, index) {
                      return OrderItem(
                        orderModel: widget.events[index].event!,
                        isDelivery:
                            widget.events[index].event!.deliveryOption ==
                                DeliveryOption.delivery,
                        isFinished: widget.events[index].event!.status ==
                            OrderStatus.Delivered,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
