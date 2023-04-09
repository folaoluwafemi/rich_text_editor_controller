import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rich_text_editor_controller/src/utils/function/extensions/extensions.dart';

void main() {
  group('ColorExtension', () {
    group('toSerializerString', () {
      test(
        'returns Serialized String value of color',
        () async {
          expect(const Color(0xFF000000).toSerializerString, '4278190080');
        },
      );
    });
  });
}
