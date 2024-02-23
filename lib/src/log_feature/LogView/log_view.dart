import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:log_it/src/log_feature/CreateForm/log_create_form.dart';
import 'package:log_it/src/log_feature/LogView/log_data_view.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

enum SettingsOptions { delete }

/// Displays detailed information about a SampleItem.
class LogView extends StatelessWidget {
  const LogView({super.key});

  static const routeName = '/log_view';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map) {
      Navigator.pop(context);
      return const Text('Error');
    }
    final int index = (args['index'] ?? '-1') as int;
    if (index == -1) {
      Navigator.pop(context);
      return const Text('Error');
    }
    final theme = Theme.of(context);
    return Consumer<LogModel>(
      builder: (context, value, child) {
        final Log log = value.items[index];
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
                          'index': index,
                        },
                      );
                    },
                    leadingIcon: const Icon(Icons.settings),
                    child: const Text('EDIT'),
                  ),
                  _DeleteWidget(log: log),
                ],
              ),
            ],
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            barWidth: 3,
                            spots: [
                              FlSpot(0, 5),
                              FlSpot(1, 10),
                              FlSpot(2, 4),
                              FlSpot(3, 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogDataView(log: log),
                        ),
                      );
                    },
                    child: const Text('View Data'),
                  ),
                ],
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

class _DeleteWidget extends StatelessWidget {
  const _DeleteWidget({
    super.key,
    required this.log,
  });

  final Log log;

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
          context: context,
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
                    Provider.of<LogModel>(context, listen: false).delete(log);
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
      child: const Text('Delete'),
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

  var input;

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
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      try {
                        double val = double.parse(input);
                        Provider.of<LogModel>(context, listen: false)
                            .addDataNumeric(widget.log, val);
                        Navigator.pop(context);
                      } catch (e) {}
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
