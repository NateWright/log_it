import "package:flutter/material.dart";

class FormTimePicker extends StatefulWidget {
  final ValueChanged<TimeOfDay> onChanged;
  final TimeOfDay initialTime;
  const FormTimePicker({
    super.key,
    required this.initialTime,
    required this.onChanged,
  });

  @override
  State<FormTimePicker> createState() => _FormTimePickerState();
}

class _FormTimePickerState extends State<FormTimePicker> {
  String buttonText = 'Select Time';
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: Text(buttonText),
      onPressed: () async {
        var newTime = await showTimePicker(
          context: context,
          initialTime: widget.initialTime,
        );

        // Don't change the date if the date picker returns null.
        if (newTime == null) {
          return;
        }
        setState(() {
          buttonText = newTime.format(context);
        });
        widget.onChanged(newTime);
      },
    );
  }
}
