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
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          PieChart(
            dataMap: {
              model.title: model.persontage,
              "other": 100 - model.persontage
            },
            colorList: [
              primaryColor,
              greyColor,
            ],
            ringStrokeWidth: 5,
            chartRadius: 50,
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
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${model.persontage.round()}% of expense",
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                ),
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${formatNumber(model.price.round())} br",
                style: TextStyle(fontSize: 15, color: primaryColor),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${model.numOfTransaction} transactions",
                style: TextStyle(color: textColor, fontSize: 12),
              )
            ],
          ),
        ],
      ),
    );
  }
}
