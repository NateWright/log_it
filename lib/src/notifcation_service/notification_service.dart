import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final MethodChannel platform = const MethodChannel(
      'log_it.NateWright.github.com/flutter_local_notification');
  late String timeZoneName;

  NotificationService();

  Future<void> setup() async {
    // Initialize TimeZone
    tz.initializeTimeZones();
    timeZoneName = await platform.invokeMethod('getTimeZoneName');
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Initialize Notifications
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return _flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {
    return _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      // tz.TZDateTime(
      //   tz.local,
      //   dateTime.year,
      //   dateTime.month,
      //   dateTime.day,
      //   dateTime.hour,
      //   dateTime.minute,
      // ),
      tz.TZDateTime.from(
        dateTime,
        tz.local,
      ),
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
}
