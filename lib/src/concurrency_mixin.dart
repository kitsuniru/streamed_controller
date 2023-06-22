import 'dart:async';

import 'controller.dart';
import 'single_subscription_mixin.dart';

/// Simultaneously process every event that comes from user
mixin ConcurrentConcurrencyMixin<State extends Object>
    on BaseStreamedController<State> {
  int _$processingCalls = 0;

  @override
  bool get isProcessing => _$processingCalls > 0;

  Future<void> _cancelSub(StreamSubscription $subscription) async {
    await $subscription.cancel();
    _$processingCalls--;
  }

  @override
  Future<void> handleStream(Stream<dynamic> $stream) async {
    final $subscription = ($stream as Stream<State>).listen($setState);
    _$processingCalls++;
    $subscription.onDone(() => _cancelSub($subscription));
    $subscription.onError((e, s) {
      _cancelSub($subscription);
      Error.throwWithStackTrace(e, s);
    });
  }
}

/// Drop all incoming events during stream processing
mixin DroppableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State> implements StreamedSingleSubMixin<State> {
  @override
  bool get isProcessing => _isProcessing;

  bool _isProcessing = false;

  Future<void> _$endSub() async {
    await $destroySubscription();
    _isProcessing = false;
  }

  @override
  Future<void> handleStream(Stream $stream) async {
    if ($subscription != null) return;
    _isProcessing = true;
    $subscription = ($stream as Stream<State>).listen($setState)
      ..onDone(_$endSub)
      ..onError((e, s) {
        _$endSub();
        Error.throwWithStackTrace(e, s);
      });
    await $subscription?.asFuture();
  }
}

/// Additional mixin to [DroppableConcurrency]
/// Forces a controller to wait a [debounceDuration] before process stream
/// Resets that [Timer] if user interupted timer with any event
mixin DebouncedDroppableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State>
    implements StreamedSingleSubMixin<State>, DroppableConcurrencyMixin<State> {
  /// Waiting time before processing event
  Duration get debounceDuration;
  Timer? _$debounceTimer;

  @override
  Future<void> handleStream(Stream $stream) async {
    // For debouncing handle calls
    _$debounceTimer?.cancel();
    _$debounceTimer =
        Timer(debounceDuration, () => super.handleStream($stream));

    return Future.value();
  }
}

/// Additional mixin to [DroppableConcurrency]
/// Throttling is used to process a stream after every [throttleDuration]
/// Note: first event processed immediatly
mixin ThrottledDroppableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State>
    implements StreamedSingleSubMixin<State>, DroppableConcurrencyMixin<State> {
  /// Interval between handling each event
  Duration get throttleDuration;

  DateTime? _$lastRun;

  @override
  Future<void> handleStream(Stream $stream) async {
    final $lastRun = _$lastRun;
    final now = DateTime.now();

    if ($lastRun == null) {
      _$lastRun = now;
      return super.handleStream($stream);
    } else {
      final diff = now.difference($lastRun);
      if (diff < throttleDuration) {
        return Future.value();
      }
      _$lastRun = now;
      return super.handleStream($stream);
    }
  }
}

/// Restarts whole stream processing on any user interuption
/// Warning: it will continue to work until the nearest [yield]
/// It means that any futures will be completed, but ignored
mixin RestartableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State> implements StreamedSingleSubMixin<State> {
  @override
  Future<void> handleStream(Stream $stream) async {
    unawaited($subscription?.cancel());
    $subscription = ($stream as Stream<State>).listen($setState)
      ..onDone($destroySubscription);
    await $subscription?.asFuture();
  }
}
