import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:log_it/src/log_feature/log.dart';

void main() {
  late Log sut;

  group(
    'constructor',
    () {
      test('default', () {
        const startTime = TimeOfDay(hour: 9, minute: 0);
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

        expect(sut.id, -1);
      });

      test('default2', () {
        const startTime = TimeOfDay(hour: 3, minute: 45);
        sut = Log(
          title: 'Test2',
          description: 'Test 2 Description',
          dataType: DataType.number,
          unit: 'kg',
          hasNotifications: false,
          dateRange: DateTimeRange(
              start: DateTime(2024, 1, 23), end: DateTime(2024, 3, 29)),
          interval: TimeInterval(5, TimeIntervalUnits.hours),
          startTime: startTime,
        );
      });

      test('default3', () {
        const startTime = TimeOfDay(hour: 1, minute: 1);
        sut = Log(
          title: 'Test3',
          description: 'Test 3 Description',
          dataType: DataType.number,
          unit: 'miles',
          hasNotifications: true,
          dateRange: DateTimeRange(
              start: DateTime(2023, 1, 1), end: DateTime(2023, 12, 31)),
          interval: TimeInterval(1, TimeIntervalUnits.days),
          startTime: startTime,
        );
      });

      test('default4', () {
        const startTime = TimeOfDay(hour: 4, minute: 4);
        sut = Log(
          title: 'Test4',
          description: 'Test 4 Description',
          dataType: DataType.picture,
          unit: 'jpg',
          hasNotifications: false,
          dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
          interval: TimeInterval(1, TimeIntervalUnits.days),
          startTime: startTime,
        );
      });

      test('default5', () {
        const startTime = TimeOfDay(hour: 5, minute: 56);
        sut = Log(
          title: 'Test5',
          description: 'Test 5 Description',
          dataType: DataType.number,
          unit: 'grams',
          hasNotifications: true,
          dateRange: DateTimeRange(
              start: DateTime(2024, 1, 16), end: DateTime(2024, 4, 26)),
          interval: TimeInterval(1, TimeIntervalUnits.days),
          startTime: startTime,
        );
      });

      test('default6', () {
        const startTime = TimeOfDay(hour: 4, minute: 30);
        sut = Log(
          title: 'Test6',
          description: 'Test 6 Description',
          dataType: DataType.number,
          unit: 'cm',
          hasNotifications: false,
          dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
          interval: TimeInterval(3, TimeIntervalUnits.hours),
          startTime: startTime,
        );
      });

      test('default7', () {
        const startTime = TimeOfDay(hour: 2, minute: 16);
        sut = Log(
          title: 'Test7',
          description: 'Test 7 Description',
          dataType: DataType.number,
          unit: 'tsp',
          hasNotifications: false,
          dateRange: DateTimeRange(
              start: DateTime(2024, 1, 23, 4, 30),
              end: DateTime(2024, 1, 23, 4, 35)),
          interval: TimeInterval(1, TimeIntervalUnits.minutes),
          startTime: startTime,
        );
      });

      test('default8', () {
        const startTime = TimeOfDay(hour: 10, minute: 16);
        sut = Log(
          title: 'Test8',
          description: 'Test 8 Description',
          dataType: DataType.picture,
          unit: 'png',
          hasNotifications: true,
          dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
          interval: TimeInterval(2, TimeIntervalUnits.days),
          startTime: startTime,
        );
      });

      test('default9', () {
        const startTime = TimeOfDay(hour: 11, minute: 59);
        sut = Log(
          title: 'Test9',
          description: 'Test 9 Description',
          dataType: DataType.number,
          unit: 'joules',
          hasNotifications: false,
          dateRange: DateTimeRange(
              start: DateTime(2024, 1, 1, 0, 0),
              end: DateTime(2024, 12, 31, 11, 59)),
          interval: TimeInterval(1, TimeIntervalUnits.days),
          startTime: startTime,
        );
      });

      test('defaultX', () {
        const startTime = TimeOfDay(hour: 0, minute: 0);
        sut = Log(
          title: 'TestX',
          description: 'Test X Description',
          dataType: DataType.number,
          unit: 'X',
          hasNotifications: true,
          dateRange: DateTimeRange(
              start: DateTime(0, 0, 0, 0, 0), end: DateTime(0, 0, 0, 0, 0)),
          interval: TimeInterval(0, TimeIntervalUnits.days),
          startTime: startTime,
        );
      });
    },
  );
}
