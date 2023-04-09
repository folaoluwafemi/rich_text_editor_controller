import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/src/utils/function/extensions/extensions.dart';

void main() {
  group('StringExtension', () {
    group('removeAll', () {
      test(
        'returns new string with input character removed',
        () async {
          const String name = 'Th00is i0s an0 e00xamp0l0e';

          expect(name.removeAll('0'), 'This is an example');
        },
      );
    });

    group('chars', () {
      test(
        'returns a new list of characters in the string',
        () async {
          const String name = 'jamiu';

          expect(name.chars, ['j', 'a', 'm', 'i', 'u']);
        },
      );
    });
  });
}
