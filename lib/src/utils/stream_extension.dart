extension StreamExt<T extends Object> on Stream<T?> {
  Stream<T> whereNotNull() => (where((event) => event != null)) as Stream<T>;
}
