import 'package:rich_text_editor_controller/src/text_editor/models/text_editor_models_barrel.dart';

class TextDelta {
  final String char;
  final TextMetadata? metadata;

  const TextDelta({
    required this.char,
    this.metadata,
  });

  TextDelta copyWith({
    String? char,
    TextMetadata? metadata,
  }) {
    return TextDelta(
      char: char ?? this.char,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'char': char,
      'metadata': metadata?.toMap(),
    };
  }

  factory TextDelta.fromMap(Map<String, dynamic> map) {
    return TextDelta(
      char: map['char'] as String,
      metadata: map['metadata'] == null
          ? null
          : TextMetadata.fromMap(
              (map['metadata'] as Map).cast<String, dynamic>(),
            ),
    );
  }

  TextDelta copyWithChar(String char) {
    return TextDelta(
      char: char,
      metadata: metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextDelta &&
          runtimeType == other.runtimeType &&
          char == other.char &&
          metadata == other.metadata;

  @override
  int get hashCode => char.hashCode ^ metadata.hashCode;
}
