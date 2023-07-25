/*
 * Concurrent concurrency mixin for streamed_controller
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

import 'package:streamed_controller/src/controller.dart';

/// Simultaneously process every event that comes from user
mixin ConcurrentConcurrencyMixin<State extends Object>
    on BaseStreamedController<State> {
  int _$processingCalls = 0;

  @override
  bool get isProcessing => _$processingCalls > 0;

  Future<void> _cancelSub(StreamSubscription $subscription) async {
    await $subscription.cancel();
    _$processingCalls--;
  }

  @override
  void handle(Stream<State> $stream) {
    final $subscription = ($stream).listen($setState);
    _$processingCalls++;
    $subscription.onDone(() => _cancelSub($subscription));
    $subscription.onError((e, s) {
      _cancelSub($subscription);
      Error.throwWithStackTrace(e, s);
    });
  }
}
