import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/src/text_editor/models/text_editor_models_barrel.dart';
import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';

part 'text_editor_controller.dart';

/// This is the main controller for the text editor
class RichTextEditorController extends _RichTextEditorController {
  ///This holds all the text changes per character and it's corresponding style/metadata
  @override
  // ignore: overridden_fields
  final TextDeltas deltas;

  static const TextMetadata defaultMetadata = TextMetadata(
    alignment: TextAlign.start,
    decoration: TextDecorationEnum.none,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontFeatures: null,
  );

  /// Constructs an instance of [RichTextEditorController] with the provided [text] and [deltas]
  ///
  /// if [text] is not provided, it will be generated from the [deltas].
  /// if [delta] is not provided, it will be generated from the [text] and [metadata].
  /// [metadata] is optional and if not provided, it will be set to [defaultMetadata]
  RichTextEditorController({
    String? text,
    TextDeltas? deltas,
    TextMetadata? metadata,
  })  : deltas = deltas ??
            (text == null
                ? []
                : TextDeltasUtils.deltasFromString(
                    text,
                    metadata ?? defaultMetadata,
                  )),
        super(
          text: text ?? deltas?.text,
          metaData: metadata,
        ) {
    addListener(_internalControllerListener);
  }

  @override
  RichTextEditorController copy() {
    return RichTextEditorController(
      text: text,
      deltas: deltas.copy,
    )
      ..value = value
      ..metadata = metadata;
  }

  /// Data serializer method for this class
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'deltas': deltas.map((TextDelta delta) => delta.toMap()).toList(),
      'metadata': metadata?.toMap(),
      'value': value.toJSON(),
    };
  }

  /// Data deserializer method for this class
  ///
  /// This is used to create a new instance of this class from a map
  factory RichTextEditorController.fromMap(Map<String, dynamic> map) {
    return RichTextEditorController(
      text: map['text'] as String,
      deltas: TextDeltasUtils.deltasFromList(
        (map['deltas'] as List).cast<Map>(),
      ),
    )
      ..value = TextEditingValue.fromJSON(
        (map['value'] as Map).cast<String, dynamic>(),
      )
      ..metadata = map['metadata'] == null
          ? null
          : TextMetadata.fromMap(
              (map['metadata'] as Map).cast<String, dynamic>(),
            );
  }
}
