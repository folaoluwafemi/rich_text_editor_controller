part of 'extensions.dart';

typedef TransformerCallback<E> = E Function(E element);
typedef ElementTestCallback<E> = bool Function(E element);

extension ListExtension<E> on List<E> {
  int get lastIndex => length - 1;

  bool isFirst(E element) => indexOf(element) == 0;

  bool isLast(E element) => indexOf(element) == (length - 1);

  void pushFront(E element) {
    return insert(0, element);
  }

  List<E> operator +(List<E> other) {
    final List<E> tempList = [];
    tempList.addAll(this);
    tempList.addAll(other);
    return tempList;
  }

  bool isEachEqual(List<E> other) {
    if (length != other.length) return false;
    if (isEmpty && other.isEmpty) return true;
    if (isEmpty ^ other.isEmpty) return false;
    bool isEqual = false;
    for (int i = 0; i < length; i++) {
      isEqual = [i] == other[i];
    }
    return isEqual;
  }

  E? elementAtOrNull(int index) {
    try {
      return this[index];
    } catch (e) {
      return null;
    }
  }

  void replaceWhere(Iterable<E> replacement, bool Function(E element) test) {
    int index = indexWhere(test);

    if (index == -1) throw StateError('index not found in $this');
    replaceRange(index, index + 1, replacement);
  }

  void replace(E value, Iterable<E> replacement) {
    int index = indexWhere((element) => element == value);

    if (index == -1) throw StateError('index of $value not found in $this');
    replaceRange(index, index + 1, replacement);
  }

  List<E> transform(TransformerCallback<E> test) {
    final List<E> tempList = [];
    for (E element in this) {
      tempList.add(test(element));
    }
    return tempList;
  }

  void clearDuplicates() {
    final Set<E> tempSet = toSet();
    clear();
    addAll(tempSet);
  }

  List<E> transformWhere({
    required ElementTestCallback<E> test,
    required TransformerCallback<E> transformer,
  }) {
    final List<E> tempList = [];
    for (E element in this) {
      if (test(element)) {
        element = transformer(element);
      }
      tempList.add(element);
    }
    return tempList;
  }

  E? lastWhereOrNull(
    bool Function(E element) test, {
    E Function()? orElse,
  }) {
    try {
      return lastWhere(test, orElse: orElse);
    } catch (e) {
      return null;
    }
  }

  void forceAdd(E value, int fixedLength) {
    if (length == fixedLength && isNotEmpty) {
      removeAt(0);
    }
    add(value);
  }

  E? firstWhereOrNull(bool Function(E element) test) {
    try {
      return firstWhere(test);
    } on StateError catch (_) {
      return null;
    }
  }

  List<E> addOrJoinNewListIf({
    required bool condition,
    required List<E> newList,
  }) {
    final List<E> tempOldList = [];
    tempOldList.addAll(this);
    final bool eachEqual = tempOldList.isEachEqual(newList);

    if (eachEqual) return newList;
    if (condition) {
      tempOldList.addAll(newList);
      return tempOldList;
    }
    return newList;
  }

  List<E>? get nullIfEmpty => isEmpty ? null : this;

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

extension NullableListExtension<E> on List<E>? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);

  bool get isNotNullOrEmpty => this != null || (this?.isNotEmpty ?? false);

  List<E>? get nullIfEmpty => (this?.isEmpty ?? true) ? null : this;
}
