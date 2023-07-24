import 'package:flutter/material.dart';

import '../../constants.dart';

class SpecialDropdown<T> extends StatefulWidget {
  final String title;
  final double? margin;
  final double width;
  final T value;
  final List<T> list;
  final void Function(T value)? onChange;
  const SpecialDropdown({
    super.key,
    required this.title,
    this.margin,
    required this.value,
    required this.width,
    required this.list,
    required this.onChange
  });

  @override
  State<SpecialDropdown> createState() => _SpecialDropdownState<T>(list);
}

class _SpecialDropdownState<T> extends State<SpecialDropdown> {
  final List<T> list;
  _SpecialDropdownState(this.list);
  @override
  Widget build(BuildContext context) {
    var name;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.margin ?? 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              widget.title,
              style: TextStyle(color: textColor),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: widget.width,
            decoration: BoxDecoration(
                border: Border.all(color: textColor),
                borderRadius: BorderRadius.circular(3)),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                  // Initial Value
                  value: widget.value,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  dropdownColor: backgroundColor,
                  // Array list of items
                  items: list.map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text("Othe"),),).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: widget.onChange
                  // expenseCategoryTc.text = newValue;

                  ),
            ),
          ),
        ],
      ),
    );
  }
}
