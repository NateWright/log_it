import 'dart:io';

import 'package:flutter/material.dart';
import 'package:log_it/src/components/confirmation_dialog.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/photo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PictureRawDataView extends StatefulWidget {
  final Log log;

  const PictureRawDataView({super.key, required this.log});

  static const routeName = '/log_data_view';

  @override
  State<PictureRawDataView> createState() => _PictureRawDataViewState();
}

class _PictureRawDataViewState extends State<PictureRawDataView> {
  bool editing = false;

  Map<int, Photo> checked = {};
  late Future<List<Photo>> futurePhoto;
  late Future<Directory> futureDir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          widget.log.title,
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          Visibility(
            visible: !editing,
            child: IconButton(
              onPressed: () {
                setState(() {
                  editing = true;
                });
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          Visibility(
            // Cancel
            visible: editing,
            child: IconButton(
              onPressed: () async {
                if (checked.isEmpty) {
                  setState(() {
                    editing = false;
                    checked = {};
                  });
                  return;
                }
                String? str = await confirmationDialog(
                    context,
                    'Cancel Changes?',
                    'Canceling changes will not change any data.');
                if (str == null) {
                  return;
                }
                if (str == 'NO') {
                  return;
                }
                setState(() {
                  editing = false;
                  checked = {};
                });
              },
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
            ),
          ),
          Visibility(
            // Delete
            visible: editing,
            child: IconButton(
              onPressed: () async {
                if (checked.isEmpty) {
                  setState(() {
                    editing = false;
                    checked = {};
                  });
                  return;
                }
                String? str = await confirmationDialog(
                    context,
                    'Delete Selected?',
                    'Deleting selected data is irreversible.');
                if (str == null) {
                  return;
                }
                if (str == 'NO') {
                  return;
                }
                if (context.mounted) {
                  Provider.of<LogProvider>(context, listen: false)
                      .deleteDataPhoto(widget.log, checked.values.toList());
                }
                setState(() {
                  editing = false;
                  checked = {};
                });
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
            ),
          ),
        ],
      ),
      body: Consumer<LogProvider>(
        builder: (context, value, child) {
          futurePhoto = value.getDataPhoto(widget.log);
          futureDir = getApplicationDocumentsDirectory();
          return FutureBuilder(
            future: Future.wait([futurePhoto, futureDir]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final photos = snapshot.data![0] as List<Photo>;
              final dir = snapshot.data![1] as Directory;
              return ListView.builder(
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return CheckboxListTile(
                    title: Text(photo.data, style: theme.textTheme.titleLarge),
                    secondary: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                        maxWidth: 64,
                        maxHeight: 64,
                      ),
                      child: Image.file(
                        File('${dir.path}/${widget.log.dbName}/${photo.data}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    subtitle: Text(photo.date.toString()),
                    dense: true,
                    value: checked.containsKey(index),
                    onChanged: !editing
                        ? null
                        : (value) {
                            if (value == null) {
                              return;
                            }
                            if (value) {
                              setState(() {
                                checked[index] = photos[index];
                              });
                            } else {
                              setState(() {
                                checked.remove(index);
                              });
                            }
                          },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
