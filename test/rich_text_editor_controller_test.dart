import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

void main() {
  final List<TextDelta> someDeltas = [
    const TextDelta(
      char: 'h',
      metadata: RichTextEditorController.defaultMetadata,
    ),
    const TextDelta(
      char: 'e',
      metadata: RichTextEditorController.defaultMetadata,
    ),
  ];
  group(
    'rich_text_editor_controller_test',
    () {
      test('constructing an instance of rich text editor controller works fine',
          () async {
        expect(() => RichTextEditorController(), returnsNormally);
      });

      test(
        '[text] is the same as passed into constructor',
        () {
          final controller = RichTextEditorController(text: 'hello');
          expect(controller.text, equals('hello'));
        },
      );

      test(
        '[metadata] is the same as passed into constructor',
        () {
          final controller = RichTextEditorController(
            metadata: const TextMetadata(),
          );
          expect(controller.metadata, equals(const TextMetadata()));
        },
      );

      test(
        '[delta] is the same as passed into constructor',
        () {
          final controller = RichTextEditorController(deltas: someDeltas);
          expect(controller.deltas, equals(someDeltas));
        },
      );
      test(
        '[delta] is gotten from passed in [text] correctly',
        () {
          final controller = RichTextEditorController(text: 'he');
          expect(controller.deltas, equals(someDeltas));
        },
      );
    },
  );
}
