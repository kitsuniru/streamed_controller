/*
 * Droppable concurrency handler for streamed_controller
 * Archie Kitsuniru <archie@kitsuniru.dev>, 29 July 2023
 */

import 'package:meta/meta.dart';
import 'package:streamed_controller/src/concurrency/base_handler.dart';

/// Handler that ignores the processing of all events
/// if something else is being processed at the moment
class DroppableConcurrencyHandler<State extends Object> extends SingleSubscriptionHandlerBase<State> {
  bool _isProcessing = false;

  DroppableConcurrencyHandler();

  Future<void> _$endSub() async {
    await $destroySubscription();
    _isProcessing = false;
  }

  void _$catchError(Object? e, StackTrace s) {
    _$endSub();
    if (e != null) {
      Error.throwWithStackTrace(e, s);
    }
  }

  @override
  String toString() => 'Droppable';

  @override
  @nonVirtual
  bool get isProcessing => _isProcessing;

  @override
  Future<void> handle(Stream<State> $stream, void Function(State) stateCallback) async {
    if ($subscription != null) return;
    _isProcessing = true;
    $subscription = $stream.listen(stateCallback);
    return $subscription?.asFuture<void>().whenComplete(_$endSub).onError(_$catchError);
  }
}
