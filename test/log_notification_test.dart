import 'package:flutter_test/flutter_test.dart';
import 'package:log_it/src/notification_service/notification.dart';

void main() {
  late LogNotification sut;

  group(
    'constructor',
    () {
      test(
        'default',
        () {
          final date = DateTime(2024);
          const logID = 1;
          sut = LogNotification(logID: logID, date: date);
          expect(sut.id, -1);
          expect(sut.logID, logID);
          expect(sut.date, date);
        },
      );

      test(
        'default 2',
        () {
          final date = DateTime(2022);
          const logID = 2;
          sut = LogNotification(logID: logID, date: date);
          expect(sut.id, -1);
          expect(sut.logID, logID);
          expect(sut.date, date);
        },
      );
    },
  );

  group('constructor fromMAP', () {
    test(
      'default',
      () {
        const id = 1;
        final date = DateTime(2024);
        const logID = 1;
        final map = {
          'id': id,
          'log_id': logID,
          'date': date.millisecondsSinceEpoch,
        };
        sut = LogNotification.fromMap(map);
        expect(sut.id, id);
        expect(sut.logID, logID);
        expect(sut.date, date);
      },
    );

    test(
      'default 2',
      () {
        const id = 2;
        final date = DateTime(2022);
        const logID = 2;
        final map = {
          'id': id,
          'log_id': logID,
          'date': date.millisecondsSinceEpoch,
        };
        sut = LogNotification.fromMap(map);
        expect(sut.id, id);
        expect(sut.logID, logID);
        expect(sut.date, date);
      },
    );
  });

  group(
    'toMap()',
    () {
      test(
        'default',
        () {
          const logID = 1;
          final date = DateTime(2024);
          sut = LogNotification(logID: logID, date: date);
          final map = {
            'id': null,
            'log_id': logID,
            'date': date.millisecondsSinceEpoch,
          };
          expect(sut.toMap(), map);
        },
      );

      test(
        'default 2',
        () {
          const logID = 2;
          final date = DateTime(2022);
          sut = LogNotification(logID: logID, date: date);
          final map = {
            'id': null,
            'log_id': logID,
            'date': date.millisecondsSinceEpoch,
          };
          expect(sut.toMap(), map);
        },
      );
      test(
        'default 2',
        () {
          const id = 2;
          final date = DateTime(2022);
          const logID = 2;
          final map = {
            'id': id,
            'log_id': logID,
            'date': date.millisecondsSinceEpoch,
          };
          sut = LogNotification.fromMap(map);
          expect(sut.toMap(), map);
        },
      );
    },
  );
}
