import 'package:log_it/src/log_feature/log.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE logs(title TEXT PRIMARY KEY, description TEXT, dataType INTEGER, unit TEXT, hasNotifications INTEGER, dateRangeBegin TEXT, dateRangeEnd TEXT, startTimeHour INTEGER, startTimeMinute INTEGER, intervalInterval INTEGER, intervalUnit INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertLog(Log log) async {
    final db = await initializeDB();

    print(log.toString());

    await db.insert(
      'logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Log>> getItems() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> logMaps = await db.query('logs');

    return [
      for (final log in logMaps) Log.fromMap(log),
    ];
  }
}
