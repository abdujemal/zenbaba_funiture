import 'package:flutter/material.dart';

import '../../constants.dart';

class SLInput extends StatelessWidget {
  final String title, hint;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Color inputColor;
  final Color? otherColor;
  final bool isObscure;
  final void Function(String val)? onChanged;
  final String? Function(String? val)? validation;
  final bool isOutlined;
  final IconData? sufixIcon;
  final void Function()? onTap;
  final bool? readOnly;
  final double? width;
  final double? margin;
  final FocusNode? focusNode;
  const SLInput(
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
      required this.title,
      required this.hint,
      required this.keyboardType,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
            readOnly: readOnly ?? false,
            onTap: onTap,
            onChanged: onChanged,
            validator: validation ??
                (value) {
                  if (value!.isEmpty) {
                    return "This Field is required.";
                  }
                  return null;
                },
            obscureText: isObscure,
            style: TextStyle(color: inputColor),
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              fillColor: mainBgColor,
              filled: true,
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
              suffixIcon: sufixIcon != null ? Icon(sufixIcon) : null,
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
