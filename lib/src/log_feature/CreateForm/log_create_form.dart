import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:provider/provider.dart';

class LogCreateFormPage extends StatelessWidget {
  const LogCreateFormPage({
    super.key,
  });

  static const routeName = '/create_log';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          'Create Log',
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        // actions: [],
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

  late Log log;

  @override
  void initState() {
    super.initState();

    var time = DateTime.now();

    log = Log(
      title: '',
      description: '',
      dataType: DataType.number,
      unit: '',
      hasNotifications: false,
      dateRange: DateTimeRange(start: time, end: time),
      startTime: TimeOfDay.now(),
      interval: TimeInterval(1, TimeIntervalUnits.minutes),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final int id = (args['id'] ?? '-1') as int;
      Log? l = Provider.of<LogProvider>(context, listen: false).getLog(id);
      if (l != null) {
        setState(() {
          log = l;
        });
      }
    }
    final theme = Theme.of(context);
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
                        initialValue: log.title,
                        decoration: const InputDecoration(
                          // border: UnderlineInputBorder(),
                          filled: true,
                          labelText: 'Title',
                          hintText: 'Enter title for log...',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            log.title = value;
                          });
                        },
                      ),
                      TextFormField(
                        initialValue: log.description,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          hintText: 'Enter a description...',
                          labelText: 'Description',
                        ),
                        onChanged: (value) {
                          setState(() {
                            log.description = value;
                          });
                        },
                        maxLines: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Log type:',
                            style: theme.textTheme.bodyLarge,
                          ),
                          DropdownButton(
                            value: log.dataType,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                log.dataType = value;
                              });
                            },
                            items: [
                              for (var item in DataType.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.name.toUpperCase()),
                                )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Log unit:',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              initialValue: log.unit,
                              decoration: const InputDecoration(
                                // border: UnderlineInputBorder(),
                                filled: true,
                                labelText: 'Unit',
                                hintText: 'kg',
                              ),
                              enabled: log.dataType == DataType.number,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (log.dataType == DataType.picture) {
                                  return null;
                                }
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a unit';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  log.unit = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Enable Notifications',
                              style: theme.textTheme.bodyLarge),
                          Switch(
                            value: log.hasNotifications,
                            onChanged: (enabled) {
                              setState(() {
                                log.hasNotifications = enabled;
                              });
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        visible: log.hasNotifications,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...[
                              _FormDatePicker(
                                name: 'Dates',
                                date: log.dateRange,
                                onChanged: (value) {
                                  setState(() {
                                    log.dateRange = value;
                                  });
                                },
                              ),
                              _FormTimePicker(
                                time: log.startTime,
                                onChanged: (value) {
                                  setState(() {
                                    log.startTime = value;
                                  });
                                },
                                name: 'Start Time',
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      ],
                                      initialValue:
                                          log.interval.interval.toString(),
                                      validator: (value) {
                                        if (!log.hasNotifications) {
                                          return null;
                                        }
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter an interval';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          log.interval.interval =
                                              int.parse(value);
                                        });
                                      },
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: DropdownButton(
                                      value: log.interval.unit,
                                      onChanged: (value) {
                                        if (value == null) {
                                          return;
                                        }
                                        setState(() {
                                          log.interval.unit = value;
                                        });
                                      },
                                      items: [
                                        for (var item
                                            in TimeIntervalUnits.values)
                                          DropdownMenuItem(
                                            value: item,
                                            child:
                                                Text(item.name.toUpperCase()),
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ].expand(
                              (widget) => [
                                widget,
                                const SizedBox(
                                  height: 24,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Consumer<LogProvider>(
                          builder: (context, logs, child) {
                            return ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //       content: Text('Processing Data')),
                                  // );
                                  logs.add(log);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Submit'),
                            );
                          },
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
  final DateTimeRange date;
  final ValueChanged<DateTimeRange> onChanged;
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
              '${intl.DateFormat.yMd().format(widget.date.start)} - ${widget.date.start == widget.date.end ? 'endless' : intl.DateFormat.yMd().format(widget.date.end)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDateRangePicker(
              context: context,
              initialDateRange: widget.date,
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

class _FormTimePicker extends StatefulWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;
  final String name;

  const _FormTimePicker({
    required this.time,
    required this.onChanged,
    required this.name,
  });

  @override
  State<_FormTimePicker> createState() => _FormTimePickerState();
}

class _FormTimePickerState extends State<_FormTimePicker> {
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
              widget.time.format(context),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newTime = await showTimePicker(
              context: context,
              initialTime: widget.time,
            );

            // Don't change the date if the date picker returns null.
            if (newTime == null) {
              return;
            }

            widget.onChanged(newTime);
          },
        )
      ],
    );
  }
}
