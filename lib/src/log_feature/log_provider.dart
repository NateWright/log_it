import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/log.dart';

class LogModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<LogItem> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<LogItem> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $42).
  // int get totalPrice => _items.length * 42;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(LogItem item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
