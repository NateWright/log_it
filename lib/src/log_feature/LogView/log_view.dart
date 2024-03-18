import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:log_it/src/components/form_date_picker.dart';
import 'package:log_it/src/components/form_time_picker.dart';
import 'package:log_it/src/log_feature/CreateForm/log_create_form.dart';
import 'package:log_it/src/log_feature/LogView/SlideshowView/slideshow_view.dart';
import 'package:log_it/src/log_feature/LogView/log_data_view.dart';
import 'package:log_it/src/log_feature/LogView/GraphView/graph_view.dart';
import 'package:log_it/src/log_feature/graph_settings.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:provider/provider.dart';

enum SettingsOptions { delete }

/// Displays detailed information about a SampleItem.
class LogView extends StatelessWidget {
  const LogView({super.key});

  static const routeName = '/log_view';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    int id;
    if (args == null || args is! Map) {
      id = LogProvider.notificationLog;
    } else {
      id = (args['id'] ?? '-1') as int;
    }
    if (id == -1) {
      Navigator.pop(context);
      return const Text('Error');
    }
    final theme = Theme.of(context);
    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        Log? l = logProvider.getLog(id);
        if (l == null) {
          return const Center(child: CircularProgressIndicator());
        }
        Log log = l;
        return Scaffold(
          appBar: AppBar(
            elevation: 4,
            shadowColor: theme.shadowColor,
            title: Text(
              log.title,
              style: theme.textTheme.headlineLarge,
            ),
            centerTitle: true,
            actions: [
              MenuAnchor(
                builder: (context, controller, child) => IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                ),
                menuChildren: [
                  MenuItemButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        LogCreateFormPage.routeName,
                        arguments: {
                          'id': id,
                        },
                      );
                    },
                    leadingIcon: const Icon(Icons.settings),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 12.0, 12, 12),
                      child: Text('EDIT'),
                    ),
                  ),
                  _DeleteWidget(
                    log: log,
                    context: context,
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              log.dataType == DataType.number
                  ? _GraphWidget(
                      dataPoints: logProvider.getDataNumeric(log),
                      settings: logProvider.logGetSettings(log),
                    )
                  : const Slideshow(),
              Divider(
                color: theme.colorScheme.secondary,
                // color: Colors.white,
              ),
              ListTile(
                title: const Text('Modify Graph'),
                subtitle: const Text('Change graph type and colors'),
                trailing: Icon(
                  Icons.navigate_next,
                  size: theme.textTheme.displaySmall!.fontSize,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GraphView(log: log),
                    ),
                  );
                },
              ),
              Divider(
                color: theme.colorScheme.secondary,
                // color: Colors.white,
              ),
              ListTile(
                title: const Text('Raw Data'),
                subtitle: const Text('View and delete data'),
                trailing: Icon(
                  Icons.navigate_next,
                  size: theme.textTheme.displaySmall!.fontSize,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogDataView(log: log),
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                // Create the SelectionScreen in the next step.
                MaterialPageRoute(builder: (context) => AddDataForm(log: log)),
              );
            },
            tooltip: 'Add new log',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _GraphWidget extends StatelessWidget {
  const _GraphWidget({
    required this.dataPoints,
    required this.settings,
  });

  final Future<List<Numeric>> dataPoints;
  final Future<GraphSettings> settings;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([dataPoints, settings]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final d = snapshot.data![0] as List<Numeric>;
        final g = snapshot.data![1] as GraphSettings;
        return GraphWidget(dataPoints: d, graphSettings: g);
      },
    );
  }
}

class _DeleteWidget extends StatelessWidget {
  const _DeleteWidget({
    required this.log,
    required this.context,
  });

  final Log log;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      style: MenuItemButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        iconColor: Colors.white,
      ),
      leadingIcon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Are you sure you want to delete ${log.title}?',
              ),
              content: const Text('Deleting a log is irreversible.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('NO'),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<LogProvider>(context, listen: false)
                        .delete(log);
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName("/"),
                    );
                  },
                  child: const Text('YES'),
                ),
              ],
            );
          },
        );
      },
      child: const Padding(
        padding: EdgeInsets.fromLTRB(0, 12.0, 12, 12),
        child: Text('Delete'),
      ),
    );
  }
}

class AddDataForm extends StatefulWidget {
  final Log log;
  const AddDataForm({
    super.key,
    required this.log,
  });

  @override
  State<AddDataForm> createState() => _AddDataFormState();
}

class _AddDataFormState extends State<AddDataForm> {
  final _formKey = GlobalKey<FormState>();

  String input = '';
  Numeric numeric = Numeric(date: DateTime.now(), data: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          'Enter Data',
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        // actions: [],
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Data',
                            hintText: '1.0',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'(^\d*\.?\d*)')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              input = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FormDatePicker(
                            initialDate: numeric.date,
                            onChanged: (value) {
                              numeric.date = DateTime(
                                value.year,
                                value.month,
                                value.day,
                                numeric.date.hour,
                                numeric.date.minute,
                                0,
                                0,
                              );
                            },
                          ),
                          FormTimePicker(
                              initialTime: TimeOfDay.fromDateTime(numeric.date),
                              onChanged: (value) {
                                numeric.date = DateTime(
                                  numeric.date.year,
                                  numeric.date.month,
                                  numeric.date.day,
                                  value.hour,
                                  value.minute,
                                  0,
                                  0,
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      try {
                        numeric.data = double.parse(input);
                        Provider.of<LogProvider>(context, listen: false)
                            .addDataNumeric(widget.log, numeric);
                        Navigator.pop(context);
                      } catch (e) {
                        // Couldn't parse int
                      }
                    }
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
