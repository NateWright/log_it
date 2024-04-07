import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:log_it/src/components/form_date_picker.dart';
import 'package:log_it/src/components/form_time_picker.dart';
import 'package:log_it/src/log_feature/LogView/numeric/GraphView/graph_view.dart';
import 'package:log_it/src/log_feature/LogView/numeric/numeric_raw_data_view.dart';
import 'package:log_it/src/log_feature/graph_settings.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:provider/provider.dart';

class NumericWidgets {
  final BuildContext _context;
  final Log _log;
  final LogProvider _logProvider;

  NumericWidgets({
    required context,
    required log,
    required logProvider,
  })  : _context = context,
        _log = log,
        _logProvider = logProvider;

  addData() => NumericAddDataForm(log: _log);

  void exportData() async {
    final data = await _logProvider.exportData(_log);
    final params = SaveFileDialogParams(fileName: 'output.csv', data: data);
    await FlutterFileDialog.saveFile(params: params);
  }

  widgets() {
    final theme = Theme.of(_context);

    return [
      _GraphWidget(
        log: _log,
        dataPoints: _logProvider.getDataNumeric(_log),
        settings: _logProvider.logGetSettings(_log),
      ),
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
            _context,
            MaterialPageRoute(
              builder: (context) => GraphView(log: _log),
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
            _context,
            MaterialPageRoute(
              builder: (context) => LogDataView(log: _log),
            ),
          );
        },
      ),
    ];
  }
}

class _GraphWidget extends StatelessWidget {
  const _GraphWidget({
    required this.log,
    required this.dataPoints,
    required this.settings,
  });

  final Log log;
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
        return GraphWidget(log: log, dataPoints: d, graphSettings: g);
      },
    );
  }
}

class NumericAddDataForm extends StatefulWidget {
  final Log log;
  const NumericAddDataForm({
    super.key,
    required this.log,
  });

  @override
  State<NumericAddDataForm> createState() => _NumericAddDataFormState();
}

class _NumericAddDataFormState extends State<NumericAddDataForm> {
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
