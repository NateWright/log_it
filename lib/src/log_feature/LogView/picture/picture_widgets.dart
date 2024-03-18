import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/LogView/picture/SlideshowView/slideshow_view.dart';
import 'package:log_it/src/log_feature/LogView/numeric/numeric_widgets.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';

class PictureWidgets implements NumericWidgets {
  final BuildContext _context;
  final Log _log;
  final LogProvider _logProvider;

  PictureWidgets({
    required context,
    required log,
    required logProvider,
  })  : _context = context,
        _log = log,
        _logProvider = logProvider;

  @override
  addData() {
    // TODO: implement addData
    throw UnimplementedError();
  }

  @override
  widgets() {
    final theme = Theme.of(_context);

    return [
      const Slideshow(),
      Divider(
        color: theme.colorScheme.secondary,
        // color: Colors.white,
      ),
      ListTile(
        title: const Text('Raw Data'),
        subtitle: const Text('View and Delete Pictures'),
        trailing: Icon(
          Icons.navigate_next,
          size: theme.textTheme.displaySmall!.fontSize,
        ),
        onTap: () {
          Navigator.push(
            _context,
            MaterialPageRoute(
              builder: (context) => throw UnimplementedError(),
              // builder: (context) => PictureDataView(log: _log),
            ),
          );
        },
      ),
    ];
  }
}
