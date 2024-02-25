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
    final Future<List<Log>> future = dbService.getLogs();

    future.then((value) {
      _items = value;
      notifyListeners();
    });
  }

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Log> get items => UnmodifiableListView(_items);

  /// Adds new [log] to Database. Returns null on success and
  void add(Log log) {
    if (log.id == -1) {
      dbService.insertLog(log);
      _items.add(log);
    } else {
      dbService.updateLog(log);
    }

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
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
}
