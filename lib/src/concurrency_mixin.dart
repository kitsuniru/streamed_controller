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
  void handle(Stream<dynamic> $stream) {
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

  Future<void> _$catchError(Object? e, StackTrace s) {
    _$endSub();
    Error.throwWithStackTrace(e!, s);
  }

  @override
  Future<void> handle(Stream<Object> $stream) async {
    if ($subscription != null) return;
    _isProcessing = true;
    $subscription = ($stream as Stream<State>).listen($setState);
    return $subscription
        ?.asFuture<void>()
        .whenComplete(_$endSub)
        .onError(_$catchError);
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
  Future<void> handle(Stream<Object> $stream) async {
    // For debouncing handle calls
    _$debounceTimer?.cancel();
    _$debounceTimer = Timer(debounceDuration, () => super.handle($stream));

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
  Future<void> handle(Stream<Object> $stream) async {
    final $lastRun = _$lastRun;
    final now = DateTime.now();

    if ($lastRun == null) {
      _$lastRun = now;
      return super.handle($stream);
    } else {
      final diff = now.difference($lastRun);
      if (diff < throttleDuration) {
        return Future.value();
      }
      _$lastRun = now;
      return super.handle($stream);
    }
  }
}

/// Restarts whole stream processing on any user interuption
/// Warning: it will continue to work until the nearest [yield]
/// It means that any futures will be completed, but ignored
mixin RestartableConcurrencyMixin<State extends Object>
    on BaseStreamedController<State> implements StreamedSingleSubMixin<State> {
  @override
  void handle(Stream<Object> $stream) {
    unawaited($subscription?.cancel());
    $subscription = ($stream as Stream<State>).listen($setState)
      ..onDone($destroySubscription);
  }
}
