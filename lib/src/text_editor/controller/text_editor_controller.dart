import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/src/text_editor/models/text_editor_models_barrel.dart';
import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';

class RichTextEditorController extends _RichTextEditorController {
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

  RichTextEditorController({
    super.text,
    TextDeltas? deltas,
  }) : deltas = deltas ??
            (text == null ? [] : TextDeltasUtils.deltasFromString(text)) {
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

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'deltas': deltas.map((TextDelta delta) => delta.toMap()).toList(),
      'metadata': metadata?.toMap(),
      'value': value.toJSON(),
    };
  }

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

class _RichTextEditorController extends TextEditingController {
  final TextDeltas deltas;
  TextMetadata? _metadata;

  TextMetadata? get metadata => _metadata;

  bool _metadataToggled = false;

  bool get metadataToggled {
    if (_metadataToggled) {
      final bool value = _metadataToggled;
      _metadataToggled = false;
      return value;
    }
    return _metadataToggled;
  }

  set metadataToggled(bool value) {
    _metadataToggled = value;
  }

  set metadata(TextMetadata? value) {
    _metadata = value;
    notifyListeners();
  }

  _RichTextEditorController copy() {
    return _RichTextEditorController(
      text: text,
      deltas: deltas.copy,
    )
      ..value = value
      ..metadata = metadata;
  }

  _RichTextEditorController copyWith({
    TextDeltas? deltas,
    TextEditingValue? value,
    TextMetadata? metadata,
  }) {
    return _RichTextEditorController(
      text: text,
      deltas: deltas?.copy ?? this.deltas.copy,
    )
      ..value = value ?? this.value
      ..metadata = metadata ?? this.metadata;
  }

  _RichTextEditorController({
    super.text,
    TextDeltas? deltas,
  }) : deltas = deltas ??
            (text == null ? [] : TextDeltasUtils.deltasFromString(text)) {
    addListener(_internalControllerListener);
  }

  static const TextMetadata defaultMetadata = TextMetadata(
    alignment: TextAlign.start,
    decoration: TextDecorationEnum.none,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontFeatures: null,
  );

  void _internalControllerListener() {
    final TextDeltas newDeltas = compareNewAndOldTextDeltasForChanges(
      TextDeltasUtils.deltasFromString(text),
      deltas.copy,
    );
    setDeltas(newDeltas);
  }

  void setDeltas(TextDeltas newDeltas) {
    deltas.clear();
    deltas.addAll(newDeltas);
    resetMetadataOnSelectionCollapsed();
  }

  void resetMetadataOnSelectionCollapsed() {
    if (!selection.isCollapsed) return;
    if (selection.end == text.length || textBeforeSelection().isNullOrEmpty) {
      return;
    }
    if (_metadataToggled) return;

    final TextMetadata newMetadata = (deltas.isNotEmpty
            ? deltas[text.indexOf(selection.textBefore(text).chars.last)]
                .metadata
            : metadata) ??
        metadata ??
        defaultMetadata;

    _metadata = _metadata?.combineWith(
          newMetadata,
          favourOther: true,
        ) ??
        newMetadata;
  }

  String? textBeforeSelection() {
    try {
      return selection.textBefore(text);
    } catch (e) {
      return null;
    }
  }

  TextDeltas compareNewAndOldTextDeltasForChanges(
    TextDeltas newDeltas,
    TextDeltas oldDeltas,
  ) {
    final TextDeltas modifiedDelta = oldDeltas.copy;

    final List<String> oldChars = oldDeltas.text.characters.toList();
    final List<String> newChars = newDeltas.text.characters.toList();

    final int minLength = min(oldChars.length, newChars.length);
    final bool? newIsMoreThanOld = newDeltas.length == oldDeltas.length
        ? null
        : newDeltas.length > oldDeltas.length;

    for (int i = 0; i < minLength; i++) {
      if (oldChars[i] != newChars[i]) {
        final TextDelta deltaForMetadata = newIsMoreThanOld == null
            ? oldDeltas[i]
            : newIsMoreThanOld
                ? (i <= 1 ? oldDeltas.first : oldDeltas[i - 1])
                : (i > (oldDeltas.length - 2)
                    ? oldDeltas.last
                    : oldDeltas[i + 1]);

        modifiedDelta[i] = modifiedDelta[i].copyWith(
          char: newChars[i],
          metadata: metadataToggled
              ? metadata
              : deltaForMetadata.metadata ?? metadata ?? defaultMetadata,
        );
      }
    }

    if (oldChars.length > newChars.length) {
      modifiedDelta.removeRange(minLength, oldChars.length);
    } else if (oldChars.length < newChars.length) {
      for (int i = minLength; i < newChars.length; i++) {
        final TextDelta? deltaForMetadata =
            i == minLength ? oldDeltas.lastOrNull : newDeltas[i - 1];

        modifiedDelta.add(
          TextDelta(
            char: newChars[i],
            metadata: metadataToggled
                ? metadata
                : deltaForMetadata?.metadata ?? metadata ?? defaultMetadata,
          ),
        );
      }
    }
    return modifiedDelta;
  }

