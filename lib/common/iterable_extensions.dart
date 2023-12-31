extension IntListExtension on Iterable<int> {
  int sum() => reduce((value, element) => value + element);
}

extension NestedIterableExtension<T> on Iterable<Iterable<T>> {
  List<T> flatten() => expand((sublist) => sublist).toList();
}

extension IterableExtension<T> on Iterable<T> {
  void forEachIndexed(void Function(int index, T element) action) {
    var index = 0;
    for (var element in this) {
      action(index++, element);
    }
  }
}
