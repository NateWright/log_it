import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/numeric.dart';

class LogProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  Map<int, Log> _items = {};
  DbService dbService;
  bool loading = false;
  static int notificationLog = 0;

  LogProvider(this.dbService) {
    _updateLogs().then((value) {
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
  Future<void> add(Log log) {
    Future<void> ret;
    if (log.id == -1) {
      ret = dbService.insertLog(log);
    } else {
      ret = dbService.updateLog(log);
    }

    return ret.then((_) => _updateLogs());
  }

  Future<void> delete(Log log) async {
    if (_items.containsKey(log.id)) {
      Future<void> ret = dbService.deleteLog(log);
      return ret.then((_) => _updateLogs());
    }
  }

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
