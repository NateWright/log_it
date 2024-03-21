import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:log_it/src/log_feature/numeric.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDbService extends Mock implements DbService {}

void main() {
  late LogProvider sut;
  late MockDbService mockDbService;

  mockGetLogs(List<Log> logs) =>
      when(() => mockDbService.getLogs()).thenAnswer((_) async => logs);

  mockInsertLog(Log log, int id) =>
      when(() => mockDbService.insertLog(log)).thenAnswer((_) async {
        return id;
      });
  mockUpdateLog(Log log, int ret) =>
      when(() => mockDbService.updateLog(log)).thenAnswer((_) async {
        return ret;
      });
  mockDeleteLog(Log log) =>
      when(() => mockDbService.deleteLog(log)).thenAnswer((_) async {
        return;
      });

  mockAddDataNumeric(Log log, Numeric numeric) =>
      when(() => mockDbService.insertLogValueNumeric(log, numeric))
          .thenAnswer((_) async {
        return;
      });

  mockDeleteDataNumeric(Log log, List<Numeric> numerics) =>
      when(() => mockDbService.deleteLogValuesNumeric(log, numerics))
          .thenAnswer((_) async {
        return;
      });

  mockGetDataNumeric(Log log, List<Numeric> values) =>
      when(() => mockDbService.getLogValuesNumeric(log)).thenAnswer((_) async {
        return values;
      });

  setUp(() {
    mockDbService = MockDbService();
  });

  group(
    'constructor',
    () {
      test(
        'initial values are correct',
        () {
          mockGetLogs([]);
          sut = LogProvider(mockDbService);
          expect(sut.items, []);
        },
      );

      test(
        'gets items on init',
        () async {
          Log log = createLog();
          mockGetLogs([log]);

          sut = LogProvider(mockDbService);

          await Future.doWhile(() => !sut.loading);

          expect(sut.items, [log]);
        },
      );
    },
  );

  group(
    'add()',
    () {
      test(
        'Add with Log.id = -1',
        () {
          Log blank = createBlankLog();
          mockGetLogs([]);
          mockInsertLog(blank, 1);
          mockUpdateLog(blank, 1);
          sut = LogProvider(mockDbService);

          sut.add(blank);

          verify(() => mockDbService.insertLog(blank)).called(1);
          verifyNever(() => mockDbService.updateLog(blank));
        },
      );

      test(
        'Add with Log.id = 1',
        () {
          Log log = createLog();
          mockGetLogs([]);
          mockInsertLog(log, 1);
          mockUpdateLog(log, 1);

          sut = LogProvider(mockDbService);

          sut.add(log);
          verify(() => mockDbService.updateLog(log)).called(1);
          verifyNever(() => mockDbService.insertLog(log));
        },
      );

      test('adds log to _items', () async {
        Log blank = createBlankLog();

        mockGetLogs([]);
        mockInsertLog(blank, 1);
        mockUpdateLog(blank, 1);

        sut = LogProvider(mockDbService);

        mockGetLogs([blank]);

        await sut.add(blank);

        expect(sut.items, [blank]);
      });
    },
  );

  group(
    'delete()',
    () {
      test(
        'Delete',
        () async {
          Log log = createBlankLog();
          mockGetLogs([]);
          mockInsertLog(log, 1);
          mockDeleteLog(log);
          mockUpdateLog(log, 1);
          when(() => mockDbService.getLogs()).thenAnswer((invocation) async {
            log.id = 1;
            return [log];
          });
          sut = LogProvider(mockDbService);

          await sut.add(log);
          await sut.delete(log);
          verify(() => mockDbService.deleteLog(log)).called(1);
        },
      );

      test(
        'Delete Empty',
        () async {
          Log log = createBlankLog();
          mockGetLogs([]);
          mockInsertLog(log, 1);
          mockDeleteLog(log);
          mockUpdateLog(log, 1);
          when(() => mockDbService.getLogs()).thenAnswer((invocation) async {
            log.id = 1;
            return [log];
          });
          sut = LogProvider(mockDbService);

          await sut.delete(log);
          verifyNever(() => mockDbService.deleteLog(log));
        },
      );
    },
  );

  group(
    'addDataNumeric()',
    () {
      test(
        'test adding data to good log',
        () async {
          Log log = createLog();
          Numeric n = Numeric(date: DateTime(2000), data: 10.0);
          mockGetLogs([log]);
          mockAddDataNumeric(log, n);
          sut = LogProvider(mockDbService);

          await Future.doWhile(() => !sut.loading);

          await sut.addDataNumeric(log, n);

          verify(() => mockDbService.insertLogValueNumeric(log, n)).called(1);
        },
      );

      test(
        'test adding data to non existent log',
        () async {
          Log log = createLog();
          Numeric n = Numeric(date: DateTime(2000), data: 10.0);
          mockGetLogs([]);
          mockAddDataNumeric(log, n);
          sut = LogProvider(mockDbService);

          await Future.doWhile(() => !sut.loading);

          await sut.addDataNumeric(log, n);

          verifyNever(() => mockDbService.insertLogValueNumeric(log, n));
        },
      );
    },
  );

  group(
    'deleteDataNumeric()',
    () {
      test(
        'test deleting data from good log',
        () async {
          Log log = createLog();
          Numeric n = Numeric(date: DateTime(2000), data: 10.0);
          mockGetLogs([log]);
          mockDeleteDataNumeric(log, [n]);
          sut = LogProvider(mockDbService);

          await Future.doWhile(() => !sut.loading);

          await sut.deleteDataNumeric(log, [n]);

          verify(() => mockDbService.deleteLogValuesNumeric(log, [n]))
              .called(1);
        },
      );

      test(
        'test deleting data to non existent log',
        () async {
          Log log = createLog();
          Numeric n = Numeric(date: DateTime(2000), data: 10.0);
          mockGetLogs([]);
          mockDeleteDataNumeric(log, [n]);
          sut = LogProvider(mockDbService);

          await Future.doWhile(() => !sut.loading);

          await sut.deleteDataNumeric(log, [n]);

          verifyNever(() => mockDbService.deleteLogValuesNumeric(log, [n]));
        },
      );
    },
  );

  group(
    'getDataNumeric()',
    () {
      test(
        'test getting data from good log',
        () async {
          Log log = createLog();
          Numeric n = Numeric(date: DateTime(2000), data: 10.0);
          mockGetLogs([log]);
          mockGetDataNumeric(log, [n]);
          sut = LogProvider(mockDbService);

          await Future.doWhile(() => !sut.loading);

          List<Numeric> l = await sut.getDataNumeric(log);

          expect([n], l);

          verify(() => mockDbService.getLogValuesNumeric(log)).called(1);
        },
      );

      test(
        'test getting data on non existent log',
        () async {
          Log log = createLog();
          Numeric n = Numeric(date: DateTime(2000), data: 10.0);
          mockGetLogs([]);
          mockDeleteDataNumeric(log, [n]);
          sut = LogProvider(mockDbService);

          await Future.doWhile(() => !sut.loading);

          await sut.getDataNumeric(log);

          verifyNever(() => mockDbService.getLogValuesNumeric(log));
        },
      );
    },
  );
}

Log createBlankLog() {
  return Log(
      title: 'test',
      description: 'test',
      dataType: DataType.number,
      unit: 'kg',
      hasNotifications: false,
      dateRange: DateTimeRange(start: DateTime(2000), end: DateTime(2001)),
      startTime: const TimeOfDay(hour: 1, minute: 1),
      interval: TimeInterval(10, TimeIntervalUnits.days));
}

Log createLog() {
  final log = Log(
      title: 'test',
      description: 'test',
      dataType: DataType.number,
      unit: 'kg',
      hasNotifications: false,
      dateRange: DateTimeRange(start: DateTime(2000), end: DateTime(2001)),
      startTime: const TimeOfDay(hour: 1, minute: 1),
      interval: TimeInterval(10, TimeIntervalUnits.days));
  log.id = 1;
  return log;
}
