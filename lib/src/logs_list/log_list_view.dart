import 'package:flutter/material.dart';
import 'package:log_it/src/log_create/log_create_form.dart';
import 'package:log_it/src/log_provider/log_provider.dart';
import 'package:provider/provider.dart';

import '../settings/settings_view.dart';
import '../sample_feature/sample_item_details_view.dart';

/// Displays a list of SampleItems.
class LogsListView extends StatelessWidget {
  const LogsListView({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        centerTitle: true,
        actions: [
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
      body: Consumer<LogModel>(
        builder: (context, value, child) {
          return ListView.builder(
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'logListView',
            itemCount: value.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = value.items[index];

              return ListTile(
                title: Center(child: Text(item.title)),
                // leading: const CircleAvatar(
                //   // Display the Flutter Logo image asset.
                //   foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                // ),
                onTap: () {
                  // Navigate to the details page. If the user leaves and returns to
                  // the app after it has been killed while running in the
                  // background, the navigation stack is restored.
                  Navigator.restorablePushNamed(
                    context,
                    SampleItemDetailsView.routeName,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
