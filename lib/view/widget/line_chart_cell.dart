
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../constants.dart';

class LineChartCell extends StatefulWidget {
  final double right;
  final double left;
  final String title;
  final double biggetVal;
  const LineChartCell({
    super.key,
    required this.left,
    required this.right,
    required this.title,
    required this.biggetVal,
  });

  @override
  State<LineChartCell> createState() => _LineChartCellState();
}

class _LineChartCellState extends State<LineChartCell> {
  double height = 170;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          width: 20,
          decoration: BoxDecoration(
            color: mainBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: widget.biggetVal == 0 ? 0 : height * widget.left / widget.biggetVal,
                width: 10,
                decoration: const BoxDecoration(
                  color: Color(0xffa87b51),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(10),
                    ),
                ),
              ),
              Container(
                height: widget.biggetVal == 0 ? 0 : height * widget.right / widget.biggetVal,
                width: 10,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          widget.title,
        ),
      ],
    );
  }
}