  void applyDefaultMetadataChange(TextMetadata changedMetadata) {
    // metadata = changedMetadata.combineWith(metadata ?? defaultMetadata);
    metadata = changedMetadata;
  }

  void changeStyleOnSelectionChange({
    TextMetadata? changedMetadata,
    required TextMetadataChange change,
    required TextDeltas modifiedDeltas,
    required TextSelection selection,
  }) {
    if (!selection.isValid) return;
    changedMetadata ??=
        deltas[text.indexOf(selection.textBefore(text).chars.last)].metadata ??
            metadata ??
            defaultMetadata;

    _metadata = _metadata?.combineWhatChanged(
          change,
          changedMetadata,
        ) ??
        changedMetadata;

    metadataToggled = true;

    if (selection.isCollapsed) return notifyListeners();

    setDeltas(
      applyMetadataToTextInSelection(
        newMetadata: changedMetadata,
        change: change,
        deltas: modifiedDeltas,
        selection: selection,
      ),
    );
    notifyListeners();
  }

  TextDeltas applyMetadataToTextInSelection({
    required TextMetadata newMetadata,
    required TextDeltas deltas,
    required TextMetadataChange change,
    required TextSelection selection,
  }) {
    final TextDeltas modifiedDeltas = deltas.copy;

    final int start = selection.start;
    final int end = selection.end;

    for (int i = start; i < end; i++) {
      modifiedDeltas[i] = modifiedDeltas[i].copyWith(
        metadata: modifiedDeltas[i].metadata?.combineWhatChanged(
                  change,
                  newMetadata,
                ) ??
            newMetadata,
      );
    }
    return modifiedDeltas;
  }

  void toggleBold() {
    final TextMetadata tempMetadata = metadata ?? defaultMetadata;
    final TextMetadata changedMetadata = tempMetadata.copyWith(
      fontWeight: tempMetadata.fontWeight == FontWeight.normal
          ? FontWeight.w700
          : FontWeight.normal,
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontWeight,
      modifiedDeltas: deltas.copy,
      selection: selection.copyWith(),
    );
  }

  void toggleItalic() {
    final TextMetadata tempMetadata = metadata ?? defaultMetadata;

    final TextMetadata changedMetadata = tempMetadata.copyWith(
      fontStyle: tempMetadata.fontStyle == FontStyle.italic
          ? FontStyle.normal
          : FontStyle.italic,
    );
    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontStyle,
      modifiedDeltas: deltas,
      selection: selection,
    );
  }

  void toggleUnderline() {
    final TextMetadata tempMetadata = metadata ?? defaultMetadata;

    final TextMetadata changedMetadata = tempMetadata.copyWith(
      decoration: tempMetadata.decoration == TextDecorationEnum.underline
          ? TextDecorationEnum.none
          : TextDecorationEnum.underline,
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontDecoration,
      modifiedDeltas: deltas,
      selection: selection,
    );
  }

  void toggleSuperscript() {
    final TextMetadata tempMetadata = metadata ?? defaultMetadata;

    final TextMetadata changedMetadata = tempMetadata.copyWith(
      fontFeatures: tempMetadata.fontFeatures?.firstOrNull ==
              const FontFeature.superscripts()
          ? const []
          : const [FontFeature.superscripts()],
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontFeatures,
      modifiedDeltas: deltas,
      selection: selection,
    );
  }

  void toggleSubscript() {
    final TextMetadata tempMetadata = metadata ?? defaultMetadata;

    final TextMetadata changedMetadata = tempMetadata.copyWith(
      fontFeatures: tempMetadata.fontFeatures?.firstOrNull ==
              const FontFeature.subscripts()
          ? const []
          : const [FontFeature.subscripts()],
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontFeatures,
      modifiedDeltas: deltas,
      selection: selection,
    );
  }

  void changeColor(Color color) {
    final TextMetadata changedMetadata = (metadata ?? defaultMetadata).copyWith(
      color: color,
    );
    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontStyle,
      modifiedDeltas: deltas,
      selection: selection,
    );
  }

  void changeAlignment(TextAlign alignment) {
    applyDefaultMetadataChange(
      (metadata ?? defaultMetadata).copyWith(alignment: alignment),
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> spanChildren = [];

    for (final TextDelta delta in deltas) {
      spanChildren.add(
        TextSpan(
          text: delta.char,
          style: delta.metadata?.style ?? defaultMetadata.style,
        ),
      );
    }

    final TextSpan textSpan = TextSpan(
      style: metadata?.styleWithoutFontFeatures ?? style,
      children: spanChildren,
    );
    return textSpan;
  }

  @override
  void dispose() {
    removeListener(_internalControllerListener);
    super.dispose();
  }
}
