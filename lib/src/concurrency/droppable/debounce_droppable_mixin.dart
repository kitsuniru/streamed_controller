/*
 * Debounced droppable concurrency mixin for streamed_controller
 * Additive option for [DroppableConcurrencyMixin]
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:streamed_controller/src/controller.dart';
import 'package:streamed_controller/src/single_subscription_mixin.dart';

import 'droppable_mixin.dart';

/// Additional mixin to [DroppableConcurrency]
/// Forces a controller to wait a [debounceDuration] before process stream
/// Resets that [Timer] if user interupted timer with any event
mixin DebouncedDroppableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State>
    implements StreamedSingleSubMixin<State>, DroppableConcurrencyMixin<State> {
  /// Waiting time before processing event
  @mustBeOverridden
  Duration get debounceDuration;

  Timer? _$debounceTimer;

  @override
  Future<void> handle(Stream<State> $stream) async {
    // For debouncing handle calls
    _$debounceTimer?.cancel();
    _$debounceTimer = Timer(debounceDuration, () => super.handle($stream));

    return;
  }
}
