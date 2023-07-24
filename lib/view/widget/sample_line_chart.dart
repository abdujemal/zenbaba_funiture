// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../data/model/line_chart_model.dart';
import 'line_chart_cell.dart';

class SampleLineChart extends StatefulWidget {
  final List<LineChartModel> data;
  final double totalExpense;
  final double totalIncome;
  final double biggetPrice;
  const SampleLineChart({
    Key? key,
    required this.data,
    required this.totalExpense,
    required this.totalIncome,
    required this.biggetPrice,
  }) : super(key: key);

  @override
  State<SampleLineChart> createState() => _SampleLineChartState();
}

class _SampleLineChartState extends State<SampleLineChart> {

  indicator(String title, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 7,
              backgroundColor: color,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(title)
          ],
        ),
        const SizedBox(
          height: 13,
        ),
        Text(
          "$value Br",
          style: TextStyle(fontSize: 20, color: textColor),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.data.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: LineChartCell(
                    biggetVal: widget.biggetPrice,
                    left: widget.data[index].leftVal,
                    right: widget.data[index].rightVal,
                    title: widget.data[index].title),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            indicator("expense", widget.totalExpense, primaryColor),
            const SizedBox(
              width: 40,
            ),
            indicator('income', widget.totalIncome, const Color(0xffa87b51))
          ],
        )
      ],
    );
  }
}
