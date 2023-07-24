import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/model/user_model.dart';
import '../controller/l_s_controller.dart';
import '../widget/sl_btn.dart';
import '../widget/sl_input.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  LSController lsController = Get.find<LSController>();

  var nameTc = TextEditingController();
  var emailTc = TextEditingController();

  File? imageFile;

  @override
  void initState() {
    super.initState();
    nameTc.text = lsController.currentUser.value.name;
    emailTc.text = lsController.currentUser.value.email;
    setImageFile();
  }

  @override
  void dispose() {
    nameTc.dispose();
    emailTc.dispose();
    super.dispose();
  }

  setImageFile() async {
    imageFile = await displayImage(
      lsController.currentUser.value.image!,
      lsController.currentUser.value.id!,
      FirebaseConstants.users,
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel usermodel = lsController.currentUser.value;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title("Account"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: imageFile != null && imageFile!.path != ""
                  ? FileImage(imageFile!)
                  : null,
              backgroundColor: backgroundColor,
              child: Center(
                child: imageFile == null
                    ? CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : imageFile!.path == ""
                        ? const Icon(
                            Icons.signal_wifi_off_sharp,
                            size: 50,
                          )
                        : const SizedBox(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SLInput(
                inputColor: whiteColor,
                title: "Name",
                hint: "Osman Habib",
                keyboardType: TextInputType.text,
                controller: nameTc),
            const SizedBox(
              height: 15,
            ),
            SLInput(
                validation: (v) {
                  if (v!.isEmpty) {
                    return "This Field is required.";
                  } else if (!v.isEmail) {
                    return "Email is not vaild.";
                  }
                },
                inputColor: whiteColor,
                title: "Email",
                hint: "abc@website.com",
                keyboardType: TextInputType.emailAddress,
                controller: emailTc),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_tree_outlined),
                const SizedBox(
                  width: 20,
                ),
                Text(usermodel.priority)
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(() {
              return lsController.updateState.value == RequestState.loading
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : SLBtn(
                      text: "Update",
                      onTap: () {
                        
                        lsController.updateUser(usermodel.copyWith(
                            email: emailTc.text, name: nameTc.text));
                      });
            })
          ],
        ),
      ),
    );
  }
}
