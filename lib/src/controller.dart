/*
 * Base class for all streamed controllers
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:streamed_controller/streamed_controller.dart';

/// Base class for all inherited controllers
abstract class StreamedController<State extends Object> with ChangeNotifier {
  late final HandlerBase<State> _eventHandler;
  static StreamedControllerObserver? observer;

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
    _state = state;

    notifyListeners();
    observer?.onStateChanged(this, _state, state);
  }

  /// Maximum processing time for each event
  Duration? get eventTimeout => null;

  /// Is controller processing your request?
  bool get isProcessing => false;

  @override
  void dispose() {
    observer?.onDispose(this);
    _lazyStream?.close();
    super.dispose();
  }

  @nonVirtual
  @protected
  Future<void> handle(Stream<State> $stream) async =>
      _eventHandler.handle($stream, $setState).catchError(
          (error, stackTrace) => observer?.onError(this, error, stackTrace));

  /// Default constructor to `StreamedController`
  ///
  /// If `eventHandler` isn't provided then `ConcurrentConcurrencyHandler` used
  /// instead
  StreamedController({
    required State initialState,
    HandlerBase<State>? eventHandler,
  })  : _state = initialState,
        _eventHandler = eventHandler ?? ConcurrentConcurrencyHandler() {
    observer?.onCreate(this);
  }
}
