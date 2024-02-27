import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/CreateForm/log_create_form.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/notifcation_service/notification_service.dart';
import 'package:provider/provider.dart';

import '../../settings/settings_view.dart';
import 'dashboard_item.dart';

/// Displays a list of SampleItems.
class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          'Logs',
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              DateTime d = DateTime.now();
              d = d.add(const Duration(seconds: 30));
              debugPrint(d.toString());
              NotificationService().scheduleNotification(
                  title: 'Test scheduled',
                  body: 'It worked',
                  payload:
                      '${Provider.of<LogProvider>(context, listen: false).items[0].id}',
                  dateTime: d);
            },
            icon: Icon(Icons.plus_one),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.restorablePushNamed(
            context,
            LogCreateFormPage.routeName,
          );
        },
        tooltip: 'Add new log',
        child: const Icon(Icons.add),
      ),
      body: Consumer<LogProvider>(
        builder: (context, value, child) {
          return ListView.separated(
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'logListView',
            itemCount: value.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = value.items[index];

              return DashboardItem(log: item);
            },
            separatorBuilder: (context, index) {
              final theme = Theme.of(context);
              return Divider(
                color: theme.colorScheme.secondary,
                // color: Colors.white,
              );
            },
          );
        },
      ),
    );
  }
}
