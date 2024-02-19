import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/numeric.dart';

class LogModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  List<Log> _items = [];
  final DbService dbService = DbService();

  LogModel() {
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
    dbService.insertLog(log);
    _items.add(log);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  bool hasTitle(String title) {
    if (_items.any((element) => element.title == title)) {
      return true;
    }
    return false;
  }

  void addDataNumeric(Log log, double value) {
    dbService.insertLogValueNumeric(
      log,
      Numeric(date: DateTime.now(), data: value),
    );
    notifyListeners();
  }

  Future<List<Numeric>> getDataNumeric(Log log) {
    return dbService.getLogValuesNumeric(log);
  }
}
