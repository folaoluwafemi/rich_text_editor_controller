import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/src/utils/function/extensions/extensions.dart';

void main() {
  group('TextAlignExtension', () {
    group('toAlignment', () {
      test(
        'returns Alignment.centerLeft for input TextAlign.start',
        () async {
          const TextAlign textAlign = TextAlign.start;

          expect(textAlign.toAlignment, Alignment.centerLeft);
        },
      );

      test(
        'returns Alignment.centerLeft for input TextAlign.left',
        () async {
          const TextAlign textAlign = TextAlign.left;

          expect(textAlign.toAlignment, Alignment.centerLeft);
        },
      );

      test(
        'returns Alignment.centerLeft for input TextAlign.end',
        () async {
          const TextAlign textAlign = TextAlign.end;

          expect(textAlign.toAlignment, Alignment.centerRight);
        },
      );

      test(
        'returns Alignment.centerLeft for input TextAlign.right',
        () async {
          const TextAlign textAlign = TextAlign.right;

          expect(textAlign.toAlignment, Alignment.centerRight);
        },
      );

      test(
        'returns Alignment.center for input TextAlign.center',
        () async {
          const TextAlign textAlign = TextAlign.center;

          expect(textAlign.toAlignment, Alignment.center);
        },
      );

      test(
        'returns Alignment.center for input TextAlign.justify',
        () async {
          const TextAlign textAlign = TextAlign.justify;

          expect(textAlign.toAlignment, Alignment.center);
        },
      );
    });
  });
}
