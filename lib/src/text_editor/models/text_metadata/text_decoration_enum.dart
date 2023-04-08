part of 'text_metadata.dart';

///This super enum is used to convert [TextDecoration] to [TextDecorationEnum] and vice versa.
///
/// It is being used to allow for easy data serialization. since [TextDecoration] does not expose toJson() and fromJson() methods.
enum TextDecorationEnum {
  none(TextDecoration.none),
  underline(TextDecoration.underline),
  strikeThrough(TextDecoration.lineThrough),
  ;

  final TextDecoration value;

  const TextDecorationEnum(this.value);
}
