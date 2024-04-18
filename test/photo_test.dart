import 'package:flutter_test/flutter_test.dart';
import 'package:log_it/src/log_feature/photo.dart';

void main() {
  late Photo sut;
  group('constructor', () {
    test('default', () {
      final date = DateTime(2024);
      const data = "Photo";
      sut = Photo(date: date, data: data);

      expect(sut.date, date);
      expect(sut.data, data);
    });
  });

  group('constructor fromMap', () {
    test('test', () {
      final date = DateTime(2024);
      const data = "Photo";
      final map = {
        'date': date.toString(),
        'data': data,
      };
      sut = Photo.fromMap(map);

      expect(sut.date, date);
      expect(sut.data, data);
    });
  });
}
