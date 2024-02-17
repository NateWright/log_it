import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/log.dart';

/// Displays detailed information about a SampleItem.
class LogView extends StatelessWidget {
  const LogView({super.key, required this.log});

  final Log log;

  static const routeName = '/log_view';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          log.title,
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        // actions: [],
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('IMPLEMENT ME: Show Graph here'),
              Text('IMPLEMENT ME: Button for viewing raw data')
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
                throw UnimplementedError(
                    'Implement adding data: See log_add_numeric_form.dart')
              },
          tooltip: 'Add new data',
          child: const Icon(Icons.add)),
    );
  }
}
