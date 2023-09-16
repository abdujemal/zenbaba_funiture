import 'package:flutter/material.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class SLInput extends StatelessWidget {
  final String title, hint;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Color inputColor;
  final Color? bgColor;
  final Color? otherColor;
  final bool isObscure;
  final void Function(String val)? onChanged;
  String? Function(String? val)? validation;
  final bool isOutlined;
  final bool jumpIt;
  final Widget? sufixIcon;
  final void Function()? onTap;
  final bool? readOnly;
  final double? width;
  final double? margin;
  final FocusNode? focusNode;
  SLInput(
      {Key? key,
      this.isOutlined = false,
      this.inputColor = const Color(0xff898989),
      this.isObscure = false,
      this.readOnly,
      this.otherColor,
      this.validation,
      this.sufixIcon,
      this.onTap,
      this.width,
      this.margin,
      this.focusNode,
      this.onChanged,
      this.jumpIt = false,
      this.bgColor,
      required this.title,
      required this.hint,
      required this.keyboardType,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    validation = validation ??
        (value) {
          if (value!.isEmpty) {
            return "This Field is required.";
          }
          return null;
        };

    return Container(
      width: width,
      margin: margin == null
          ? EdgeInsets.symmetric(horizontal: isOutlined ? 23 : 45)
          : EdgeInsets.symmetric(horizontal: margin!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              title,
              style: TextStyle(color: otherColor ?? inputColor),
            ),
          ),
          SizedBox(
            height: isOutlined ? 10 : 0,
          ),
          TextFormField(
            focusNode: focusNode,
            maxLines: keyboardType == TextInputType.multiline ? 3 : 1,
            readOnly: readOnly ?? false,
            onTap: onTap,
            onChanged: onChanged,
            validator: jumpIt ? null : validation,
            obscureText: isObscure,
            style: TextStyle(color: inputColor),
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              fillColor: bgColor ?? mainBgColor,
              filled: true,
              errorBorder: isOutlined
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: otherColor ?? inputColor),
                    ),
              focusedErrorBorder: isOutlined
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: otherColor ?? inputColor),
                    ),
              enabledBorder: isOutlined
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: otherColor ?? inputColor),
                    ),
              focusedBorder: isOutlined
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: whiteColor),
                    ),
              suffixIcon: sufixIcon,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.all(18),
            ),
          )
        ],
      ),
    );
  }
}
