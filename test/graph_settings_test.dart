// ignore_for_file: unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:log_it/src/log_feature/graph_settings.dart';

void main() {
  late GraphSettings sut;
  group(
    'GraphSetting constructor',
    () {
      test(
        'first test.',
        () {
          GraphType graphType;
          GraphColor graphColor;
          GraphBackgroundColor graphBackgroundColor;
          bool isCurved;
          bool showGridLines;
          bool aggregate;
          AggregateInterval aggregateInterval;
          AggregateType aggregateType;
          sut = GraphSettings(
            graphType: GraphType.line,
            graphColor: GraphColor.yellow,
            graphBackgroundColor: GraphBackgroundColor.black,
            isCurved: true,
            showGridLines: true,
            aggregate: true,
            aggregateInterval: AggregateInterval.day,
            aggregateType: AggregateType.sum,
          );
          expect(sut.graphType, GraphType.line);
          expect(sut.graphColor, GraphColor.yellow);
          expect(sut.graphBackgroundColor, GraphBackgroundColor.black);
          expect(sut.isCurved, true);
          expect(sut.showGridLines, true);
          expect(sut.aggregate, true);
          expect(sut.aggregateInterval, AggregateInterval.day);
          expect(sut.aggregateType, AggregateType.sum);
        },
      );
    },
  );

  group(
    'GraphSetting constructor',
    () {
      test(
        'first map test.',
        () {
          const version = 1;
          const graphType = 0;
          const graphColor = 4;
          const graphBackgroundColor = 2;
          const isCurved = true;
          const showGridLines = true;
          const aggregate = true;
          const aggregateInterval = 0;
          const aggregateType = 0;
          final map = {
            'version': version,
            'graphType': graphType,
            'graphColor': graphColor,
            'graphBackgroundColor': graphBackgroundColor,
            'isCurved': isCurved,
            'showGridLines': showGridLines,
            'aggregate': aggregate,
            'aggregateInterval': aggregateInterval,
            'aggregateType': aggregateType, 
          };
          sut = GraphSettings.fromJson(map);
          expect(sut.graphType, GraphType.values[0]);
          expect(sut.graphColor, GraphColor.values[4]);
          expect(sut.graphBackgroundColor, GraphBackgroundColor.values[2]);
          expect(sut.isCurved, true);
          expect(sut.showGridLines, true);
          expect(sut.aggregate, true);
          expect(sut.aggregateInterval, AggregateInterval.values[0]);
          expect(sut.aggregateType, AggregateType.values[0]);
        },
      );
    },
  );
}
