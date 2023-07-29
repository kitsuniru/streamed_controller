/*
 * Base class for all streamed controllers
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:streamed_controller/src/observer/controller_observer.dart';

/// Base class for all inherited controllers
abstract class BaseStreamedController<State extends Object>
    with ChangeNotifier {
  /* Streaming */
  StreamController<State>? _lazyStream;

  /// Lazily initiated stream of incoming states
  Stream<State> get stateChanges => (_lazyStream ??= _createStream()).stream;

  /* State */
  State _state;

  /// Current state of controller
  State get state => _state;

  @protected
  StreamController<State> _createStream() {
    final stream = StreamController<State>();
    addListener(() => stream.sink.add(state));
    return stream;
  }

  @protected
  @nonVirtual
  void $setState(State state) {
    StreamedControllerObserver.observer?.onStateChanged(this, _state, state);
    _state = state;

    notifyListeners();
  }

  /// Maximum processing time for each event
  Duration? get eventTimeout => null;

  /// Is controller processing your request?
  bool get isProcessing => false;

  @override
  void dispose() {
    StreamedControllerObserver.observer?.onDispose(this);
    _lazyStream?.close();
    super.dispose();
  }

  @nonVirtual
  @protected
  FutureOr<void> event(Stream<State> $stream) async =>
      (StreamedControllerObserver.observer?.handleError ??
              (FutureOr<void> $) async => $)
          .call($handle($stream));

  /// Use `event` instead of `$handle` for describing state's flow via stream
  /// Using this method directly means no internal error handling
  ///
  /// Ideally this method should be privated
  @protected
  FutureOr<void> $handle(Stream<State> $stream) async =>
      throw UnimplementedError(
          'Controller should use one of concurrency mixin');

  @protected
  @nonVirtual
  void $onError(Object? error, StackTrace stackTrace) =>
      StreamedControllerObserver.observer?.onError(this,
          error ?? Exception('Internal exception on $runtimeType'), stackTrace);

  BaseStreamedController({required State initialState})
      : _state = initialState {
    StreamedControllerObserver.observer?.onCreate(this);
  }
}
