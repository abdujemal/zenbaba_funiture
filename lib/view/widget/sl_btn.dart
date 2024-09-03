import 'package:flutter/material.dart';

import '../../constants.dart';

class SLBtn extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final bool outlined;
  const SLBtn({
    Key? key,
    required this.text,
    required this.onTap,
    this.outlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: outlined ? null : primaryColor,
          borderRadius: BorderRadius.circular(15),
          border: outlined
              ? Border.all(
                  color: whiteColor,
                )
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: outlined ? null : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
