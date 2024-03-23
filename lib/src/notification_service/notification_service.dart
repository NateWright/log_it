import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:log_it/src/app.dart';
import 'package:log_it/src/log_feature/LogView/log_view.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final MethodChannel platform = const MethodChannel(
      'log_it.NateWright.github.com/flutter_local_notification');

  Future<void> setup() async {
    // Initialize TimeZone
    if (!(kIsWeb || Platform.isLinux)) {
      tz.initializeTimeZones();
      String timeZoneName = await platform.invokeMethod('getTimeZoneName');
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }

    // Initialize Notifications
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    await handleStartupNotifications();
  }

  handleStartupNotifications() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    NotificationAppLaunchDetails? details =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    if (details != null &&
        details.didNotificationLaunchApp &&
        details.notificationResponse != null &&
        details.notificationResponse!.payload != null) {
      String payload = details.notificationResponse!.payload!;
      MyApp.initialRoute = LogView.routeName;
      LogProvider.notificationLog = int.parse(payload);
    }
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return _flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {
    return _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
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

  // Function that does something when notification is clicked
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload == null) {
      return;
    }

    int id = int.parse(payload);

    navService.pushNamed(LogView.routeName, args: {'id': id});
  }
}
