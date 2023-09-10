import 'dart:async';

import 'package:streamed_controller/src/concurrency/base_handler.dart';
import 'package:streamed_controller/src/utils/async_queue.dart';

class SequentalConcurrentHandler<State extends Object> extends HandlerBase<State> {
  int _processingCalls = 0;

  final _$queue = AsyncQueue<void>();

  @override
  bool get isProcessing => _processingCalls > 0;

  void _cancelSub(StreamSubscription subscription) {
    subscription.cancel();
    --_processingCalls;
  }

  @override
  Future<void> handle(Stream<State> $stream, void Function(State) stateCallback) async {
    Future<void> $queueObject() {
      final $subscription = $stream.listen(stateCallback);
      var $future = $subscription.asFuture<void>().whenComplete(() => _cancelSub($subscription)).onError((e, s) {
        _cancelSub($subscription);
        if (e != null) {
          Error.throwWithStackTrace(e, s);
        }
      });

      if (eventTimeout != null) {
        $future = $future.timeout(eventTimeout!);
      }

      return $future;
    }

    _$queue.add($queueObject);
  }

  final Duration? eventTimeout;

  @override
  void dispose() {
    _$queue.close();
  }

  @override
  String toString() => 'Sequental';
  SequentalConcurrentHandler({this.eventTimeout});
}
