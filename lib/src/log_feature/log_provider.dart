import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/numeric.dart';

class LogProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  List<Log> _items = [];
  DbService dbService;

  LogProvider(this.dbService) {
    _updateLogs();
  }

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Log> get items => UnmodifiableListView(_items);

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

  void delete(Log log) {
    dbService.deleteLog(log);
    _items.remove(log);
    notifyListeners();
  }

  // Log getLog(int id) {
  //   return _items.singleWhere((element) => element.id == id);
  // }

  bool hasTitle(String title) {
    if (_items.any((element) => element.title == title)) {
      return true;
    }
    return false;
  }

  void addDataNumeric(Log log, Numeric numeric) {
    final f = dbService.insertLogValueNumeric(
      log,
      numeric,
    );
    f.then(
      (value) => notifyListeners(),
    );
    notifyListeners();
  }

  void deleteDataNumeric(Log log, List<Numeric> vals) {
    final f = dbService.deleteLogValuesNumeric(log, vals);
    f.then(
      (value) => notifyListeners(),
    );
  }

  Future<List<Numeric>> getDataNumeric(Log log) {
    return dbService.getLogValuesNumeric(log);
  }

  void _updateLogs() {
    final Future<List<Log>> future = dbService.getLogs();

    future.then((value) => _setLogs(value));
  }

  void _setLogs(List<Log> values) {
    _items = values;
    notifyListeners();
  }
}
