part of 'extensions.dart';

extension StringExtension on String {
  String removeAll(String pattern) {
    return replaceAll(pattern, '');
  }

  List<String> get chars => split('');
}
