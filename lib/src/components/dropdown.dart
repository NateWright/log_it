import 'package:flutter/material.dart';
import 'package:log_it/src/components/pair.dart';

class Dropdown<T> extends StatefulWidget {
  final List<Pair<String, T>> itemList;
  final ValueChanged<T> onChanged;
  const Dropdown({
    super.key,
    required this.itemList,
    required this.onChanged,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState<T> extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      initialSelection: widget.itemList.first.second,
      onSelected: (T? value) {
        // This is called when the user selects an item.
        setState(() {
          if (value == null) {
            return;
          }
          if (!widget.itemList.contains(value)) {
            return;
          }
          widget.onChanged(value);
        });
      },
      dropdownMenuEntries: widget.itemList.map<DropdownMenuEntry<T>>((Pair p) {
        return DropdownMenuEntry<T>(value: p.second, label: p.first);
      }).toList(),
    );
  }
}
