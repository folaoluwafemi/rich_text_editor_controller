part of 'extensions.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get screenHeight => mediaQuery.size.height;

  double get screenWidth => mediaQuery.size.width;
}
