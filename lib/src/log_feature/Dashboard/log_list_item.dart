import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/LogView/log_view.dart';
import 'package:log_it/src/log_feature/log.dart';

class LogListItem extends StatelessWidget {
  const LogListItem({
    super.key,
    required this.log,
    required this.index,
  });

  final Log log;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(log.title, style: theme.textTheme.displaySmall),
      subtitle: log.description.isNotEmpty ? Text(log.description) : null,
      trailing: Icon(
        Icons.navigate_next,
        size: theme.textTheme.displaySmall!.fontSize,
      ),
      dense: true,
      onTap: () {
        // Navigate to the details page. If the user leaves and returns to
        // the app after it has been killed while running in the
        // background, the navigation stack is restored.
        Navigator.restorablePushNamed(
          context,
          LogView.routeName,
          arguments: {'index': index},
        );
      },
    );
  }
}
