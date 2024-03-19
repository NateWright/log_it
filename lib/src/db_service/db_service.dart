import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:log_it/src/log_feature/photo.dart';
import 'package:log_it/src/notifcation_service/notification.dart';
import 'package:path/path.dart' as p;
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbService {
  late Future<Database> database;
  late String _path;

  DbService() {
    init() async {
      String path = await getDatabasesPath();
      _path = join(path, 'database.db');
    }

    database = init().then(
      (_) {
        return _initializeDB();
      },
    );
  }

  DbService.linux() {
    init() async {
      final io.Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      _path = p.join(appDocumentsDir.path, "databases", "database.db");
    }

    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    database = init().then(
      (_) {
        return _initializeDB();
      },
    );
  }

  Future<Database> _initializeDB() async {
    return openDatabase(
      _path,
      onCreate: (database, version) async {
        const String createLogs =
            'CREATE TABLE logs(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, dataType INTEGER, unit TEXT, hasNotifications INTEGER, dateRangeBegin TEXT, dateRangeEnd TEXT, startTimeHour INTEGER, startTimeMinute INTEGER, intervalInterval INTEGER, intervalUnit INTEGER);';
        const String createNotifications =
            'CREATE TABLE notifications(id INTEGER PRIMARY KEY AUTOINCREMENT, log_id INTEGER, date TEXT);';
        await database.execute('$createLogs $createNotifications');
      },
      version: 1,
    );
  }

  Future<int> insertNotification(LogNotification notification) async {
    final db = await database;

    notification.id = await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return notification.id;
  }

  Future<void> deleteNotification(LogNotification notification) async {
    final db = await database;

    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [notification.id],
    );
    return;
  }

  Future<List<LogNotification>> getNotifications() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('notifications');

    return [
      for (final m in maps) LogNotification.fromMap(m),
    ];
  }

  Future<int> insertLog(Log log) async {
    final db = await database;

    log.id = await db.insert(
      'logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Initialize table to store data:value pairs
    switch (log.dataType) {
      case DataType.number:
        db.execute(
            'CREATE TABLE ${log.dbName}(date TEXT PRIMARY KEY, data REAL);');
        break;
      case DataType.picture:
        db.execute(
            'CREATE TABLE ${log.dbName}(date TEXT PRIMARY KEY, data TEXT);');
        break;
      default:
        throw UnimplementedError("DB could not be created");
    }
    return log.id;
  }

  Future<int> updateLog(Log log) async {
    final db = await database;
    return await db
        .update('logs', log.toMap(), where: 'id = ?', whereArgs: [log.id]);
  }

  Future<void> deleteLog(Log log) async {
    final db = await database;

    await db.delete(
      'logs',
      where: 'id = ?',
      whereArgs: [log.id],
    );
    await db.execute(
      'DROP TABLE ${log.dbName};',
    );
  }

  Future<List<Log>> getLogs() async {
    final db = await database;
    final List<Map<String, Object?>> logMaps = await db.query('logs');

    return [
      for (final log in logMaps) Log.fromMap(log),
    ];
  }

  // Numeric Operations
  Future<void> insertLogValueNumeric(Log log, Numeric numeric) async {
    final db = await database;

    await db.insert(
      log.dbName,
      numeric.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteLogValuesNumeric(Log log, List<Numeric> numeric) async {
    final db = await database;

    for (final val in numeric) {
      await db.delete(
        log.dbName,
        where: 'date = ?',
        whereArgs: [val.date.toString()],
      );
    }
  }

  Future<List<Numeric>> getLogValuesNumeric(Log log) async {
    final db = await database;

    List<Map<String, Object?>> values =
        await db.query(log.dbName, orderBy: 'date');

    return [
      for (final val in values) Numeric.fromMap(val),
    ];
  }

  // Picture Operations
  Future<void> insertLogValuePhoto(Log log, Photo photo) async {
    final db = await database;

    final id = await db.insert(
      log.dbName,
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final dir = await getApplicationDocumentsDirectory();
    final ext = p.extension(photo.data);
    var outputDir =
        await Directory('${dir.path}/${log.dbName}').create(recursive: true);
    await File(photo.data).copy('${outputDir.path}/image$id$ext');

    photo.data = 'image$id$ext';
    await db.insert(
      log.dbName,
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteLogValuesPhoto(Log log, List<Photo> photos) async {
    final db = await database;

    final appDir = await getApplicationDocumentsDirectory();
    final dir =
        await Directory('${appDir.path}/${log.dbName}').create(recursive: true);
    for (final val in photos) {
      final file = File('${dir.path}/${val.data}');
      if (await file.exists()) {
        await file.delete();
      }
      await db.delete(
        log.dbName,
        where: 'date = ?',
        whereArgs: [val.date.toString()],
      );
    }
  }

  Future<List<Photo>> getLogValuesPhoto(Log log) async {
    final db = await database;

    List<Map<String, Object?>> values =
        await db.query(log.dbName, orderBy: 'date');

    return [
      for (final val in values) Photo.fromMap(val),
    ];
  }
}
