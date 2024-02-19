import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/numeric.dart';

class LogDataItem extends StatelessWidget {
  const LogDataItem(this.numeric, {super.key});

  final Numeric numeric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(numeric.data.toString(), style: theme.textTheme.titleLarge),
      // leading: const CircleAvatar(
      //   // Display the Flutter Logo image asset.
      //   foregroundImage: AssetImage('assets/images/flutter_logo.png'),
      // ),
      subtitle: Text(numeric.date.toString()),
      dense: true,
    );
  }
}
