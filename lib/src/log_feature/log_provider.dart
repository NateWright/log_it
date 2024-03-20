import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/graph_settings.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:log_it/src/log_feature/photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  Map<int, Log> _items = {};
  DbService dbService;
  bool loading = false;
  static int notificationLog = 0;
  static final preferences = SharedPreferences.getInstance();

  LogProvider(this.dbService) {
    _updateLogs().then((value) {
      // Check and delete old notifications

      // Insert notification so all have 5

      loading = false;
    });
  }

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Log> get items => UnmodifiableListView(_items.values);

  Log? getLog(int id) {
    if (!_items.containsKey(id)) {
      return null;
    }
    return _items[id];
  }

  /// Adds new [log] to Database. Returns null on success and
  Future<int> add(Log log) async {
    int ret;
    if (log.id == -1) {
      ret = await dbService.insertLog(log);
    } else {
      ret = await dbService.updateLog(log);
    }

    await _updateLogs();
    return ret;
  }

  Future<void> delete(Log log) async {
    if (_items.containsKey(log.id)) {
      Future<void> ret = dbService.deleteLog(log);
      return ret.then((_) => _updateLogs());
    }
  }

  Future<GraphSettings> logGetSettings(Log log) async {
    final prefs = await LogProvider.preferences;

    final settingsString = prefs.getString(log.dbName);

    if (settingsString == null) {
      final initSettings = GraphSettings();
      prefs.setString(log.dbName, jsonEncode(initSettings));
      return initSettings;
    } else {
      final settingsMap = jsonDecode(settingsString) as Map<String, dynamic>;
      return GraphSettings.fromJson(settingsMap);
    }
  }

  logUpdateSettings(Log log, GraphSettings settings) async {
    final prefs = await LogProvider.preferences;

    return prefs
        .setString(log.dbName, jsonEncode(settings))
        .then((value) => notifyListeners());
  }

  // Numeric Operations
  Future<void> addDataNumeric(Log log, Numeric numeric) async {
    if (!_items.containsKey(log.id)) {
      return;
    }
    return dbService.insertLogValueNumeric(log, numeric).then(
          (value) => notifyListeners(),
        );
  }

  Future<void> deleteDataNumeric(Log log, List<Numeric> vals) async {
    if (!_items.containsKey(log.id)) {
      return;
    }
    return dbService.deleteLogValuesNumeric(log, vals).then(
          (value) => notifyListeners(),
        );
  }

  Future<List<Numeric>> getDataNumeric(Log log) async {
    if (!_items.containsKey(log.id)) {
      return <Numeric>[];
    }
    return dbService.getLogValuesNumeric(log);
  }

  // Photo Operations
  Future<String?> addDataPhoto(Log log, Photo photo) async {
    if (!_items.containsKey(log.id)) {
      return null;
    }
    return dbService.insertLogValuePhoto(log, photo).then(
      (value) {
        notifyListeners();
        return null;
      },
    );
  }

  Future<void> deleteDataPhoto(Log log, List<Photo> vals) async {
    if (!_items.containsKey(log.id)) {
      return;
    }
    return dbService.deleteLogValuesPhoto(log, vals).then(
          (value) => notifyListeners(),
        );
  }

  Future<List<Photo>> getDataPhoto(Log log) async {
    if (!_items.containsKey(log.id)) {
      return <Photo>[];
    }
    return dbService.getLogValuesPhoto(log);
  }

  Future<void> _updateLogs() {
    loading = true;
    final Future<List<Log>> future = dbService.getLogs();

    return future.then((value) => _setLogs(value));
  }

  void _setLogs(List<Log> values) {
    _items = {for (Log v in values) v.id: v};
    notifyListeners();
  }
}

// Function to convert TimeInterval to Duration
Duration timeIntervalToDuration(TimeInterval interval) {
  switch (interval.unit) {
    case TimeIntervalUnits.years:
      return Duration(days: interval.interval * 365);
    case TimeIntervalUnits.months:
      return Duration(days: interval.interval * 30);
    case TimeIntervalUnits.days:
      return Duration(days: interval.interval);
    case TimeIntervalUnits.hours:
      return Duration(hours: interval.interval);
    case TimeIntervalUnits.minutes:
      return Duration(minutes: interval.interval);
  }
}
