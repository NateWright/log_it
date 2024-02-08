import 'package:flutter/material.dart';
import 'package:log_it/src/log_create/log_create_form.dart';

import '../settings/settings_view.dart';
import 'log_list_item.dart';
import '../sample_feature/sample_item_details_view.dart';

/// Displays a list of SampleItems.
class LogsListView extends StatelessWidget {
  const LogsListView({
    super.key,
    this.items = const [LogItem(1), LogItem(2), LogItem(3)],
  });

  static const routeName = '/';

  final List<LogItem> items;

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
          print("button pressed");
          Navigator.restorablePushNamed(
            context,
            LogCreateFormPage.routeName,
          );
        },
        tooltip: 'Add new log',
        child: const Icon(Icons.add),
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'logListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
            title: Center(child: Text('Sample Log ${item.id}')),
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
      ),
    );
  }
}
