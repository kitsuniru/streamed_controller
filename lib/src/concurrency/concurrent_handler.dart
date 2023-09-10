/*
 * Concurrent concurrency mixin for streamed_controller
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

import 'package:streamed_controller/src/concurrency/base_handler.dart';

/// Handler that simultaneously process every event that comes from user asy
class ConcurrentConcurrencyHandler<State extends Object> extends HandlerBase<State> {
  int _$processingCalls = 0;

  Future<void> _cancelSub(StreamSubscription $subscription) async {
    await $subscription.cancel();
    _$processingCalls--;
  }

  @override
  bool get isProcessing => _$processingCalls > 0;

  @override
  Future<void> handle(Stream<State> $stream, void Function(State) stateCallback) {
    final $subscription = ($stream).listen(stateCallback);
    _$processingCalls++;
    $subscription.onDone(() => _cancelSub($subscription));
    $subscription.onError((e, s) {
      _cancelSub($subscription);
      Error.throwWithStackTrace(e, s);
    });
    return Future.value();
  }

  @override
  void dispose() {
    // nothing to dispose
    // possible violation of I principle from SOLID
  }
  @override
  String toString() => 'Concurrent';

  ConcurrentConcurrencyHandler();
}
