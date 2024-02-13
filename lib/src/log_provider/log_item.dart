import 'package:flutter/material.dart';
import 'package:log_it/src/components/pair.dart';

enum TimeIntervalUnits { minutes, hours, days, months, years }

class TimeInterval {
  TimeInterval(this.interval, this.unit);

  int interval;
  TimeIntervalUnits unit;
}

class LogItem {
  const LogItem(this.title, this.description, this.dateRange, this.startTime,
      this.interval);

  final String title;
  final String description;
  final DateTimeRange dateRange;
  final TimeOfDay startTime;
  final TimeInterval interval;
}
