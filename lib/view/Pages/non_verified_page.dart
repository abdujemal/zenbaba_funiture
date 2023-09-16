import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/view/controller/l_s_controller.dart';
import 'package:zenbaba_funiture/view/widget/custom_btn.dart';

class NonVerfiedPage extends StatefulWidget {
  const NonVerfiedPage({super.key});

  @override
  State<NonVerfiedPage> createState() => _NonVerfiedPageState();
}

class _NonVerfiedPageState extends State<NonVerfiedPage> {
  LSController lsController = Get.find<LSController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/loginBackground.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 90,
                ),
                Image.asset(
                  "assets/logo.png",
                  width: 140,
                ),
                const SizedBox(
                  height: 15,
                ),
                section(
                    mh: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Please wait until you are verified by the admins.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() {
                        return lsController.getUserState.value ==
                                RequestState.loading
                            ? CircularProgressIndicator(
                                color: primaryColor,
                              )
                            : CustomBtn(
                                btnState: Btn.filled,
                                width: 200,
                                color: primaryColor,
                                onTap: () {
                                  lsController.getUser();
                                },
                                text: "Check Again",
                              );
                      }),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
