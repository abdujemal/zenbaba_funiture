import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../constants.dart';
import '../../data/model/expense_category_model.dart';

class ExpenseCategoryCard extends StatefulWidget {
  final ExpenseCategoryModel expenseCategoryModel;
  const ExpenseCategoryCard({
    super.key,
    required this.expenseCategoryModel,
  });

  @override
  State<ExpenseCategoryCard> createState() => _ExpenseCategoryCardState();
}

class _ExpenseCategoryCardState extends State<ExpenseCategoryCard> {
  @override
  Widget build(BuildContext context) {
    ExpenseCategoryModel model = widget.expenseCategoryModel;
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        right: 5,
        left: 5,
      ),
      child: Card(
        elevation: 10,
        color: mainBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: PieChart(
                  dataMap: {
                    model.title: model.persontage,
                    "other": 100 - model.persontage
                  },
                  gradientList: [
                    [Colors.orange, primaryColor],
                    [backgroundColor, backgroundColor]
                  ],
                  ringStrokeWidth: 5,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  legendOptions: const LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: false,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: false,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${model.persontage.round()}% of expense",
                    style: TextStyle(
                      color: textColor,
                    ),
                  )
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.price} birr",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${model.numOfTransaction} transactions",
                    style: TextStyle(
                      color: textColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
