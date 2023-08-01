import 'package:flutter/material.dart';
import 'package:zenbaba_funiture/constants.dart';

class LeftLined extends StatelessWidget {
  final Color circleColor;
  final double? topHeight;
  final VoidCallback onTap;
  final bool isLast;
  final Widget child;
  const LeftLined({
    super.key,
    required this.circleColor,
    this.topHeight = double.infinity,
    required this.onTap,
    required this.isLast, 
    required this.child,
    
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: isLast
                    ? BorderSide.none
                    : BorderSide(
                        color: primaryColor,
                        width: 1.5,
                      ),
              ),
            ),
            margin: const EdgeInsets.only(left: 2.7),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: whiteColor,
                    width: .2,
                  ),
                ),
              ),
              child: child,
              // child: Row(
              //   children: [
              //     Column(
              //       children: [
              //         Text(
              //           DateFormat("EEE, MMM dd, yyyy").format(
              //             (DateTime.parse(widget.employeeActivityModel.date)),
              //           ),
              //           style: const TextStyle(fontWeight: FontWeight.w200),
              //         ),
              //         if (widget.employeeActivityModel.orders.isNotEmpty)
              //           ...List.generate(
              //             widget.employeeActivityModel.orders.length,
              //             (index) => Text(
              //               widget.employeeActivityModel.orders[index],
              //               style: TextStyle(color: primaryColor),
              //             ),
              //           ),
              //         if (widget.employeeActivityModel.orders.isEmpty)
              //           Center(
              //             child: Text(
              //               "...",
              //               style: TextStyle(color: primaryColor),
              //             ),
              //           ),
              //         if (widget.employeeActivityModel.itemsUsed.isNotEmpty)
              //           const Text("Item used"),
              //         if (widget.employeeActivityModel.itemsUsed.isNotEmpty)
              //           ...List.generate(
              //             widget.employeeActivityModel.itemsUsed.length,
              //             (index) => Text(
              //               widget.employeeActivityModel.itemsUsed[index],
              //             ),
              //           ),
              //       ],
              //     ),
              //     const Spacer(),
              //     Column(
              //       children: [
              //         Text(
              //           "morning & afternoon",
              //           style: TextStyle(color: primaryColor),
              //         ),
              //         Text(
              //           "$morning | $afternoon",
              //           style: const TextStyle(
              //             fontWeight: FontWeight.bold,
              //           ),
              //         )
              //       ],
              //     ),
              //     const Spacer()
              //   ],
              // ),
            ),
          ),
        ),
        if (isLast)
          Positioned(
            left: 2.7,
            child: Container(
              height: 35,
              width: 1.5,
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
          ),
        Positioned(
          top: 30,
          child: Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
