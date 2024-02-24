import 'package:flutter/material.dart';
import 'package:log_it/src/components/confirmation_dialog.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:provider/provider.dart';

class LogDataView extends StatefulWidget {
  const LogDataView({super.key, required this.log});

  final Log log;

  static const routeName = '/log_data_view';

  @override
  State<LogDataView> createState() => _LogDataViewState();
}

class _LogDataViewState extends State<LogDataView> {
  bool editing = false;

  Map<int, Numeric> checked = {};
  late Future<List<Numeric>> fNumeric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          widget.log.title,
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          Visibility(
            visible: !editing,
            child: IconButton(
              onPressed: () {
                setState(() {
                  editing = true;
                });
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          Visibility(
            // Cancel
            visible: editing,
            child: IconButton(
              onPressed: () async {
                if (checked.isEmpty) {
                  setState(() {
                    editing = false;
                    checked = {};
                  });
                  return;
                }
                String? str = await confirmationDialog(
                    context,
                    'Cancel Changes?',
                    'Canceling changes will not change any data.');
                if (str == null) {
                  return;
                }
                if (str == 'NO') {
                  return;
                }
                setState(() {
                  editing = false;
                  checked = {};
                });
              },
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
            ),
          ),
          Visibility(
            // Delete
            visible: editing,
            child: IconButton(
              onPressed: () async {
                if (checked.isEmpty) {
                  setState(() {
                    editing = false;
                    checked = {};
                  });
                  return;
                }
                String? str = await confirmationDialog(
                    context,
                    'Delete Selected?',
                    'Deleting selected data is irreversible.');
                if (str == null) {
                  return;
                }
                if (str == 'NO') {
                  return;
                }
                if (context.mounted) {
                  Provider.of<LogModel>(context, listen: false)
                      .deleteDataNumeric(widget.log, checked.values.toList());
                }
                setState(() {
                  editing = false;
                  checked = {};
                });
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
            ),
          ),
        ],
      ),
      body: Consumer<LogModel>(
        builder: (context, value, child) {
          fNumeric = value.getDataNumeric(widget.log);
          return FutureBuilder<List<Numeric>>(
            future: fNumeric,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final numeric = snapshot.data?[index];
                    return CheckboxListTile(
                      title: Text(numeric!.data.toString(),
                          style: theme.textTheme.titleLarge),
                      subtitle: Text(numeric.date.toString()),
                      dense: true,
                      value: checked.containsKey(index),
                      onChanged: !editing
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }
                              if (value) {
                                setState(() {
                                  checked[index] = snapshot.data![index];
                                });
                              } else {
                                setState(() {
                                  checked.remove(index);
                                });
                              }
                            },
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
