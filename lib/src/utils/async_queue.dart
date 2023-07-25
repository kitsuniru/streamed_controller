/*
 * AsyncQueue
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

class AsyncQueue<T> {
  Future<T?> _current = Future.value(null);
  Future<T?> add(FutureOr<T> Function() task) {
    FutureOr<T?> wrapper(void _) => task();
    return _current = _current.then(wrapper, onError: wrapper);
  }
}
