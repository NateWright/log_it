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

class GraphSettings {
  GraphType graphType;
  GraphColor graphColor;
  GraphBackgroundColor graphBackgroundColor;
  bool isCurved;
  bool showGridLines;

  GraphSettings({
    this.graphType = GraphType.line,
    this.graphColor = GraphColor.black,
    this.graphBackgroundColor = GraphBackgroundColor.white,
    this.isCurved = false,
    this.showGridLines = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': 1,
      'graphType': graphType.index,
      'graphColor': graphColor.index,
      'graphBackgroundColor': graphBackgroundColor.index,
      'isCurved': isCurved,
      'showGridLines': showGridLines,
    };
  }

  GraphSettings.fromJson(Map<String, dynamic> settings)
      : graphType = GraphType.values[settings['graphType'] as int],
        graphColor = GraphColor.values[settings['graphColor'] as int],
        graphBackgroundColor = GraphBackgroundColor
            .values[settings['graphBackgroundColor'] as int],
        isCurved = settings['isCurved'] as bool,
        showGridLines = settings['showGridLines'] as bool;
}
