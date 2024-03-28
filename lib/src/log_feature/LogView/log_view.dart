import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/CreateForm/log_create_form.dart';
import 'package:log_it/src/log_feature/LogView/numeric/numeric_widgets.dart';
import 'package:log_it/src/log_feature/LogView/picture/picture_widgets.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:provider/provider.dart';

enum SettingsOptions { delete }

/// Displays detailed information about a SampleItem.
class LogView extends StatelessWidget {
  const LogView({super.key});

  static const routeName = '/log_view';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    int id;
    if (args == null || args is! Map) {
      id = LogProvider.notificationLog;
    } else {
      id = (args['id'] ?? '-1') as int;
    }
    if (id == -1) {
      Navigator.pop(context);
      return const Text('Error');
    }
    final theme = Theme.of(context);

    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        Log? l = logProvider.getLog(id);
        if (l == null) {
          return const Center(child: CircularProgressIndicator());
        }
        Log log = l;
        late NumericWidgets logWidgets;
        switch (log.dataType) {
          case DataType.number:
            logWidgets = NumericWidgets(
              context: context,
              log: log,
              logProvider: logProvider,
            );
            break;
          case DataType.picture:
            logWidgets = PictureWidgets(
              context: context,
              log: log,
              logProvider: logProvider,
            );
            break;
          default:
            throw UnimplementedError();
        }
        return Scaffold(
          appBar: AppBar(
            elevation: 4,
            shadowColor: theme.shadowColor,
            title: Text(
              log.title,
              style: theme.textTheme.headlineLarge,
            ),
            centerTitle: true,
            actions: [
              MenuAnchor(
                builder: (context, controller, child) => IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                ),
                menuChildren: [
                  MenuItemButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        LogCreateFormPage.routeName,
                        arguments: {
                          'id': id,
                        },
                      );
                    },
                    leadingIcon: const Icon(Icons.settings),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 12.0, 12, 12),
                      child: Text('EDIT'),
                    ),
                  ),
                  MenuItemButton(
                    onPressed: () => logWidgets.exportData(),
                    leadingIcon: const Icon(Icons.settings),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 12.0, 12, 12),
                      child: Text('Export'),
                    ),
                  ),
                  _DeleteWidget(
                    log: log,
                    context: context,
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(8.0),
            children: logWidgets.widgets(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                // Create the SelectionScreen in the next step.
                MaterialPageRoute(builder: (context) => logWidgets.addData()),
              );
            },
            tooltip: 'Add new log',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _DeleteWidget extends StatelessWidget {
  const _DeleteWidget({
    required this.log,
    required this.context,
  });

  final Log log;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      style: MenuItemButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        iconColor: Colors.white,
      ),
      leadingIcon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Are you sure you want to delete ${log.title}?',
              ),
              content: const Text('Deleting a log is irreversible.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('NO'),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<LogProvider>(context, listen: false)
                        .delete(log);
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName("/"),
                    );
                  },
                  child: const Text('YES'),
                ),
              ],
            );
          },
        );
      },
      child: const Padding(
        padding: EdgeInsets.fromLTRB(0, 12.0, 12, 12),
        child: Text('Delete'),
      ),
    );
  }
}
