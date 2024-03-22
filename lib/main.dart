import 'dart:io';

import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/notification_service/notification_service.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().setup();

  DbService dbService;
  if (Platform.isLinux) {
    dbService = DbService.linux();
  } else {
    dbService = DbService();
  }

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LogProvider(dbService)),
      Provider(create: (context) => NotificationService())
    ],
    child: MyApp(settingsController: settingsController),
  ));
}
