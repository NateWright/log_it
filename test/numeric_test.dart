import 'package:flutter_test/flutter_test.dart';
import 'package:log_it/src/log_feature/numeric.dart';

void main() {
  late Numeric sut;
  group('constructor', () {
    test('default', () {
      final date = DateTime(2024);
      const data = 24.0;
      sut = Numeric(date: date, data: data);

      expect(sut.date, date);
      expect(sut.data, data);
    });

    test('default 2', () {
      final date = DateTime(2022);
      const data = 13.0;
      sut = Numeric(date: date, data: data);

      expect(sut.date, date);
      expect(sut.data, data);
    });
  });

  group('constructor fromMap', () {
    test('test 1', () {
      final date = DateTime(2024);
      const data = 24.0;
      final map = {
        'date': date.toString(),
        'data': data,
      };
      sut = Numeric.fromMap(map);

      expect(sut.date, date);
      expect(sut.data, data);
    });

    test('test 2', () {
      final date = DateTime(2022);
      const data = 13.0;
      final map = {
        'date': date.toString(),
        'data': data,
      };
      sut = Numeric.fromMap(map);

      expect(sut.date, date);
      expect(sut.data, data);
    });
  });

  group('toMap', () {
    test('test 1', () {
      final date = DateTime(2024);
      const data = 24.0;
      final map = {
        'date': date.toString(),
        'data': data,
      };
      sut = Numeric.fromMap(map);

      expect(sut.toMap(), map);
    });

    test('test 2', () {
      final date = DateTime(2022);
      const data = 13.0;
      final map = {
        'date': date.toString(),
        'data': data,
      };
      sut = Numeric.fromMap(map);

      expect(sut.toMap(), map);
    });
  });
}
