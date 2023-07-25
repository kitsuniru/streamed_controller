/*
 * Throttled droppable concurrency mixin for streamed_controller
 * Additive option for [DroppableConcurrencyMixin]
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'package:meta/meta.dart';
import 'package:streamed_controller/src/controller.dart';
import 'package:streamed_controller/src/single_subscription_mixin.dart';
import 'package:streamed_controller/src/utils/duration_extension.dart';

import 'droppable_mixin.dart';

/// Additional transformer mixin to [DroppableConcurrency]
/// Throttling is used to process a stream after every [throttleDuration]
/// Note: first event processed immediatly
mixin ThrottledDroppableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State>
    implements StreamedSingleSubMixin<State>, DroppableConcurrencyMixin<State> {
  /// Interval between handling each event
  @mustBeOverridden
  Duration get throttleDuration;

  DateTime? _$lastRun;

  @override
  Future<void> handle(Stream<State> $stream) async {
    final $lastRun = _$lastRun;
    final now = DateTime.now();

    if ($lastRun == null) {
      _$lastRun = now;
      return super.handle($stream);
    } else {
      final diff = now.difference($lastRun);
      if (diff < throttleDuration) {
        return Future.delayed(diff.difference(throttleDuration));
      }
      _$lastRun = now;
      return super.handle($stream);
    }
  }
}
