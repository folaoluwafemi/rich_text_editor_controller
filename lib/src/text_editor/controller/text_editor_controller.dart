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
    TextDeltas newDeltas = TextDeltasUtils.applyTextEdit(
      newText: text,
      oldDeltas: deltas.copy,
      currentMetadata: metadata,
      metadataToggled: metadataToggled,
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

  void _applyStyleChange({
    required TextMetadataChange change,
    required TextMetadata Function(TextMetadata metadata) update,
  }) {
    final TextMetadata changedMetadata = update(
      metadata ?? RichTextEditorController.defaultMetadata,
    );

    changeStyleOnSelectionChange(
      changedMetadata: changedMetadata,
      change: change,
      modifiedDeltas: deltas.copy,
      selection: selection,
    );
  }

  /// Applies the [newMetadata] to the [deltas] in the [selection] by the [change].
  ///
  /// use [TextMetadataChange.all] to apply change to more than one metadata field change.
  TextDeltas applyMetadataToTextInSelection({
    required TextMetadata newMetadata,
    required TextDeltas deltas,
    required TextMetadataChange change,
    required TextSelection selection,
  }) =>
      TextDeltasUtils.applyMetadataToRange(
        deltas: deltas,
        start: _deltaIndexForTextOffset(selection.start),
        end: _deltaIndexForTextOffset(selection.end),
        newMetadata: newMetadata,
        change: change,
      );

  /// Toggles the [TextMetadata.fontWeight] between [FontWeight.normal] and [FontWeight.w700].
  void toggleBold() {
    _applyStyleChange(
      change: TextMetadataChange.fontWeight,
      update: (TextMetadata metadata) => metadata.copyWith(
        fontWeight: metadata.fontWeight == FontWeight.normal
            ? FontWeight.w700
            : FontWeight.normal,
      ),
    );
  }

  /// Toggles the [TextMetadata.fontStyle] between [FontStyle.normal] and [FontStyle.italic].
  void toggleItalic() {
    _applyStyleChange(
      change: TextMetadataChange.fontStyle,
      update: (TextMetadata metadata) => metadata.copyWith(
        fontStyle: metadata.fontStyle == FontStyle.italic
            ? FontStyle.normal
            : FontStyle.italic,
      ),
    );
  }

  /// Toggles the [TextMetadata.decoration] between [TextDecorationEnum.none] and [TextDecorationEnum.underline].
  void toggleUnderline() {
    _applyStyleChange(
      change: TextMetadataChange.fontDecoration,
      update: (TextMetadata metadata) => metadata.copyWith(
        decoration: metadata.decoration == TextDecorationEnum.underline
            ? TextDecorationEnum.none
            : TextDecorationEnum.underline,
      ),
    );
  }

  /// Toggles the [TextMetadata.decoration] between [TextDecorationEnum.none] and [TextDecorationEnum.lineThrough].
  void toggleSuperscript() {
    _applyStyleChange(
      change: TextMetadataChange.fontFeatures,
      update: (TextMetadata metadata) => metadata.copyWith(
        fontFeatures: metadata.fontFeatures?.firstOrNull ==
                const FontFeature.superscripts()
            ? const []
            : const [FontFeature.superscripts()],
      ),
    );
  }

  /// Toggles the [TextMetadata.fontFeatures] between empty list and [FontFeature.subscripts()].
  void toggleSubscript() {
    _applyStyleChange(
      change: TextMetadataChange.fontFeatures,
      update: (TextMetadata metadata) => metadata.copyWith(
        fontFeatures:
            metadata.fontFeatures?.firstOrNull == const FontFeature.subscripts()
                ? const []
                : const [FontFeature.subscripts()],
      ),
    );
  }

  void changeColor(Color color) {
    _applyStyleChange(
      change: TextMetadataChange.color,
      update: (TextMetadata metadata) => metadata.copyWith(color: color),
    );
  }

  void changeFontSize(double fontSize) {
    _applyStyleChange(
      change: TextMetadataChange.fontSize,
      update: (TextMetadata metadata) => metadata.copyWith(fontSize: fontSize),
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
  }) =>
      RichTextSpanBuilder.build(
        deltas: deltas,
        metadata: metadata,
        style: style,
      );

  @override
  void dispose() {
    removeListener(_internalControllerListener);
    super.dispose();
  }
}
