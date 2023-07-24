import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../controller/main_controller.dart';

class MyDropdown extends StatefulWidget {
  final List<String> list;
  final String title;
  final String value;
  final double width;
  final double? margin;
  final void Function(String? value)? onChange;
  const MyDropdown(
      {super.key,
      required this.value,
      required this.list,
      required this.title,     
      required this.onChange,
      this.margin,
      required this.width});

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
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
              child: DropdownButton(
                // Initial Value
                value: widget.value,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                dropdownColor: backgroundColor,
                // Array list of items
                items: widget.list.map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(val, overflow: TextOverflow.ellipsis,),
                  );
                }).toList(),
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
