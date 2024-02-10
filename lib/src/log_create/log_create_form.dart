import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:log_it/src/components/dropdown.dart';

const List<String> _intervalUnits = ['hours', 'days', 'months', 'years'];

class LogCreateFormPage extends StatelessWidget {
  const LogCreateFormPage({
    super.key,
  });

  static const routeName = '/create_log';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Log'),
        centerTitle: true,
      ),
      body: const LogCreateForm(),
    );
  }
}

/// Displays a list of SampleItems.
class LogCreateForm extends StatefulWidget {
  const LogCreateForm({
    super.key,
  });

  @override
  LogCreateFormState createState() {
    return LogCreateFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LogCreateFormState extends State<LogCreateForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  DateTime startDate = DateTime.now();
  bool enableEndDate = true;
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Scrollbar(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          // border: UnderlineInputBorder(),
                          filled: true,
                          labelText: 'Title',
                          hintText: 'Enter title for log...',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          hintText: 'Enter a description...',
                          labelText: 'Description',
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                        maxLines: 5,
                      ),
                      _FormDatePicker(
                        name: 'Start Date',
                        date: startDate,
                        onChanged: (value) {
                          setState(() {
                            startDate = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('End Date',
                              style: Theme.of(context).textTheme.bodyLarge),
                          Switch(
                            value: enableEndDate,
                            onChanged: (enabled) {
                              setState(() {
                                enableEndDate = enabled;
                              });
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        visible: enableEndDate,
                        child: _FormDatePicker(
                          name: 'End Date',
                          date: endDate,
                          onChanged: (value) {
                            setState(() {
                              endDate = value;
                            });
                          },
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notifcation Interval',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Interval',
                                    hintText: '1',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ], // Only numbers can be entered
                                ),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Dropdown(
                                  itemList: _intervalUnits,
                                  onChanged: (value) {
                                    print(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ].expand(
                      (widget) => [
                        widget,
                        const SizedBox(
                          height: 24,
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final String name;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
    required this.name,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
