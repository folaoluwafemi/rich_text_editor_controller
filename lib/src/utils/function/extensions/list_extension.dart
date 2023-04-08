part of 'extensions.dart';

extension ListExtension<E> on List<E> {
  E? get firstOrNull {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }

  E? get lastOrNull {
    try {
      return last;
    } catch (e) {
      return null;
    }
  }
}
