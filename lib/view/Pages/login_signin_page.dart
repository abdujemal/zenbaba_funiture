import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../injection.dart';
import '../controller/l_s_controller.dart';
import '../widget/login.dart';
import '../widget/signup.dart';

class LogInSignInPage extends StatefulWidget {
  const LogInSignInPage({Key? key}) : super(key: key);

  @override
  _LogInSignInPageState createState() => _LogInSignInPageState();
}

class _LogInSignInPageState extends State<LogInSignInPage> {
  LSController lsController = Get.put(di<LSController>());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/loginBackground.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 90,),
                Image.asset(
                  "assets/logo.png",
                  width: 140,
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx((() => lsController.isLogin.value ? Login() : SignUp())),
                const SizedBox(height: 40,),  
                GestureDetector(
                    onTap: () {
                      if (lsController.isLogin.value) {
                        lsController.setIsLoading(false);
                      } else {
                        lsController.setIsLoading(true);
                      }
                    },
                    child: Obx(()=> Column(
                      children: [
                        Text(
                          lsController.isLogin.value ?
                          "New to this App":
                          "Already have an account",
                          style: TextStyle(color: textColor, fontSize: 12),
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          lsController.isLogin.value ?
                          "Create an Account":
                          "Sign In",
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
