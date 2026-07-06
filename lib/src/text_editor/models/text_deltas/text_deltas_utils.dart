part of 'text_deltas.dart';

abstract class TextDeltasUtils {
  static TextDeltas deltasFromString(
    String string, [
    TextMetadata? metadata,
  ]) {
    final TextDeltas deltas = [];
    final List<String> chars = string.chars;

    for (final String char in chars) {
      deltas.add(TextDelta(char: char, metadata: metadata));
    }
    return deltas;
  }

  static TextDeltas deltasFromList(List<Map> list) {
    final TextDeltas deltas = [];
    for (dynamic map in list) {
      deltas.add(TextDelta.fromMap((map as Map).cast<String, dynamic>()));
    }
    return deltas;
  }

  static TextDeltas applyTextEdit({
    required String newText,
    required TextDeltas oldDeltas,
    required TextMetadata? currentMetadata,
    required bool metadataToggled,
  }) {
    if (newText.isEmpty) return [];

    final List<String> newChars = newText.chars;
    final List<String> oldChars =
        oldDeltas.map((TextDelta delta) => delta.char).toList();
    final TextDeltas newDeltas = oldDeltas.copy;

    int commonPrefixLength = 0;
    while (commonPrefixLength < newChars.length &&
        commonPrefixLength < oldChars.length &&
        newChars[commonPrefixLength] == oldChars[commonPrefixLength]) {
      commonPrefixLength++;
    }

    if (commonPrefixLength == newChars.length &&
        commonPrefixLength == oldChars.length) {
      return newDeltas;
    }

    int oldSuffixStart = oldChars.length;
    int newSuffixStart = newChars.length;
    while (oldSuffixStart > commonPrefixLength &&
        newSuffixStart > commonPrefixLength &&
        oldChars[oldSuffixStart - 1] == newChars[newSuffixStart - 1]) {
      oldSuffixStart--;
      newSuffixStart--;
    }

    final List<String> insertedChars = newChars.sublist(
      commonPrefixLength,
      newSuffixStart,
    );
    final TextMetadata insertedMetadata = _metadataForInsertedText(
      commonPrefixLength,
      oldDeltas: oldDeltas,
      currentMetadata: currentMetadata,
      metadataToggled: metadataToggled,
      replacesExistingText: oldSuffixStart > commonPrefixLength,
    );

    newDeltas.replaceRange(
      commonPrefixLength,
      oldSuffixStart,
      insertedChars.map(
        (String char) => TextDelta(
          char: char,
          metadata: insertedMetadata,
        ),
      ),
    );

    return newDeltas;
  }

  static TextDeltas applyMetadataToRange({
    required TextDeltas deltas,
    required int start,
    required int end,
    required TextMetadata newMetadata,
    required TextMetadataChange change,
  }) {
    final TextDeltas modifiedDeltas = deltas.copy;
    final int startIndex = _clampIndex(start, modifiedDeltas.length);
    final int endIndex = _clampIndex(end, modifiedDeltas.length);

    for (int i = startIndex; i < endIndex; i++) {
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

  static TextMetadata _metadataForInsertedText(
    int index, {
    required TextDeltas oldDeltas,
    required TextMetadata? currentMetadata,
    required bool metadataToggled,
    required bool replacesExistingText,
  }) {
    if (metadataToggled) {
      return currentMetadata ??
          oldDeltas.elementAtOrNull(index - 1)?.metadata ??
          const TextMetadata();
    }

    if (replacesExistingText) {
      return oldDeltas.elementAtOrNull(index)?.metadata ??
          oldDeltas.elementAtOrNull(index - 1)?.metadata ??
          currentMetadata ??
          const TextMetadata();
    }

    return oldDeltas.elementAtOrNull(index - 1)?.metadata ??
        currentMetadata ??
        const TextMetadata();
  }

  static int _clampIndex(int index, int length) {
    if (index < 0) return 0;
    if (index > length) return length;
    return index;
  }
}
