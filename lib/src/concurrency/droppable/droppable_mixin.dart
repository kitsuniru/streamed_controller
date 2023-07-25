/*
 * Droppable concurrency mixin for streamed_controller
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'package:meta/meta.dart';
import 'package:streamed_controller/src/controller.dart';
import 'package:streamed_controller/src/single_subscription_mixin.dart';

/// Transformer that ignores the processing of all events
/// if something else is being processed at the moment
mixin DroppableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State> implements StreamedSingleSubMixin<State> {
  @override
  @nonVirtual
  bool get isProcessing => _isProcessing;

  bool _isProcessing = false;

  Future<void> _$endSub() async {
    await $destroySubscription();
    _isProcessing = false;
  }

  Future<void> _$catchError(Object? e, StackTrace s) {
    _$endSub();
    Error.throwWithStackTrace(e!, s);
  }

  @override
  Future<void> handle(Stream<State> $stream) async {
    if ($subscription != null) return;
    _isProcessing = true;
    $subscription = $stream.listen($setState);
    return $subscription
        ?.asFuture<void>()
        .whenComplete(_$endSub)
        .onError(_$catchError);
  }
}
