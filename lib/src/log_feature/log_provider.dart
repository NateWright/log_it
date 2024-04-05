import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/graph_settings.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:log_it/src/log_feature/photo.dart';
import 'package:log_it/src/notification_service/notification.dart';
import 'package:log_it/src/notification_service/notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  Map<int, Log> _items = {};
  DbService dbService;
  NotificationService notificationService;
  bool loading = false;
  late Timer timer;
  static int notificationLog = 0;
  static final preferences = SharedPreferences.getInstance();

  LogProvider({required this.dbService, required this.notificationService}) {
    timer = Timer.periodic(
      const Duration(minutes: 3),
      (timer) => _cleanAndScheduleNotifications(),
    );
    _updateLogs().then((value) async {
      loading = false;
      _cleanAndScheduleNotifications();
    });
  }

  // An unmodifiable view of the items in the cart.
  UnmodifiableListView<Log> get items => UnmodifiableListView(_items.values);

  void initializeLogNotification(Log log, DateTime now) async {
    if (!log.hasNotifications) return;

    final startDate = log.dateRange.start;
    final startTime = log.startTime;
    final start = DateTime(startDate.year, startDate.month, startDate.day,
        startTime.hour, startTime.minute);
    final notificationStart =
        now.millisecondsSinceEpoch - start.millisecondsSinceEpoch;

    int initial =
        (notificationStart / log.interval.getDuration().inMilliseconds).ceil() +
            start.millisecondsSinceEpoch;
    for (var i = 0; i < 5; i++) {
      try {
        final result = await _scheduleNotification(log, initial);
        if (!result) {
          break;
        }
      } catch (e) {
        // Do not schedule
      }

      initial += log.interval.getDuration().inMilliseconds;
    }
  }

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
      await dbService.clearNotifications(log);
    }

    initializeLogNotification(log, DateTime.now());

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
    final preferences = await LogProvider.preferences;

    final settingsString = preferences.getString(log.dbName);

    if (settingsString == null) {
      final initSettings = GraphSettings();
      preferences.setString(log.dbName, jsonEncode(initSettings));
      return initSettings;
    } else {
      final settingsMap = jsonDecode(settingsString) as Map<String, dynamic>;
      return GraphSettings.fromJson(settingsMap);
    }
  }

  logUpdateSettings(Log log, GraphSettings settings) async {
    final preferences = await LogProvider.preferences;

    return preferences
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

  Future<dynamic> exportData(Log log) async {
    switch (log.dataType) {
      case DataType.number:
        if (log.dataType != DataType.number) {
          return Uint8List.fromList([]);
        }
        final data = await dbService.getLogValuesNumeric(log);
        List<int> bytes = [];
        for (final d in data) {
          bytes.addAll(utf8.encode('${d.toCSV()}\n'));
        }
        return Uint8List.fromList(bytes);

      case DataType.picture:
        final dir = await getApplicationDocumentsDirectory();
        var outputDir =
            await Directory('${dir.path}/tmp').create(recursive: true);
        final tempArchive = '${outputDir.path}/output.zip';

        var encoder = ZipFileEncoder();
        encoder.create(tempArchive);

        final data = await dbService.getLogValuesPhoto(log);
        final csvFile = File('${outputDir.path}/data.csv');
        final sink = csvFile.openWrite();

        for (final d in data) {
          sink.add(utf8.encode('${d.toCSV()}\n'));
          encoder.addFile(File('${dir.path}/${log.dbName}/${d.data}'));
        }
        await sink.flush();
        await sink.close();
        encoder.addFile(csvFile);
        encoder.close();
        return tempArchive;

      default:
        throw UnimplementedError('Cannot export this datatype');
    }
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

  Future<void> _cleanAndScheduleNotifications() async {
    final now = DateTime.now();
    await dbService.deleteBefore(now);

    List<LogNotification> notificationList = await dbService.getNotifications();

    // Insert notification so all have 5
    for (final log in _items.values) {
      if (!log.hasNotifications) continue;

      List<LogNotification> notifications =
          await dbService.getLogNotifications(log.id);

      if (notifications.isEmpty) {
        initializeLogNotification(log, now);
        continue;
      }

      int initial = notificationList.first.date.millisecondsSinceEpoch;
      for (var n in notificationList) {
        if (n.date.millisecondsSinceEpoch > initial) {
          initial = n.date.millisecondsSinceEpoch;
        }
      }
      for (var i = 0; i < 5 - notifications.length; i++) {
        initial += log.interval.getDuration().inMilliseconds;
        try {
          final result = await _scheduleNotification(log, initial);
          if (!result) {
            break;
          }
        } catch (e) {
          // Notification error
        }
      }
    }
  }

  Future<bool> _scheduleNotification(Log log, int initial) async {
    int id = await dbService.insertNotification(
      LogNotification(
        logID: log.id,
        date: DateTime.fromMillisecondsSinceEpoch(initial),
      ),
    );
    if (log.dateRange.start != log.dateRange.end &&
        DateTime.fromMillisecondsSinceEpoch(initial)
            .isAfter(log.dateRange.end)) {
      return false;
    }
    await notificationService.scheduleNotification(
      id: id,
      title: log.title,
      body: 'Enter data for your log',
      payload: log.id.toString(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(initial),
    );
    return true;
  }
}
