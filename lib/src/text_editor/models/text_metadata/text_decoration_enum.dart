part of 'text_metadata.dart';

enum TextDecorationEnum {
  none(TextDecoration.none),
  underline(TextDecoration.underline),
  strikeThrough(TextDecoration.lineThrough),
  ;

  final TextDecoration value;

  const TextDecorationEnum(this.value);
}
