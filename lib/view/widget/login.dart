import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/view/widget/sl_btn.dart';
import 'package:zenbaba_funiture/view/widget/sl_input.dart';

import '../../constants.dart';
import '../controller/l_s_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // const Login({ Key? key }) : super(key: key);
  TextEditingController emailTC = TextEditingController();

  TextEditingController passwordTC = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  LSController lsController = Get.find<LSController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _key,
          child: Column(
            children: [
              SLInput(
                inputColor: textColor,
                controller: emailTC,
                otherColor: backgroundColor,
                isOutlined: true,
                keyboardType: TextInputType.emailAddress,
                title: 'Email',
                hint: 'abc@website.com',
              ),
              const SizedBox(
                height: 20,
              ),
              SLInput(
                inputColor: textColor,
                title: "Password",
                hint: "*******",
                isObscure: true,
                otherColor: backgroundColor,
                isOutlined: true,
                keyboardType: TextInputType.text,
                controller: passwordTC,
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: GestureDetector(
            onTap: () {},
            child: Text(
              "Forget password?",
              style: TextStyle(color: backgroundColor),
            ),
          ),
        ),
        const SizedBox(
          height: 45,
        ),
        Obx(() {
          return lsController.emailState.value == RequestState.loading
              ? CircularProgressIndicator(
                  color: primaryColor,
                )
              : SLBtn(
                  text: "Log In",
                  onTap: () {
                    if (_key.currentState!.validate()) {
                      lsController.signInWithEmailnPassword(
                          emailTC.text, passwordTC.text);
                    }
                  },
                );
        }),
      ],
    );
  }
}
