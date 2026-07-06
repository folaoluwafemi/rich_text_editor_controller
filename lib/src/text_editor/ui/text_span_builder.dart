import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/src/text_editor/models/text_editor_models_barrel.dart';

abstract class RichTextSpanBuilder {
  static TextSpan build({
    required TextDeltas deltas,
    required TextMetadata? metadata,
    TextStyle? style,
  }) {
    final List<TextSpan> spanChildren = [];
    final StringBuffer currentText = StringBuffer();
    TextMetadata? currentMetadata;

    void addCurrentSpan() {
      if (currentText.isEmpty) return;
      spanChildren.add(
        TextSpan(
          text: currentText.toString(),
          style: currentMetadata?.style ?? const TextMetadata().style,
        ),
      );
      currentText.clear();
    }

    for (final TextDelta delta in deltas) {
      if (currentText.isNotEmpty && delta.metadata != currentMetadata) {
        addCurrentSpan();
      }
      currentMetadata = delta.metadata;
      currentText.write(delta.char);
    }
    addCurrentSpan();

    return TextSpan(
      style: metadata?.styleWithoutFontFeatures ?? style,
      children: spanChildren,
    );
  }
}
