part of 'extensions.dart';

extension StringExtension on String {
  String toFirstUpperCase() {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();
    final List<String> charsList = chars;

    final String first = charsList.first;
    final String remainingChars = charsList.join().replaceFirst(first, '');

    return '${first.toUpperCase()}$remainingChars';
  }

  String removeLast() {
    if (length == 1) return '';
    return replaceRange(length - 1, length, '');
  }

  String removeFirst() {
    if (length == 1) return '';
    return replaceRange(0, (length - (length - 1)), '');
  }

  String? elementAtOrNull(int index) {
    try {
      return elementAt(index);
    } catch (e) {
      return null;
    }
  }

  String get removeAllSpaces => replaceAll(' ', '');

  bool get canParseToInt => int.tryParse(this) != null;

  String elementAt(int index) => this[index];

  String get cleanLower => trim().toLowerCase();

  String get cleanUpper => trim().toUpperCase();

  String removeAll(String pattern) {
    return replaceAll(pattern, '');
  }

  List<String> get words => split(' ');

  String toEachFirstUpperCase() {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();
    final List<String> upperWords = words.map((e) {
      return e.toFirstUpperCase();
    }).toList();
    return upperWords.join(' ');
  }

  List<String> get chars => split('');

  String withCountAndLimitParam(
    dynamic param, {
    int limit = 25,
    String limitKey = 'limit',
  }) {
    final String queryParam = 'page=$param&$limitKey=$limit';
    if (contains('?')) return '$this&$queryParam';
    return '$this?$queryParam';
  }

  String withExcludeParam(String param) {
    final String queryParam = 'exclude=$param';
    if (contains('?')) return '$this&$queryParam';
    return '$this?$queryParam';
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  bool get isNotNullOrEmpty => this?.isNotEmpty ?? false;

  String? get nullIfEmpty => isNullOrEmpty ? null : this;

  String get emptyIfNull => this == null ? '' : this!;

  String? get cleanL => this?.trim().toLowerCase();
}
