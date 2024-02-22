import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService {
  late Future<Database> database;

  DbService() {
    database = _initializeDB();
  }

  Future<Database> _initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE logs(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, dataType INTEGER, unit TEXT, hasNotifications INTEGER, dateRangeBegin TEXT, dateRangeEnd TEXT, startTimeHour INTEGER, startTimeMinute INTEGER, intervalInterval INTEGER, intervalUnit INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertLog(Log log) async {
    final db = await database;

    log.id = await db.insert(
      'logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Initialize table to store data:value pairs
    if (log.dataType == DataType.number) {
      db.execute(
          'CREATE TABLE ${log.dbName}(date TEXT PRIMARY KEY, data REAL);');
    }
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

  Future<void> insertLogValueNumeric(Log log, Numeric numeric) async {
    final db = await database;

    await db.insert(
      log.dbName,
      numeric.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Numeric>> getLogValuesNumeric(Log log) async {
    final db = await database;

    List<Map<String, Object?>> values = await db.query(log.dbName);

    return [
      for (final val in values) Numeric.fromMap(val),
    ];
  }
}
