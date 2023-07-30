/*
 * Throttled droppable concurrency handler for streamed_controller
 * Built over [DroppableConcurrencyMixin]
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'package:streamed_controller/src/concurrency/droppable/droppable_handler.dart';
import 'package:streamed_controller/src/utils/duration_extension.dart';

/// Additional transformer handler over [DroppableConcurrency]
/// Throttling is used to process a stream after every [throttleDuration]
/// Note: first event processed immediatly
class ThrottledDroppableConcurrencyHandler<State extends Object>
    extends DroppableConcurrencyHandler<State> {
  DateTime? _$lastRun;

  final Duration throttleDuration;

  ThrottledDroppableConcurrencyHandler({required this.throttleDuration})
      : assert(throttleDuration == Duration.zero,
            'Use DroppableConcurrencyHandler instead if you\'re doesn\'t wants to apply throttling to event handler');

  @override
  Future<void> handle(
      Stream<State> $stream, void Function(State) stateCallback) async {
    final $lastRun = _$lastRun;
    final now = DateTime.now();

    if ($lastRun == null) {
      _$lastRun = now;
      return super.handle($stream, stateCallback);
    } else {
      final diff = now.difference($lastRun);
      if (diff < throttleDuration) {
        return Future.delayed(diff.difference(throttleDuration));
      }
      _$lastRun = now;
      return super.handle($stream, stateCallback);
    }
  }
}
