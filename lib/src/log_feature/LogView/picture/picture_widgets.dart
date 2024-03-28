import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log_it/src/components/form_date_picker.dart';
import 'package:log_it/src/components/form_time_picker.dart';
import 'package:log_it/src/log_feature/LogView/picture/SlideshowView/slideshow_view.dart';
import 'package:log_it/src/log_feature/LogView/numeric/numeric_widgets.dart';
import 'package:log_it/src/log_feature/LogView/picture/picture_raw_data_view.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/photo.dart';
import 'package:provider/provider.dart';

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
  addData() => PhotoAddDataForm(log: _log);

  @override
  widgets() {
    final theme = Theme.of(_context);

    return [
      Slideshow(
        log: _log,
        futurePhotos: _logProvider.getDataPhoto(_log),
      ),
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
              builder: (context) => PictureRawDataView(log: _log),
            ),
          );
        },
      ),
    ];
  }

  @override
  exportData() async {
    String archive = await _logProvider.exportData(_log);
    final params = SaveFileDialogParams(
      fileName: 'output.zip',
      sourceFilePath: archive,
    );
    await FlutterFileDialog.saveFile(params: params);
  }
}

class PhotoAddDataForm extends StatefulWidget {
  final Log log;
  const PhotoAddDataForm({
    super.key,
    required this.log,
  });

  @override
  State<PhotoAddDataForm> createState() => _PhotoAddDataFormState();
}

class _PhotoAddDataFormState extends State<PhotoAddDataForm> {
  final _formKey = GlobalKey<FormState>();

  String input = '';
  Photo photo = Photo(date: DateTime.now(), data: '');
  XFile? image;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: theme.shadowColor,
        title: Text(
          'Select or Take Picture',
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        // actions: [],
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      image != null
                          ? Image.file(File(image!.path))
                          : const Text('Say Cheese'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                final image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  this.image = image;
                                });
                              },
                              child: const Text('Select Photo'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                final path = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                if (path == null) return;
                                setState(() {
                                  image = path;
                                });
                              },
                              child: const Text('Take Photo'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FormDatePicker(
                            initialDate: photo.date,
                            onChanged: (value) {
                              photo.date = DateTime(
                                value.year,
                                value.month,
                                value.day,
                                photo.date.hour,
                                photo.date.minute,
                                0,
                                0,
                              );
                            },
                          ),
                          FormTimePicker(
                              initialTime: TimeOfDay.fromDateTime(photo.date),
                              onChanged: (value) {
                                photo.date = DateTime(
                                  photo.date.year,
                                  photo.date.month,
                                  photo.date.day,
                                  value.hour,
                                  value.minute,
                                  0,
                                  0,
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      if (image == null) return;
                      photo.data = image!.path;
                      final result =
                          await Provider.of<LogProvider>(context, listen: false)
                              .addDataPhoto(widget.log, photo);
                      if (result == null) {
                        if (mounted) Navigator.of(context).pop();
                      } else {
                        final snackBar = SnackBar(
                          content: Text(result),
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    }
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
