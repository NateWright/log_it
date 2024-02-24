import 'package:flutter/material.dart';

Future<String?> confirmationDialog(
        BuildContext context, String title, String description) =>
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'NO'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'YES'),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
