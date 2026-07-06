import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';
import 'package:rich_text_editor_controller/src/text_editor/models/text_deltas/text_deltas.dart'
    show TextDeltasUtils;
import 'package:rich_text_editor_controller/src/text_editor/models/text_metadata/text_metadata_enum.dart'
    show TextMetadataChange;
import 'package:rich_text_editor_controller/src/text_editor/ui/text_span_builder.dart'
    show RichTextSpanBuilder;

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
        'collapsed selection metadata uses last delta at end of text',
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
              TextDelta(char: 'b', metadata: blueMetadata),
            ],
          );

          controller.selection = const TextSelection.collapsed(offset: 2);
          controller.setDeltas(controller.deltas.copy);

          expect(controller.metadata?.color, Colors.blue);
        },
      );

      test(
        'collapsed selection metadata ignores empty text',
        () {
          final redMetadata = RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.red,
          );
          final controller = RichTextEditorController(metadata: redMetadata);

          controller.selection = const TextSelection.collapsed(offset: 0);
          controller.setDeltas(const []);

          expect(controller.metadata?.color, Colors.red);
        },
      );

      test(
        'text edits can replace graphemes without changing text length',
        () {
          final controller = RichTextEditorController(text: 'cat');

          controller.value = const TextEditingValue(
            text: 'cut',
            selection: TextSelection.collapsed(offset: 2),
          );

          expect(controller.deltas.text, 'cut');
          expect(
            controller.deltas.map((TextDelta delta) => delta.char),
            ['c', 'u', 't'],
          );
        },
      );

      test(
        'replacement text inherits metadata from replaced range',
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
              TextDelta(char: 'b', metadata: blueMetadata),
              TextDelta(char: 'c', metadata: redMetadata),
            ],
          );

          controller.value = const TextEditingValue(
            text: 'aXYc',
            selection: TextSelection.collapsed(offset: 3),
          );

          expect(controller.deltas.text, 'aXYc');
          expect(controller.deltas[1].metadata?.color, Colors.blue);
          expect(controller.deltas[2].metadata?.color, Colors.blue);
        },
      );

      test(
        'replacement diff handles grapheme clusters',
        () {
          final controller = RichTextEditorController(text: 'a😀c');

          controller.value = const TextEditingValue(
            text: 'a👩‍💻c',
            selection: TextSelection.collapsed(offset: 6),
          );

          expect(controller.deltas.text, 'a👩‍💻c');
          expect(controller.deltas.length, 3);
          expect(controller.deltas[1].char, '👩‍💻');
        },
      );

      test(
        'text delta edit utility applies replacement edits',
        () {
          final blueMetadata =
              RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.blue,
          );
          final oldDeltas = TextDeltasUtils.deltasFromString('abc')
              .map(
                (TextDelta delta) => delta.copyWith(metadata: blueMetadata),
              )
              .toList();

          final newDeltas = TextDeltasUtils.applyTextEdit(
            newText: 'aXYc',
            oldDeltas: oldDeltas,
            currentMetadata: null,
            metadataToggled: false,
          );

          expect(newDeltas.text, 'aXYc');
          expect(newDeltas[1].metadata?.color, Colors.blue);
          expect(newDeltas[2].metadata?.color, Colors.blue);
        },
      );

      test(
        'text delta utility applies metadata to clamped ranges',
        () {
          final redMetadata = RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.red,
          );
          final oldDeltas = TextDeltasUtils.deltasFromString(
            'abc',
            RichTextEditorController.defaultMetadata,
          );

          final newDeltas = TextDeltasUtils.applyMetadataToRange(
            deltas: oldDeltas,
            start: 1,
            end: 99,
            newMetadata: redMetadata,
            change: TextMetadataChange.color,
          );

          expect(newDeltas[0].metadata?.color, Colors.black);
          expect(newDeltas[1].metadata?.color, Colors.red);
          expect(newDeltas[2].metadata?.color, Colors.red);
        },
      );

      test(
        'text delta utility applies metadata to reversed ranges',
        () {
          final redMetadata = RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.red,
          );
          final oldDeltas = TextDeltasUtils.deltasFromString(
            'abc',
            RichTextEditorController.defaultMetadata,
          );

          final newDeltas = TextDeltasUtils.applyMetadataToRange(
            deltas: oldDeltas,
            start: 3,
            end: 1,
            newMetadata: redMetadata,
            change: TextMetadataChange.color,
          );

          expect(newDeltas[0].metadata?.color, Colors.black);
          expect(newDeltas[1].metadata?.color, Colors.red);
          expect(newDeltas[2].metadata?.color, Colors.red);
        },
      );

      test(
        'text delta utility resolves metadata at or before index',
        () {
          final redMetadata = RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.red,
          );
          final blueMetadata =
              RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.blue,
          );
          final deltas = [
            TextDelta(char: 'a', metadata: redMetadata),
          ];

          expect(
            TextDeltasUtils.metadataAtOrBeforeIndex(
              deltas: deltas,
              index: 0,
              currentMetadata: blueMetadata,
            ).color,
            Colors.red,
          );
          expect(
            TextDeltasUtils.metadataAtOrBeforeIndex(
              deltas: deltas,
              index: 99,
              currentMetadata: blueMetadata,
            ).color,
            Colors.blue,
          );
        },
      );

      test(
        'text delta utility maps text offsets to grapheme indexes',
        () {
          expect(
            TextDeltasUtils.graphemeIndexForTextOffset('a😀c', 3),
            2,
          );
          expect(
            TextDeltasUtils.graphemeIndexForTextOffset('a😀c', 999),
            3,
          );
          expect(
            TextDeltasUtils.graphemeIndexForTextOffset('a😀c', -1),
            0,
          );
        },
      );

      test(
        'text delta utility applies bullet list changes',
        () {
          final metadata = RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.red,
          );
          final oldDeltas = TextDeltasUtils.deltasFromString('a', metadata);
          final modifiedDeltas = TextDeltasUtils.deltasFromString(
            'a\n',
            metadata,
          );

          final newDeltas = TextDeltasUtils.applyBulletListChange(
            modifiedDeltas: modifiedDeltas,
            oldDeltas: oldDeltas,
            currentMetadata: metadata,
          );

          expect(newDeltas.text, 'a\n ${TextDeltasUtils.bulletPoint} ');
          expect(newDeltas[3].char, TextDeltasUtils.bulletPoint);
          expect(newDeltas[3].metadata?.fontWeight, FontWeight.bold);
          expect(newDeltas[4].metadata?.fontWeight, FontWeight.w400);
        },
      );

      test(
        'text span builder coalesces adjacent matching metadata',
        () {
          final redMetadata = RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.red,
          );
          final blueMetadata =
              RichTextEditorController.defaultMetadata.copyWith(
            color: Colors.blue,
          );

          final textSpan = RichTextSpanBuilder.build(
            deltas: [
              TextDelta(char: 'a', metadata: redMetadata),
              TextDelta(char: 'b', metadata: redMetadata),
              TextDelta(char: 'c', metadata: blueMetadata),
            ],
            metadata: null,
          );

          expect(textSpan.children, hasLength(2));
          expect((textSpan.children![0] as TextSpan).text, 'ab');
          expect((textSpan.children![1] as TextSpan).text, 'c');
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
