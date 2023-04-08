part of 'extensions.dart';

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
}
