import 'package:flutter/material.dart';

enum Btn { filled, outlined }

class CustomBtn extends StatefulWidget {
  final Btn btnState;
  final Color color;
  final void Function() onTap;
  final String text;
  final double? width;
  const CustomBtn({
    super.key,
    required this.btnState,
    required this.color,
    required this.onTap,
    required this.text,
    this.width,
  });

  @override
  State<CustomBtn> createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: widget.width ?? 120,
        decoration: widget.btnState == Btn.filled
            ? BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(5, 5))
                  ])
            : BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: widget.color, width: 2),
              ),
        child: Center(
            child: Text(
          widget.text,
          style: const TextStyle(letterSpacing: 2),
        )),
      ),
    );
  }
}
