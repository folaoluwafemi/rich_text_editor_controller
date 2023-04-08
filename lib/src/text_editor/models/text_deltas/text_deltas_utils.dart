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
}
