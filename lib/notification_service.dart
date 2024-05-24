import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Future<void> initNotification() async {
  //   // Android initialization
  //   AndroidInitializationSettings initializationSettingsAndroid =
  //       const AndroidInitializationSettings(
  //           '@mipmap/ic_launcher'); // should mention the app icon
  //   // during initialization itself

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

    // the initialization settings are initialized after they are setted
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  Future<void> showNotification(int id, String title, String body, Duration duration) async {
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   tz.TZDateTime.now(tz.local).add(duration),
    //   const NotificationDetails(
    //     // Android details
    //     android: AndroidNotificationDetails(
    //       'main_channel',
    //       'Main Channel',
    //       channelDescription: "ashwin",
    //       importance: Importance.max,
    //       priority: Priority.max,
    //     ),
    //   ),
    //   // Type of time interpretation
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   androidAllowWhileIdle:
    //       true, //To show notification even when the app is closed
    // );
  }
}
