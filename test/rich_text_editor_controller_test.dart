import 'package:flutter/material.dart';
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

      test(
        'toggleBold applies fontWeight to selected text',
        () {
          final controller = RichTextEditorController(text: 'he');
          controller.selection =
              const TextSelection(baseOffset: 0, extentOffset: 2);

          controller.toggleBold();

          expect(
            controller.deltas.map((delta) => delta.metadata?.fontWeight),
            everyElement(FontWeight.w700),
          );
          expect(
            controller.deltas.map((delta) => delta.metadata?.fontStyle),
            everyElement(FontStyle.normal),
          );
        },
      );

      test(
        'toggleItalic applies fontStyle to selected text',
        () {
          final controller = RichTextEditorController(text: 'he');
          controller.selection =
              const TextSelection(baseOffset: 0, extentOffset: 2);

          controller.toggleItalic();

          expect(
            controller.deltas.map((delta) => delta.metadata?.fontStyle),
            everyElement(FontStyle.italic),
          );
          expect(
            controller.deltas.map((delta) => delta.metadata?.color),
            everyElement(Colors.black),
          );
        },
      );

      test(
        'changeColor applies color to selected text',
        () {
          final controller = RichTextEditorController(text: 'he');
          controller.selection =
              const TextSelection(baseOffset: 0, extentOffset: 2);

          controller.changeColor(Colors.red);

          expect(
            controller.deltas.map((delta) => delta.metadata?.color),
            everyElement(Colors.red),
          );
          expect(
            controller.deltas.map((delta) => delta.metadata?.fontStyle),
            everyElement(FontStyle.normal),
          );
        },
      );

      test(
        'changeFontSize applies fontSize to selected text',
        () {
          final controller = RichTextEditorController(text: 'he');
          controller.selection =
              const TextSelection(baseOffset: 0, extentOffset: 2);

          controller.changeFontSize(18);

          expect(
            controller.deltas.map((delta) => delta.metadata?.fontSize),
            everyElement(18),
          );
        },
      );

      test(
        'toggleUnderline applies decoration to selected text',
        () {
          final controller = RichTextEditorController(text: 'he');
          controller.selection =
              const TextSelection(baseOffset: 0, extentOffset: 2);

          controller.toggleUnderline();

          expect(
            controller.deltas.map((delta) => delta.metadata?.decoration),
            everyElement(TextDecorationEnum.underline),
          );
        },
      );

      test(
        'toggleSuperscript applies font feature to selected text',
        () {
          final controller = RichTextEditorController(text: 'he');
          controller.selection =
              const TextSelection(baseOffset: 0, extentOffset: 2);

          controller.toggleSuperscript();

          expect(
            controller.deltas.map((delta) => delta.metadata?.fontFeatures),
            everyElement(const [FontFeature.superscripts()]),
          );
        },
      );

      test(
        'toggleSubscript applies font feature to selected text',
        () {
          final controller = RichTextEditorController(text: 'he');
          controller.selection =
              const TextSelection(baseOffset: 0, extentOffset: 2);

          controller.toggleSubscript();

          expect(
            controller.deltas.map((delta) => delta.metadata?.fontFeatures),
            everyElement(const [FontFeature.subscripts()]),
          );
        },
      );

      test(
        'collapsed selection metadata uses caret position for repeated text',
        () {
          final redMetadata = RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.red,
          );
          final blueMetadata =
              RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.blue,
          );
          final controller = RichTextEditorController(
            deltas: [
              TextDelta(char: 'a', metadata: redMetadata),
              TextDelta(char: 'a', metadata: blueMetadata),
              TextDelta(char: 'a', metadata: redMetadata),
            ],
          );

          controller.selection = const TextSelection.collapsed(offset: 2);
          controller.setDeltas(controller.deltas.copy);

          expect(controller.metadata?.color, Colors.blue);
        },
      );

      test(
        'metadata equality compares font feature contents',
        () {
          final metadata1 = RichTextEditorController.defaultMetadata.copyWith(
            fontFeatures: const [FontFeature.superscripts()],
          );
          final metadata2 = RichTextEditorController.defaultMetadata.copyWith(
            fontFeatures: const [FontFeature.superscripts()],
          );

          expect(metadata1, metadata2);
          expect(metadata1.hashCode, metadata2.hashCode);
        },
      );

      test(
        'metadata serialization uses stable names and reads legacy indexes',
        () {
          final metadata = RichTextEditorController.defaultMetadata.copyWith(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            alignment: TextAlign.center,
            decoration: TextDecorationEnum.strikeThrough,
          );

          expect(
            metadata.toMap(),
            containsPair('fontWeight', 'w700'),
          );
          expect(
            metadata.toMap(),
            containsPair('fontStyle', 'italic'),
          );
          expect(
            metadata.toMap(),
            containsPair('alignment', 'center'),
          );
          expect(
            metadata.toMap(),
            containsPair('decoration', 'strikeThrough'),
          );

          final legacyMap = metadata.toMap()
            ..['fontWeight'] = FontWeight.w700.value ~/ 100 - 1
            ..['fontStyle'] = FontStyle.italic.index
            ..['alignment'] = TextAlign.center.index
            ..['decoration'] = TextDecorationEnum.strikeThrough.index;

          expect(TextMetadata.fromMap(legacyMap), metadata);
        },
      );
    },
  );
}
