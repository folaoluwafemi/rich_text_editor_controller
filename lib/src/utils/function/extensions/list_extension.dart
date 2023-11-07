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

  E? elementAtOrNull(int index) {
    try {
      return this[index];
    } catch (e) {
      return null;
    }
  }
  void addItemBetweenList(
    int index, {
    required E item,
  }) {
    if (index > length) throw Exception('Index out of bounds');
    if (index == length) return add(item);

    final List<E> completeList = [
      ...sublist(0, index),
      item,
      ...sublist(index, length),
    ];

    clear();
    addAll(completeList);
  }
}
