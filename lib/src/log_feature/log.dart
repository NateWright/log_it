import 'package:flutter/material.dart';

enum TimeIntervalUnits { minutes, hours, days, months, years }

enum DataType { number, picture }

class TimeInterval {
  TimeInterval(this.interval, this.unit);

  int interval;
  TimeIntervalUnits unit;
}

class LogItem {
  String title;
  String description;
  DataType dataType;
  String unit;
  bool hasNotifications;
  DateTimeRange dateRange;
  TimeOfDay startTime;
  TimeInterval interval;
  LogItem({
    required this.title,
    required this.description,
    required this.dataType,
    required this.unit,
    required this.hasNotifications,
    required this.dateRange,
    required this.startTime,
    required this.interval,
  });
}
