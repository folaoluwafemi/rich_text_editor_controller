import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';

abstract class UtilFunctions {
  static Color colorFromMap(dynamic map) {
    return Color(int.parse(map['color'].toString()));
  }

  static Color interpolateColors(double value, List<Color> colors) {
    assert(value >= 0 || value <= 1, 'value must be between 0 and 1');

    final int colorListLength = colors.length - 1;

    final int maxExpectedIndex = (colorListLength * value).ceil();
    final int minExpectedIndex = (colorListLength * value).floor();

    final Color minColor = colors[minExpectedIndex];
    final Color maxColor = colors[maxExpectedIndex];

    return Color.lerp(minColor, maxColor, value)!;
  }

  static double extrapolateColors(Color value, List<Color> colors) {
    int difference = 100000000;
    int colorIndex = 0;

    for (final Color color in colors) {
      final int temp = (color.value - value.value).abs();
      if (temp < difference) {
        difference = temp;
        colorIndex = colors.indexOf(color);
      }
    }

    return colorIndex / (colors.length - 1);
  }

  static DateTime? dateTimeFromMap(
    dynamic data, {
    bool mustReturnData = false,
    DateTime? fallBack,
  }) {
    final DateTime fallbackDateTime =
        fallBack ?? DateTime.now().copySubtract(hour: 1).toLocal();

    if (data == null || data is! String) {
      return mustReturnData ? fallbackDateTime : null;
    }
    return (DateTime.tryParse(data) ?? fallbackDateTime).toLocal();
  }

  static String formatDate(
    DateTime date, {
    String separator = ' / ',
  }) {
    return '${date.day.toString().padLeft(2, '0')}$separator${date.month.toString().padLeft(2, '0')}$separator${date.year}';
  }

  static String formatMinutesDuration(Duration duration) {
    final int inSeconds = duration.inSeconds;
    final int seconds = inSeconds % 60;
    final int minutes = inSeconds ~/ 60;

    return '${'$minutes'.padLeft(2, '0')}:${'$seconds'.padLeft(2, '0')}';
  }

  static String? phoneNumberBodyFrom(String phoneNumber) {
    phoneNumber = phoneNumber.removeAllSpaces;
    String phoneNumberBody = phoneNumber.length > 10
        ? phoneNumber.substring((phoneNumber.length - 10), phoneNumber.length)
        : '';
    if (phoneNumberBody.trim().isEmpty) return null;

    final List<String> chars = phoneNumberBody.chars
      ..insert(3, ' ')
      ..insert(8, ' ');
    phoneNumberBody = chars.join();

    return phoneNumberBody.trim().nullIfEmpty;
  }

  static ThemeMode themeModeFromName(String name) {
    name = name.trim();
    assert(
      ThemeMode.values.containsWhere((value) => value.name != name),
      'name: $name is not a ThemeMode',
    );
    return ThemeMode.values.firstWhere((element) => element.name == name);
  }

  static bool listEqual(List list1, List list2) {
    if (list1.length != list2.length) return false;
    final int listLength = list1.length;
    for (int i = 0; i < listLength; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
