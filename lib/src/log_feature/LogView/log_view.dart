import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:provider/provider.dart';

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
              TextFormField(
                decoration: const InputDecoration(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Consumer<LogModel>(
                  builder: (context, logs, child) {
                    return ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          try {
                            double val = double.parse(input);
                            logs.addDataNumeric(widget.log, val);
                            Navigator.pop(context);
                          } catch (e) {}
                        }
                      },
                      child: const Text('Add'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
