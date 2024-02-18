import 'package:flutter/material.dart';

enum TimeIntervalUnits { minutes, hours, days, months, years }

enum DataType { number, picture }

class TimeInterval {
  TimeInterval(this.interval, this.unit);

  int interval;
  TimeIntervalUnits unit;

  @override
  String toString() {
    return 'TimeInterval(interval: $interval, unit: ${unit.name})';
  }
}

class Log {
  int id;
  String title;
  String description;
  DataType dataType;
  String unit;
  bool hasNotifications;
  DateTimeRange dateRange;
  TimeOfDay startTime;
  TimeInterval interval;

  Log({
    this.id = -1,
    required this.title,
    required this.description,
    required this.dataType,
    required this.unit,
    required this.hasNotifications,
    required this.dateRange,
    required this.startTime,
    required this.interval,
  });

  Log.fromMap(Map<String, Object?> log)
      : id = log['id'] as int,
        title = log['title'] as String,
        description = log['description'] as String,
        dataType = DataType.values[log['dataType'] as int],
        unit = log['unit'] as String,
        hasNotifications = log['hasNotifications'] as int == 1,
        dateRange = DateTimeRange(
          start: DateTime.parse(log['dateRangeBegin'] as String),
          end: DateTime.parse(log['dateRangeEnd'] as String),
        ),
        startTime = TimeOfDay(
          hour: log['startTimeHour'] as int,
          minute: log['startTimeMinute'] as int,
        ),
        interval = TimeInterval(
          log['intervalInterval'] as int,
          TimeIntervalUnits.values[log['intervalUnit'] as int],
        );

  Map<String, Object?> toMap() {
    return {
      'id': id == -1 ? null : id,
      'title': title,
      'description': description,
      'dataType': dataType.index,
      'unit': unit,
      'hasNotifications': hasNotifications ? 1 : 0,
      'dateRangeBegin': dateRange.start.toString(),
      'dateRangeEnd': dateRange.end.toString(),
      'startTimeHour': startTime.hour,
      'startTimeMinute': startTime.minute,
      'intervalInterval': interval.interval,
      'intervalUnit': interval.unit.index
    };
  }

  @override
  String toString() {
    return 'Log(title: $title, description: $description, dataType: ${dataType.name}, unit: $unit, hasNotifications: $hasNotifications, dateRange: $dateRange, startTime: $startTime, interval: $interval';
  }
}
