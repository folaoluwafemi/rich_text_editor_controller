part of 'extensions.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get withBlack => copyWith(color: Colors.black);

  TextStyle get withWhite => copyWith(color: Colors.white);

  TextStyle get asMedium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get asSemibold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get asBold => copyWith(fontWeight: FontWeight.w700);

  TextStyle withSize(double fontSize) => copyWith(fontSize: fontSize);

  TextStyle withColor(Color color) => copyWith(color: color);

  TextStyle withHeight(double height) => copyWith(height: height);
}
