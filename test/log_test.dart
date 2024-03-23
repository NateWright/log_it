import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:log_it/src/log_feature/log.dart';

void main() {
  late Log sut;

  group(
    'constructor',
    () {
      test('default', () {
        final startTime = TimeOfDay(hour: 9, minute: 0);
        sut = Log(
          title: 'Test',
          description: 'Test Description',
          dataType: DataType.number,
          unit: 'lb',
          hasNotifications: false,
          dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
          interval: TimeInterval(10, TimeIntervalUnits.days),
          startTime: startTime,
        );
      });
    },
  );
}
