import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/widget/sl_input.dart';
import 'package:zenbaba_funiture/view/widget/special_dropdown.dart';

import '../../constants.dart';
import '../../data/model/user_model.dart';
import '../controller/main_controller.dart';
import 'custom_btn.dart';

class UpdateUserDialog extends StatefulWidget {
  final UserModel userModel;
  const UpdateUserDialog({super.key, required this.userModel});

  @override
  State<UpdateUserDialog> createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  var selectedPriority = UserPriority.Unsigned;

  MainConntroller mainConntroller = Get.find<MainConntroller>();

  TextEditingController emailTc = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.userModel.priority;
    emailTc.text = widget.userModel.email;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: mainBgColor,
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(20),
          left: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(child: title(widget.userModel.name)),
            const SizedBox(
              height: 15,
            ),
            SLInput(
              isOutlined: true,
              title: "Email",
              hint: "email@email.com",
              inputColor: whiteColor,
              otherColor: textColor,
              keyboardType: TextInputType.text,
              controller: emailTc,
              bgColor: backgroundColor,
              readOnly: true,
            ),
            const SizedBox(
              height: 10,
            ),
            SpecialDropdown<String>(
              value: selectedPriority,
              list: UserPriority.list,
              bgColor: backgroundColor,
              title: "Priority",
              onChange: (val) {
                setState(() {
                  selectedPriority = val!;
                });
              },
              width: double.infinity,
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: CustomBtn(
                btnState: Btn.filled,
                color: primaryColor,
                text: "Save",
                onTap: () {
                  mainConntroller.updateUser(
                    widget.userModel.copyWith(
                      priority: selectedPriority,
                    ),
                  );
                  Get.back();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
