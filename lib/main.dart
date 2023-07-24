import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:zenbaba_funiture/view/Pages/splash_screen.dart';
import 'package:zenbaba_funiture/view/controller/get_bindings.dart';

import 'constants.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'notification_service.dart';

// business logic : 3,103 lines
// ui : 11,231 lines
// total : 14,334 lines

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  await NotificationService().initNotification();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GetBindings(),
      debugShowCheckedModeBanner: false,
      title: 'Zenbaba Furniture',
      theme: ThemeData.dark().copyWith(
        primaryColor: mainColor,
      ),
      home: const SplashScreen(),
    );
  }
}
