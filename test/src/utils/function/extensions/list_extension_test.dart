import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/src/utils/function/extensions/extensions.dart';

void main() {
  group('ListExtension', () {
    group('firstOrNull', () {
      test(
        'returns first item if list is not empty',
        () async {
          final List<int> list = [1, 2, 3, 4, 5, 6];

          expect(list.firstOrNull, 1);
        },
      );

      test(
        'returns null if list is empty',
        () async {
          final List<int> list = [];

          expect(list.firstOrNull, null);
        },
      );
    });

    group('lastOrNull', () {
      test(
        'returns first item if list is not empty',
        () async {
          final List<int> list = [1, 2, 3, 4, 5, 6];

          expect(list.lastOrNull, 6);
        },
      );

      test(
        'returns null if list is empty',
        () async {
          final List<int> list = [];

          expect(list.lastOrNull, null);
        },
      );
    });
  });
}
