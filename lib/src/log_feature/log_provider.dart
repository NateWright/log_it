import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/log.dart';

class LogModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  List<Log> _items = [];
  final DbService dbService = DbService();

  LogModel() {
    final Future<List<Log>> future = dbService.getItems();

    future.then((value) {
      _items = value;
      notifyListeners();
    });
  }

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Log> get items => UnmodifiableListView(_items);

  /// Adds new [log] to LogList. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Log log) {
    _items.add(log);
    dbService.insertLog(log);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all logs from the LogList.
  // void removeAll() {
  //   _items.clear();
  //   // This call tells the widgets that are listening to this model to rebuild.
  //   notifyListeners();
  // }
}
