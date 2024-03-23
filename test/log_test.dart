import 'package:flutter_test/flutter_test.dart';
import 'package:log_it/src/log_feature/log.dart';

void main() {
  late Log sut;

  group(
    'constructor',
    () {
      test('default', () {
        sut = Log(
          title: 'Test',
          description: 'Test Description',
          dataType: DataType.number,
          unit: 'lb',
        );
      });
    },
  );
}
