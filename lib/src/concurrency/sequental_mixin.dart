/*
 * Sequental concurrency mixin for streamed_controller
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:streamed_controller/src/controller.dart';
import 'package:streamed_controller/src/utils/async_queue.dart';

mixin SequentalConcurrentMixin<State extends Object>
    on BaseStreamedController<State> {
  int _processingCalls = 0;

  @override
  bool get isProcessing => _processingCalls > 0;

  final _$queue = AsyncQueue<void>();

  void _cancelSub(StreamSubscription sub) {
    sub.cancel();
    --_processingCalls;
  }

  @nonVirtual
  @override
  Future<void> $handle(Stream<State> $stream) async {
    Future<void> $queueObject() {
      final $subscription = $stream.listen($setState);
      var $future = $subscription
          .asFuture<void>()
          .whenComplete(() => _cancelSub($subscription))
          .onError((e, s) {
        _cancelSub($subscription);
        $onError(e, s);
      });

      if (eventTimeout != null) {
        $future = $future.timeout(eventTimeout!);
      }

      return $future;
    }

    _$queue.add($queueObject);
  }
}
