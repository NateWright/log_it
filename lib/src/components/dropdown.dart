import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String> itemList;
  final ValueChanged<String> onChanged;
  const Dropdown({
    super.key,
    required this.itemList,
    required this.onChanged,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: widget.itemList.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          if (value == null) {
            return;
          }
          if (!widget.itemList.contains(value)) {
            return;
          }
          widget.onChanged(value);
          // dropdownValue = value!;
        });
      },
      dropdownMenuEntries:
          widget.itemList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
