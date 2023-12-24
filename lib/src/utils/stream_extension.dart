/*
 *
 * Archie Kitsuniru <archie@kitsuniru.dev>, 25 July 2023
 */

extension StreamExt<T extends Object> on Stream<T?> {
  Stream<T> whereNotNull() => (where((event) => event != null)) as Stream<T>;
}
