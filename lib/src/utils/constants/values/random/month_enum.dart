import 'package:rich_text_editor_controller/src/utils/utils_barrel.dart';

enum Month {
  january('Jan', 'january', 31),
  february('Feb', 'february', 29),
  march('Mar', 'march', 31),
  april('Apr', 'april', 30),
  may('May', 'may', 31),
  june('Jun', 'june', 30),
  july('Jul', 'july', 31),
  august('Aug', 'august', 31),
  september('Sep', 'september', 30),
  october('Oct', 'october', 31),
  november('Nov', 'november', 30),
  december('Dec', 'december', 31);

  final String short;
  final String _full;
  final int maxDays;

  const Month(this.short, this._full, this.maxDays);

  String get full => _full.toFirstUpperCase();

  int get intValue => index + 1;

  static List<int> get monthValues => Month.values
      .map<int>(
        (e) => e.intValue,
      )
      .toList();
}
