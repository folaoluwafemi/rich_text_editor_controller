import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/src/utils/function/extensions/extensions.dart';

void main() {
  group('NullableStringExtension', () {
    group('isNullOrEmpty', () {
      test(
        'returns true if string is empty',
        () async {
          const String testItem = '';

          expect(testItem.isNullOrEmpty, true);
        },
      );

      test(
        'returns true if string is null',
        () async {
          String? testItem;

          expect(testItem.isNullOrEmpty, true);
        },
      );

      test(
        'returns false if string is not null or empty',
        () async {
          const testItem = "@developerjamiu";

          expect(testItem.isNullOrEmpty, false);
        },
      );
    });
  });
}
