import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class FormDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onChanged;

  const FormDatePicker({
    super.key,
    required this.onChanged,
  });

  @override
  State<FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  String buttonText = 'Select Date';
  @override
  Widget build(BuildContext context) {
    DateTime initialDate = DateTime.now();
    widget.onChanged(initialDate);
    return FilledButton(
      onPressed: () async {
        var newDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        // Don't change the date if the date picker returns null.
        if (newDate == null) {
          return;
        }
        setState(() {
          buttonText = intl.DateFormat.yMd().format(newDate);
        });
        widget.onChanged(newDate);
      },
      child: Text(buttonText),
    );
  }
}
