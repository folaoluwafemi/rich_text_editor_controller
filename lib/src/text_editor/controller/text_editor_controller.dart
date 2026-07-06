part of 'text_editor_controller_public.dart';

class _RichTextEditorController extends TextEditingController {
  ///This holds all the text changes per character and it's corresponding style/metadata
  final TextDeltas deltas;

  /// This holds the state of the text styles.
  /// on every selection change (collapsed or not) it's value defaults to that
  /// of the [TextDelta] before it in the [deltas] list or the [defaultMetadata] if it's the first
  TextMetadata? _metadata;

  TextMetadata? get metadata => _metadata;

  /// This is holds the state of the metadata change temporarily.
  ///
  /// it is reset when it's getter is called
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

  /// returns a copy of this controller
  ///
  /// why? because all flutter [Listenable] objects are stored in memory and passed by reference
  _RichTextEditorController copy() {
    return _RichTextEditorController(
      text: text,
      deltas: deltas.copy,
    )
      ..value = value
      ..metadata = metadata;
  }

  /// returns a copy of this controller with the given parameters
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
    TextMetadata? metaData,
  })  : _metadata = metaData ?? RichTextEditorController.defaultMetadata,
        deltas = deltas ??
            (text == null ? [] : TextDeltasUtils.deltasFromString(text)) {
    addListener(_internalControllerListener);
  }

  void _internalControllerListener() {
    if (text == deltas.text) return;
    TextDeltas newDeltas = _compareNewStringAndOldTextDeltasForChanges(
      text,
      deltas.copy,
    );

    if (isListMode && newDeltas.length != deltas.length) {
      newDeltas = modifyDeltasForBulletListChange(
        newDeltas,
        deltas.copy,
      );
    }

    setDeltas(newDeltas);
  }

  /// set the new deltas and reset [metadata] relative to the new selection/caret position
  void setDeltas(TextDeltas newDeltas) {
    deltas.clear();
    deltas.addAll(newDeltas);
    if (selection.isCollapsed) resetMetadataOnSelectionCollapsed();
  }

  /// If a selection changed and is inside the text and empty (collapsed),
  /// this function sets the current [metadata] to the metadata of the
  /// text before it's new position
  void resetMetadataOnSelectionCollapsed() {
    if (!selection.isCollapsed) return;
    if (selection.end == text.length || textBeforeSelection().isNullOrEmpty) {
      return;
    }
    if (_metadataToggled) return;

    final int? indexBeforeSelection = _deltaIndexBeforeSelection(selection);
    final TextMetadata newMetadata = (indexBeforeSelection == null
            ? metadata
            : deltas.elementAtOrNull(indexBeforeSelection)?.metadata) ??
        metadata ??
        RichTextEditorController.defaultMetadata;

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

  int? _deltaIndexBeforeSelection(TextSelection selection) {
    final String textBeforeSelection;
    try {
      textBeforeSelection = selection.textBefore(text);
    } catch (e) {
      return null;
    }

    if (textBeforeSelection.isEmpty) return null;
    return textBeforeSelection.characters.length - 1;
  }

  int _deltaIndexForTextOffset(int offset) {
    return text.substring(0, offset.clamp(0, text.length)).characters.length;
  }

  static const String bulletPoint = '•';

  List<TextDelta> modifyDeltasForBulletListChange(
    List<TextDelta> modifiedDeltas,
    List<TextDelta> oldDeltas,
  ) {
    final List<String> oldChars = oldDeltas.text.characters.toList();
    final List<String> newChars = modifiedDeltas.text.characters.toList();

    if (oldChars.length > newChars.length) return modifiedDeltas;

    if (newChars.last == '\n') {
      const String bulletValue = '\n $bulletPoint ';

      final TextDeltas bulletDeltas = List.generate(
        bulletValue.length,
        (index) => TextDelta(
          char: bulletValue[index],

          /// adding this check so that the character typed after this does not inherit the bullet point's metadata
          /// hence the restoration back to the [this] controller's [metadata]
          metadata: (index != bulletValue.length - 2)
              ? metadata
              : (metadata ?? RichTextEditorController.defaultMetadata).copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),
      );

      final TextDeltas deltas = modifiedDeltas.copy
        ..replaceRange(
          modifiedDeltas.length - 1,
          modifiedDeltas.length,
          bulletDeltas,
        );

      text = deltas.text;
      selection = TextSelection.collapsed(offset: text.length);

      return deltas;
    }

    return modifiedDeltas;
  }

  /// this compares the old strings and the new strings by the following criteria
  ///   *
  TextDeltas _compareNewStringAndOldTextDeltasForChanges(
    String text,
    TextDeltas oldDeltas,
  ) {
    if (text.isEmpty) return [];
    final List<String> newChars = text.characters.toList();
    final TextDeltas newDeltas = oldDeltas.copy;
    final int minLength = min(newChars.length, oldDeltas.length);
    final int maxLength = max(newChars.length, oldDeltas.length);

    final int indexOfChange = _compareNewAndOldForChangeIndex(
      newChars: newChars,
      oldDeltas: oldDeltas,
      minLength: minLength,
    );

    if (indexOfChange == -1) return newDeltas;

    final int lengthOfChange = maxLength - minLength;

    if (minLength == oldDeltas.length) {
      final TextMetadata newMetadata = metadataToggled
          ? (metadata ??
              oldDeltas.elementAtOrNull(indexOfChange - 1)?.metadata ??
              RichTextEditorController.defaultMetadata)
          : oldDeltas.elementAtOrNull(indexOfChange - 1)?.metadata ??
              metadata ??
              RichTextEditorController.defaultMetadata;
      final int iterationLimit = lengthOfChange + indexOfChange;
      for (int i = indexOfChange; i < iterationLimit; i++) {
        newDeltas.insert(
          i,
          TextDelta(char: newChars[i], metadata: newMetadata),
        );
      }
    } else {
      newDeltas.removeRange(indexOfChange, indexOfChange + lengthOfChange);
    }
    return newDeltas;
  }

  int _compareNewAndOldForChangeIndex({
    required List<String> newChars,
    required TextDeltas oldDeltas,
    required int minLength,
  }) {
    if (newChars.isEmpty || oldDeltas.isEmpty) return 0;
    for (int i = 0; i < minLength; i++) {
      final String newChar = newChars[i];
      final String oldChar = oldDeltas[i].char;
      if (newChar != oldChar) return i;
    }

    if (newChars.length == oldDeltas.length) return -1;

    return minLength;
  }

  void applyDefaultMetadataChange(TextMetadata changedMetadata) {
    metadata = changedMetadata;
  }

  bool get isListMode => indexOflListChar != null;

  int? indexOflListChar;

  void toggleListMode() {
    indexOflListChar = indexOflListChar == null ? (deltas.length - 1) : null;
    _metadataToggled = true;
    notifyListeners();
  }

  void changeStyleOnSelectionChange({
    TextMetadata? changedMetadata,
    required TextMetadataChange change,
    required TextDeltas modifiedDeltas,
    required TextSelection selection,
  }) {
    if (!selection.isValid) return;
    final int? indexBeforeSelection = _deltaIndexBeforeSelection(selection);
    changedMetadata ??= (indexBeforeSelection == null
            ? metadata
            : deltas.elementAtOrNull(indexBeforeSelection)?.metadata) ??
        metadata ??
        RichTextEditorController.defaultMetadata;

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

  /// Applies the [newMetadata] to the [deltas] in the [selection] by the [change].
  ///
  /// use [TextMetadataChange.all] to apply change to more than one metadata field change.
  TextDeltas applyMetadataToTextInSelection({
    required TextMetadata newMetadata,
    required TextDeltas deltas,
    required TextMetadataChange change,
    required TextSelection selection,
  }) {
    final TextDeltas modifiedDeltas = deltas.copy;

    final int start = _deltaIndexForTextOffset(selection.start);
    final int end = _deltaIndexForTextOffset(selection.end);

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

  /// Toggles the [TextMetadata.fontWeight] between [FontWeight.normal] and [FontWeight.w700].
  void toggleBold() {
    final TextMetadata tempMetadata =
        metadata ?? RichTextEditorController.defaultMetadata;
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

  /// Toggles the [TextMetadata.fontStyle] between [FontStyle.normal] and [FontStyle.italic].
  void toggleItalic() {
    final TextMetadata tempMetadata =
        metadata ?? RichTextEditorController.defaultMetadata;

    final TextMetadata changedMetadata = tempMetadata.copyWith(
      fontStyle: tempMetadata.fontStyle == FontStyle.italic
          ? FontStyle.normal
          : FontStyle.italic,
    );
    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontStyle,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Toggles the [TextMetadata.decoration] between [TextDecorationEnum.none] and [TextDecorationEnum.underline].
  void toggleUnderline() {
    final TextMetadata tempMetadata =
        metadata ?? RichTextEditorController.defaultMetadata;

    final TextMetadata changedMetadata = tempMetadata.copyWith(
      decoration: tempMetadata.decoration == TextDecorationEnum.underline
          ? TextDecorationEnum.none
          : TextDecorationEnum.underline,
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontDecoration,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Toggles the [TextMetadata.decoration] between [TextDecorationEnum.none] and [TextDecorationEnum.lineThrough].
  void toggleSuperscript() {
    final TextMetadata tempMetadata =
        metadata ?? RichTextEditorController.defaultMetadata;

    final TextMetadata changedMetadata = tempMetadata.copyWith(
      fontFeatures: tempMetadata.fontFeatures?.firstOrNull ==
              const FontFeature.superscripts()
          ? const []
          : const [FontFeature.superscripts()],
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontFeatures,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Toggles the [TextMetadata.fontFeatures] between empty list and [FontFeature.subscripts()].
  void toggleSubscript() {
    final TextMetadata tempMetadata =
        metadata ?? RichTextEditorController.defaultMetadata;

    final TextMetadata changedMetadata = tempMetadata.copyWith(
      fontFeatures: tempMetadata.fontFeatures?.firstOrNull ==
              const FontFeature.subscripts()
          ? const []
          : const [FontFeature.subscripts()],
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontFeatures,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  void changeColor(Color color) {
    final TextMetadata changedMetadata =
        (metadata ?? RichTextEditorController.defaultMetadata).copyWith(
      color: color,
    );
    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.color,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  void changeFontSize(double fontSize) {
    final TextMetadata changedMetadata =
        (metadata ?? RichTextEditorController.defaultMetadata).copyWith(
      fontSize: fontSize,
    );
    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: TextMetadataChange.fontSize,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Changes the [TextMetadata.alignment] to the given [alignment].
  ///
  /// note that you have to use [RichTextField] for changes made by this method to reflect.
  /// or otherwise set the [TextField.alignment] parameter of your textField to [TextMetadata.alignment]
  /// while listening to changes in the controller.
  /// example:
  ///...
  ///     `ValueListenableBuilder<TextEditingValue>`
  ///         valueListenable: controller,
  ///         builder: (_, controllerValue, __) => TextField(
  ///           controller: controller,
  ///           textAlign: controller.metadata?.alignment ?? TextAlign.start,
  ///         ),
  ///       ),
  /// ...
  void changeAlignment(TextAlign alignment) {
    applyDefaultMetadataChange(
      (metadata ?? RichTextEditorController.defaultMetadata)
          .copyWith(alignment: alignment),
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> spanChildren = [];
    final StringBuffer currentText = StringBuffer();
    TextMetadata? currentMetadata;

    void addCurrentSpan() {
      if (currentText.isEmpty) return;
      spanChildren.add(
        TextSpan(
          text: currentText.toString(),
          style: currentMetadata?.style ??
              RichTextEditorController.defaultMetadata.style,
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
