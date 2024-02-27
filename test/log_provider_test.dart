import 'package:flutter/material.dart';
import 'package:log_it/src/db_service/db_service.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/log_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDbService extends Mock implements DbService {
  // Map<int, Log> _logs = {};
  // int idCounter = 1;
  // @override
  // Future<List<Log>> getLogs() async {
  //   return _logs.values.toList();
  // }

  // @override
  // Future<void> insertLog(Log log) async {
  //   if (log.id == -1) {
  //     log.id = idCounter;
  //     idCounter++;
  //   }
  //   _logs[log.id] = log;
  // }

  // @override
  // Future<void> deleteLog(Log log) async {
  //   _logs.remove(log.id);
  // }

  // @override
  // Future<int> updateLog(Log log) async {
  //   _logs[log.id] = log;
  //   return 1;
  // }
}

void main() {
  late LogProvider sut;
  late MockDbService mockDbService;

  setUp(() {});

  test(
    'initial values are correct',
    () {
      expect(sut.items, []);
    },
  );

  group(
    'add()',
    () {
      test(
        'Add with Log.id = -1',
        () {
          Log blank = createBlankLog();
          mockDbService = MockDbService();
          when(() => mockDbService.getLogs()).thenAnswer((_) async => []);
          when(() => mockDbService.insertLog(blank)).thenAnswer((_) async {
            return;
          });
          when(() => mockDbService.updateLog(blank)).thenAnswer((_) async {
            return 1;
          });
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
          mockDbService = MockDbService();
          when(() => mockDbService.getLogs()).thenAnswer((_) async => []);
          when(() => mockDbService.insertLog(log)).thenAnswer((_) async {
            return;
          });
          when(() => mockDbService.updateLog(log)).thenAnswer((_) async {
            return 1;
          });
          sut = LogProvider(mockDbService);

          sut.add(log);
          verify(() => mockDbService.updateLog(log)).called(1);
          verifyNever(() => mockDbService.insertLog(log));
        },
      );

      test('adds log to _items', () async {
        Log blank = createBlankLog();
        mockDbService = MockDbService();
        when(() => mockDbService.getLogs()).thenAnswer((_) async => []);
        when(() => mockDbService.insertLog(blank)).thenAnswer((_) async {
          return;
        });
        when(() => mockDbService.updateLog(blank)).thenAnswer((_) async {
          return 1;
        });
        when(() => mockDbService.getLogs()).thenAnswer((invocation) async {
          return [blank];
        });
        sut = LogProvider(mockDbService);

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
          mockDbService = MockDbService();
          when(() => mockDbService.getLogs()).thenAnswer((_) async => []);
          when(() => mockDbService.insertLog(log)).thenAnswer((_) async {
            return;
          });
          when(() => mockDbService.deleteLog(log)).thenAnswer((_) async {
            return;
          });
          when(() => mockDbService.updateLog(log)).thenAnswer((_) async {
            return 1;
          });
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
          mockDbService = MockDbService();
          when(() => mockDbService.getLogs()).thenAnswer((_) async => []);
          when(() => mockDbService.insertLog(log)).thenAnswer((_) async {
            return;
          });
          when(() => mockDbService.deleteLog(log)).thenAnswer((_) async {
            return;
          });
          when(() => mockDbService.updateLog(log)).thenAnswer((_) async {
            return 1;
          });
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
