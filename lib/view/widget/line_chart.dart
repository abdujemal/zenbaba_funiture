import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../data/model/line_chart_model.dart';

class LineChartSample extends StatefulWidget {
  const LineChartSample({
    super.key,
    required this.dataType,
    required this.bigPrice,
    required this.data,
    required this.displayType,
    required this.isStatic,
  });
  final List<LineChartModel> data;
  final bool isStatic;
  final String dataType; // Month, Year, Last Week, Last Month, Last Year
  final double bigPrice;
  final String displayType; // income, expense

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  List<FlSpot> expenseLineData = [];
  List<FlSpot> incomeLineData = [];

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

  double topPrice = 0;

  @override
  Widget build(BuildContext context) {
    expenseLineData = [];
    incomeLineData = [];

    print("big price: ${widget.bigPrice}");
    for (LineChartModel lineChart in widget.data) {
      if (widget.isStatic) {
        double xVal = widget.dataType == "Month"
            ? (int.parse(lineChart.title) / 2.142857142857143)
            : months.indexOf(lineChart.title).toDouble();

        if (widget.bigPrice <= 20000) {
          topPrice = 20000;
        } else if (widget.bigPrice <= 100000) {
          topPrice = 100000;
        } else if (widget.bigPrice <= 400000) {
          topPrice = 400000;
        } else if (widget.bigPrice <= 1600000) {
          topPrice = 1600000;
        } else {
          topPrice = 6400000;
        }

        double yValExpense = (lineChart.rightVal / topPrice) * 4;
        double yValIncome = (lineChart.leftVal / topPrice) * 4;

        if (expenseLineData.isEmpty) {
          expenseLineData.add(const FlSpot(0, 0));
        }

        if (incomeLineData.isEmpty) {
          incomeLineData.add(const FlSpot(0, 0));
        }

        expenseLineData.add(FlSpot(xVal + 1, yValExpense));
        incomeLineData.add(FlSpot(xVal + 1, yValIncome));
      } else {
        double xVal = double.parse(lineChart.title);

        if (widget.bigPrice <= 20000) {
          topPrice = 20000;
        } else if (widget.bigPrice <= 100000) {
          topPrice = 100000;
        } else if (widget.bigPrice <= 400000) {
          topPrice = 400000;
        } else if (widget.bigPrice <= 1600000) {
          topPrice = 1600000;
        } else {
          topPrice = 6400000;
        }

        double yValExpense = (lineChart.rightVal / topPrice) * 4;
        double yValIncome = (lineChart.leftVal / topPrice) * 4;

        if (expenseLineData.isEmpty) {
          expenseLineData.add(const FlSpot(0, 0));
        }

        if (incomeLineData.isEmpty) {
          incomeLineData.add(const FlSpot(0, 0));
        }

        expenseLineData.add(FlSpot(xVal + 1, yValExpense));
        incomeLineData.add(FlSpot(xVal + 1, yValIncome));
      }
    }
    setState(() {});
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 500),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) => touchedSpots.map((e) {
            if (widget.displayType == "Income" && e.barIndex == 1) {
              return LineTooltipItem(
                shortenNum((e.y / 4 * topPrice).round()),
                TextStyle(
                  color: textColor,
                ),
              );
            }
            if (widget.displayType == "Expense" && e.barIndex == 1) {
              return LineTooltipItem(
                shortenNum((e.y / 4 * topPrice).round()),
                TextStyle(
                  color: textColor,
                ),
              );
            }
          }).toList(),
          tooltipBgColor: mainBgColor,
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        if (widget.displayType == "Expense") ...[
          lineChartBarData1_2,
          lineChartBarData1_1,
        ],
        if (widget.displayType == "Income") ...[
          lineChartBarData1_1,
          lineChartBarData1_2,
        ],
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    if (widget.bigPrice <= 20000) {
      switch (value.toInt()) {
        case 1:
          text = '1k';
          break;
        case 2:
          text = '5k';
          break;
        case 3:
          text = '10k';
          break;
        case 4:
          text = '20k';
          break;
        default:
          return Container();
      }
    } else if (widget.bigPrice <= 100000) {
      switch (value.toInt()) {
        case 1:
          text = '20k';
          break;
        case 2:
          text = '40k';
          break;
        case 3:
          text = '80k';
          break;
        case 4:
          text = '100k';
          break;
        default:
          return Container();
      }
    } else if (widget.bigPrice <= 400000) {
      switch (value.toInt()) {
        case 1:
          text = '100k';
          break;
        case 2:
          text = '200k';
          break;
        case 3:
          text = '300k';
          break;
        case 4:
          text = '400k';
          break;
        default:
          return Container();
      }
    } else if (widget.bigPrice <= 1600000) {
      switch (value.toInt()) {
        case 1:
          text = '400k';
          break;
        case 2:
          text = '800k';
          break;
        case 3:
          text = '1.2M';
          break;
        case 4:
          text = '1.6M';
          break;
        default:
          return Container();
      }
    } else {
      switch (value.toInt()) {
        case 1:
          text = '1.6M';
          break;
        case 2:
          text = '3.2M';
          break;
        case 3:
          text = '4.8M';
          break;
        case 4:
          text = '6.4M';
          break;
        default:
          return Container();
      }
    }

    return Text(
      text,
      style: style,
      textAlign: TextAlign.center,
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    if (widget.isStatic) {
      if (widget.dataType == "Year") {
        switch (value.toInt()) {
          case 1:
            text = Text('Jun', style: style);
            break;
          case 4:
            text = Text('Apr', style: style);
            break;
          case 7:
            text = Text('Jul', style: style);
            break;
          case 10:
            text = Text('Oct', style: style);
            break;
          case 13:
            text = Text('Dec', style: style);
            break;
          default:
            text = const Text('');
            break;
        }
      } else {
        switch (((value / 14) * 30).toInt()) {
          case 2:
            text = Text('02', style: style);
            break;
          case 10:
            text = Text('10', style: style);
            break;
          case 21:
            text = Text('21', style: style);
            break;
          case 30:
            text = Text('30', style: style);
            break;
          default:
            text = const Text('');
            break;
        }
      }
    } else {
      if (widget.dataType == "Last Week") {
        text = Text(
          value % 2 == 0
              ? ""
              : DateFormat("E").format(
                  DateTime.now().add(
                    Duration(
                      days: ((value / 14) * 7).round(),
                    ),
                  ),
                ),
          style: style,
        );
      } else if (widget.dataType == "Last Month") {
        text = Text(
            DateFormat("dd").format(
              DateTime.now().add(
                Duration(
                  days: ((value / 14) * 30).round(),
                ),
              ),
            ),
            style: style);
      } else {
        text = Text(
          // // !List.generate(12, (i) => (i / 12) * 14).contains(value)
          // value % 2 == 0 ? "m" : "",
          DateFormat("MM").format(
            DateTime.now().add(
              Duration(
                days: ((value / 14) * 365).round(),
              ),
            ),
          ),
          style: style,
        );
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: widget.displayType == "Expense"
            ? primaryColor
            : greyColor.withAlpha(120),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        preventCurveOverShooting: true,
        belowBarData: BarAreaData(show: false),
        spots: expenseLineData,
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: widget.displayType == "Income"
            ? primaryColor
            : greyColor.withAlpha(120),
        barWidth: 3,
        isStrokeCapRound: true,
        preventCurveOverShooting: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: incomeLineData,
      );
}
