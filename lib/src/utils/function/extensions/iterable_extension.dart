part of 'extensions.dart';

extension IterableExtension<E> on Iterable<E> {
  bool containsWhere(bool Function(E value) test) {
    for (E element in this) {
      bool satisfied = test(element);
      if (satisfied) {
        return true;
      }
    }
    return false;
  }
}
