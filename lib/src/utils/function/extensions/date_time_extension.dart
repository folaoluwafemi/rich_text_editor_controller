part of 'extensions.dart';

extension DateTimeExtension on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
      );

  DateTime copyAdd({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) =>
      DateTime(
        (year ?? 0) + this.year,
        (month ?? 0) + this.month,
        (day ?? 0) + this.day,
        (hour ?? 0) + this.hour,
        (minute ?? 0) + this.minute,
        (second ?? 0) + this.second,
      );

  DateTime copySubtract({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) =>
      DateTime(
        this.year - (year ?? 0),
        this.month - (month ?? 0),
        this.day - (day ?? 0),
        this.hour - (hour ?? 0),
        this.minute - (minute ?? 0),
        this.second - (second ?? 0),
      );

  String dateText({String separator = '/'}) {
    return toString()
        .split(' ')
        .first
        .trim()
        .split('-')
        .reversed
        .join(separator)
        .trim();
  }
}
