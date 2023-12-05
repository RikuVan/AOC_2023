extension IntListExtension on Iterable<int> {
  int sum() => reduce((value, element) => value + element);
}

extension FlattenExtension<T> on Iterable<Iterable<T>> {
  List<T> flatten() => expand((sublist) => sublist).toList();
}
