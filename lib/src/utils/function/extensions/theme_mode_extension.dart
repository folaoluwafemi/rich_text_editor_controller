part of 'extensions.dart';

extension ThemeModeExtension on ThemeMode {
  String get text {
    switch (this) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light theme';
      case ThemeMode.dark:
        return 'Dark theme';
    }
  }
}
