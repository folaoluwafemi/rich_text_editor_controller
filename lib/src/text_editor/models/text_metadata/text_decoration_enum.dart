part of 'text_metadata.dart';

///This super enum is used to convert [TextDecoration] to [TextDecorationEnum] and vice versa.
///
/// It is being used to allow for easy data serialization. since [TextDecoration] does not expose toJson() and fromJson() methods.
enum TextDecorationEnum {
  none(TextDecoration.none, 'none'),
  underline(TextDecoration.underline, 'underline'),
  strikeThrough(TextDecoration.lineThrough, 'line-through'),
  ;

  final TextDecoration value;
  final String cssValue;

  const TextDecorationEnum(this.value, this.cssValue);

  factory TextDecorationEnum.fromDecoration(TextDecoration decoration) {
    return values.firstWhere((element) => element.value == decoration);
  }
}
