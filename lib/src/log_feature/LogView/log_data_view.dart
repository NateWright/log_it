import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/LogView/log_data_item.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:provider/provider.dart';

class LogDataView extends StatelessWidget {
  const LogDataView({super.key, required this.log});

  final Log log;

  static const routeName = '/log_data_view';

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
      body: Consumer<LogModel>(
        builder: (context, value, child) {
          return FutureBuilder(
            future: value.getDataNumeric(log),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              // return const Text('has data');
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return LogDataItem(snapshot.data![index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
