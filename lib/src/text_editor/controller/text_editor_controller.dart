import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/src/text_editor/models/text_editor_models_barrel.dart';
import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';
/// A controller for a text editor that provides a way to manage the text content, metadata, and deltas.
class TextEditorController extends _TextEditorController {
  /// The current text deltas of the editor.
  ///
  /// The `deltas` parameter can be provided to initialize the deltas when the controller is created. If `deltas` is not provided, the `text` parameter is used to create the deltas if it is not `null`.
  @override
  final TextDeltas deltas;

  /// The default metadata used by the controller if no metadata is provided.
  static const TextMetadata defaultMetadata = TextMetadata(
    alignment: TextAlign.start,
    decoration: TextDecorationEnum.none,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontFeatures: null,
  );

  /// Creates a new [TextEditorController] instance.
  ///
  /// The `text` parameter can be provided to initialize the controller with text. The `deltas` parameter can be provided to initialize the deltas when the controller is created. If `deltas` is not provided, the `text` parameter is used to create the deltas if it is not `null`.
  TextEditorController({
    String? text,
    TextDeltas? deltas,
  }) : deltas = deltas ?? (text == null ? [] : TextDeltasUtils.deltasFromString(text)) {
    addListener(_internalControllerListener);
  }

  /// Creates a copy of this controller with the same text, deltas, value, and metadata.
  @override
  TextEditorController copy() {
    return TextEditorController(
      text: text,
      deltas: deltas.copy,
    )
      ..value = value
      ..metadata = metadata;
  }

  /// Converts this controller to a map.
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'deltas': deltas.map((TextDelta delta) => delta.toMap()).toList(),
      'metadata': metadata?.toMap(),
      'value': value.toJSON(),
    };
  }

  /// Creates a new [TextEditorController] instance from a map.
  factory TextEditorController.fromMap(Map<String, dynamic> map) {
    return TextEditorController(
      text: map['text'] as String?,
      deltas: TextDeltasUtils.deltasFromList((map['deltas'] as List).cast<Map>()),
    )
      ..value = TextEditingValue.fromJSON((map['value'] as Map<String, dynamic>).cast<String, dynamic>())
      ..metadata = map['metadata'] == null ? null : TextMetadata.fromMap((map['metadata'] as Map<String, dynamic>).cast<String, dynamic>());
  }
}

/// A controller for a text editor that provides a way to manage the text content, metadata, and deltas.
///
/// This is the base class that is extended by [TextEditorController].
class _TextEditorController extends TextEditingController {
  /// The current text deltas of the editor.
  final TextDeltas deltas;

  /// The metadata for the current selection in the editor.
  TextMetadata? _metadata;

  /// Returns the metadata for the current selection in the editor.
  TextMetadata? get metadata => _metadata;

  /// Returns whether the metadata toggle has been enabled.
  ///
  /// If the metadata toggle has been enabled, it is disabled and `true` is returned. Otherwise, `false` is returned.
  bool _metadataToggled = false;

  /// Returns whether the metadata toggle has been enabled.
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

  _TextEditorController copy() {
    return _TextEditorController(
      text: text,
      deltas: deltas.copy,
    )
      ..value = value
      ..metadata = metadata;
  }

  _TextEditorController copyWith({
    TextDeltas? deltas,
    TextEditingValue? value,
    TextMetadata? metadata,
  }) {
    return _TextEditorController(
      text: text,
      deltas: deltas?.copy ?? this.deltas.copy,
    )
      ..value = value ?? this.value
      ..metadata = metadata ?? this.metadata;
  }

  _TextEditorController({
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
