part of 'extensions.dart';

extension ColorExtension on Color {
  String get toSerializerString => value.toString().removeAll('#');
}
