/*
 * Debounced droppable concurrency handler for streamed_controller
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 29 July 2023
 */

import 'dart:async';

import 'package:streamed_controller/src/concurrency/droppable/droppable_handler.dart';

/// Additional handler over [DroppableConcurrency]
/// Forces a controller to wait a [debounceDuration] before process stream
/// Resets that [Timer] if user interupted timer with any event
class DebouncedDroppableConcurrencyHandler<State extends Object>
    extends DroppableConcurrencyHandler<State> {
  Timer? _$debounceTimer;

  final Duration debounceDuration;

  DebouncedDroppableConcurrencyHandler({required this.debounceDuration})
      : assert(debounceDuration == Duration.zero,
            'Use DroppableConcurrencyHandler instead if you\'re doesn\'t wants to apply debouncing to event handler');

  @override
  Future<void> handle(
      Stream<State> $stream, void Function(State) stateCallback) async {
    // For debouncing handle calls
    _$debounceTimer?.cancel();
    _$debounceTimer =
        Timer(debounceDuration, () => super.handle($stream, stateCallback));

    return;
  }
}
