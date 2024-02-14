import 'package:flutter/material.dart';
import 'package:log_it/src/log_provider/log.dart';
import 'package:log_it/src/sample_feature/sample_item_details_view.dart';

class LogListItem extends StatelessWidget {
  const LogListItem(this.log, {super.key});

  final LogItem log;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        log.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
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
  }
}
