import 'package:flutter/material.dart';

class DateItem extends StatelessWidget {
  final String date;
  final TextStyle? style;
  const DateItem({super.key, required this.date, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20),
      child: Text(date, style: style,),
    );
  }
}
