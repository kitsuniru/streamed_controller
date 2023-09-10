import 'dart:async';

import 'package:streamed_controller/src/concurrency/base_handler.dart';

/// Restarts whole stream processing on any user interuption
/// Warning: it will continue to work until the first [yield]
/// It means that any futures will be completed, but ignored
class RestartableConcurrencyHandler<State extends Object> extends SingleSubscriptionHandlerBase<State> {
  RestartableConcurrencyHandler();

  @override
  Future<void> handle(Stream<State> $stream, void Function(State) stateCallback) {
    unawaited($subscription?.cancel());
    $subscription = $stream.listen(stateCallback)
      ..onDone($destroySubscription)
      ..onError(Error.throwWithStackTrace);
    return Future.value();
  }

  @override
  String toString() => 'Restartable';
}
