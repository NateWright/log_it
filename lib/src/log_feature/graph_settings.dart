import 'package:flutter/material.dart';

enum GraphColor {
  red(Colors.red),
  green(Colors.green),
  blue(Colors.blue),
  orange(Colors.orange),
  yellow(Colors.yellow),
  purple(Colors.purple),
  black(Colors.black),
  white(Colors.white);

  const GraphColor(this.value);
  final Color value;
}

enum GraphBackgroundColor {
  white(Colors.white),
  grey(Colors.grey),
  black(Colors.black),
  blueGrey(Colors.blueGrey),
  teal(Colors.teal);

  const GraphBackgroundColor(this.value);
  final Color value;
}

enum GraphType { line, bar }

enum AggregateInterval { day, week, month, year }

enum AggregateType { sum, average }

class GraphSettings {
  GraphType graphType;
  GraphColor graphColor;
  GraphBackgroundColor graphBackgroundColor;
  bool isCurved;
  bool showGridLines;
  bool aggregate;
  AggregateInterval aggregateInterval;
  AggregateType aggregateType;

  GraphSettings({
    this.graphType = GraphType.line,
    this.graphColor = GraphColor.black,
    this.graphBackgroundColor = GraphBackgroundColor.white,
    this.isCurved = false,
    this.showGridLines = true,
    this.aggregate = false,
    this.aggregateInterval = AggregateInterval.day,
    this.aggregateType = AggregateType.sum,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': 1,
      'graphType': graphType.index,
      'graphColor': graphColor.index,
      'graphBackgroundColor': graphBackgroundColor.index,
      'isCurved': isCurved,
      'showGridLines': showGridLines,
      'aggregate': aggregate,
      'aggregateInterval': aggregateInterval.index,
      'aggregateType': aggregateType.index
    };
  }

  GraphSettings.fromJson(Map<String, dynamic> settings)
      : graphType = GraphType.values[(settings['graphType'] ?? 0) as int],
        graphColor = GraphColor.values[(settings['graphColor'] ?? 0) as int],
        graphBackgroundColor = GraphBackgroundColor
            .values[(settings['graphBackgroundColor'] ?? 0) as int],
        isCurved = (settings['isCurved'] ?? false) as bool,
        showGridLines = (settings['showGridLines'] ?? true) as bool,
        aggregate = (settings['aggregate'] ?? false) as bool,
        aggregateInterval = AggregateInterval
            .values[(settings['aggregateInterval'] ?? 0) as int],
        aggregateType =
            AggregateType.values[(settings['aggregateType'] ?? 0) as int];
}
