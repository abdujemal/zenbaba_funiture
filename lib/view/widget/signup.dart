import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zenbaba_funiture/view/widget/sl_btn.dart';
import 'package:zenbaba_funiture/view/widget/sl_input.dart';

import '../../constants.dart';
import '../controller/l_s_controller.dart';

class SignUp extends StatelessWidget {
  // const Login({ Key? key }) : super(key: key);

  TextEditingController emailTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();
  TextEditingController nameTc = TextEditingController();
  TextEditingController confirmPasswordTC = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  LSController lsController = Get.find<LSController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _key,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  XFile? xfile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (xfile != null) {
                    lsController.setImageFile(File(xfile.path));
                  } else {
                    toast("No Image.", ToastType.error);
                  }
                },
                child: Obx(() {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: lsController.image.value.path == ""
                        ? null
                        : FileImage(lsController.image.value),
                    child: lsController.image.value.path == ""
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          )
                        : null,
                    backgroundColor: Colors.grey,
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              SLInput(
                controller: nameTc,
                keyboardType: TextInputType.text,
                title: 'Name',
                hint: 'Osman Habib',
              ),
              const SizedBox(
                height: 40,
              ),
              SLInput(
                controller: emailTC,
                keyboardType: TextInputType.emailAddress,
                title: 'Email',
                hint: 'abc@website.com',
                validation: (val) {
                  if (val!.isEmpty) {
                    return "This feild is required.";
                  } else if (!val.isEmail) {
                    return 'Email is not vaild';
                  }
                },
              ),
              const SizedBox(
                height: 40,
              ),
              SLInput(
                  isObscure: true,
                  title: "Password",
                  hint: "*******",
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordTC),
              const SizedBox(
                height: 15,
              ),
              SLInput(
                  isObscure: true,
                  title: "Confirm Password",
                  hint: "*******",
                  keyboardType: TextInputType.visiblePassword,
                  controller: confirmPasswordTC),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Obx(() {
          return lsController.emailState.value == RequestState.loading
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : SLBtn(
                  text: "Sign Up",
                  onTap: () {
                    if (lsController.image.value.path == "") {
                      toast("Please choose your image.", ToastType.success);
                    } else if (_key.currentState!.validate()) {
                      if (passwordTC.text == confirmPasswordTC.text) {
                        lsController.signUpWithEmailnPassword(
                            emailTC.text, nameTc.text, passwordTC.text);
                      } else {
                        toast(
                            "The passwords are not the same.", ToastType.error);
                      }
                    }
                  },
                );
        }),
      ],
    );
  }
}
