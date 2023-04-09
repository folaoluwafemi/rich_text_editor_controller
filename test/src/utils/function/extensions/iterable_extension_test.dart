import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/src/utils/function/extensions/extensions.dart';

void main() {
  group('IterableExtension', () {
    final Iterable<int> items = [1, 2, 3, 4, 5, 6];

    group('containsWhere', () {
      test(
        'returns true if iterable contains test item',
        () async {
          const testItem = 1;

          final result = items.containsWhere((item) => item == testItem);

          expect(result, true);
        },
      );

      test(
        'returns false if iterable does not contain test item',
        () async {
          const testItem = 8;

          final result = items.containsWhere((item) => item == testItem);

          expect(result, false);
        },
      );
    });
  });
}
