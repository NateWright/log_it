import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/numeric.dart';

class LogDataItem extends StatelessWidget {
  final Numeric numeric;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const LogDataItem({
    super.key,
    required this.numeric,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CheckboxListTile(
      title: Text(numeric.data.toString(), style: theme.textTheme.titleLarge),
      subtitle: Text(numeric.date.toString()),
      dense: true,
      value: value,
      onChanged: onChanged,
    );
  }
}
