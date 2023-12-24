/*
 * AsyncQueue
 * Archie Kitsuniru <archie@kitsuniru.dev>, 25 July 2023
 */

import 'dart:async';

class AsyncQueue<T> {
  Future<T?> _current = Future.value(null);

  bool _isClosed = false;
  bool get isClosed => _isClosed;

  void close() => _isClosed = true;

  Future<T?> add(FutureOr<T> Function() task) {
    if (_isClosed) throw Exception('AsyncQueue is already closed');
    FutureOr<T?> wrapper(void _) => task();
    return _current = _current.then(wrapper, onError: wrapper);
  }
}
