import 'package:flutter/material.dart';
import 'package:zenbaba_funiture/constants.dart';

class LeftLined extends StatelessWidget {
  final Color circleColor;
  final double? topHeight;
  final VoidCallback onTap;
  final bool isLast;
  final Widget child;
  final double pt;
  final bool showBottomBorder;
  final bool isOff;
  const LeftLined({
    super.key,
    required this.circleColor,
    this.topHeight = 35,
    required this.onTap,
    required this.isLast,
    required this.child,
    this.isOff = false,
    this.pt = 10,
    this.showBottomBorder = true,
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
              padding: EdgeInsets.only(top: pt, bottom: pt),
              decoration: BoxDecoration(
                border: Border(
                  bottom: showBottomBorder
                      ? BorderSide(
                          color: whiteColor,
                          width: .5,
                        )
                      : BorderSide.none,
                ),
              ),
              child: child,
            ),
          ),
        ),
        if (isLast)
          Positioned(
            left: 2.7,
            child: Container(
              height: topHeight,
              width: 1.5,
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
          ),
        Positioned(
          top: isOff ? 25 : topHeight,
          child: isOff
              ? Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.work_off_outlined,
                    color: Colors.white,
                    size: 19,
                  ),
                )
              : Container(
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
