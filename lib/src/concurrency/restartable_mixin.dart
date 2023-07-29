/*
 * Restartable concurrency mixin for streamed_controller
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

import 'package:streamed_controller/src/controller.dart';
import 'package:streamed_controller/src/single_subscription_mixin.dart';

/// Restarts whole stream processing on any user interuption
/// Warning: it will continue to work until the first [yield]
/// It means that any futures will be completed, but ignored
mixin RestartableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State> implements StreamedSingleSubMixin<State> {
  @override
  void $handle(Stream<State> $stream) {
    unawaited($subscription?.cancel());
    $subscription = $stream.listen($setState)
      ..onDone($destroySubscription)
      ..onError($onError);
  }
}
