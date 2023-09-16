import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../controller/l_s_controller.dart';
import '../controller/main_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LSController lsController = Get.find<LSController>();
  MainConntroller mainConntroller = Get.find<MainConntroller>();
  @override
  void initState() {
    super.initState();
    // mainConntroller.getCustomers();
    checkUser();
  }

  checkUser() async {
    
    await lsController.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/loginBackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                height: 200,
              ),
              const SizedBox(
                height: 15,
              ),
              CircularProgressIndicator(
                color: primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
