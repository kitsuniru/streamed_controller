/*
 * Base class for all streamed controllers
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 25 July 2023
 */

import 'dart:async';

import 'package:flutter/foundation.dart';

/// Base class for all inherited controllers
abstract class BaseStreamedController<State extends Object>
    with ChangeNotifier {
  State _state;

  /// Current state of controller
  State get state => _state;

  @protected
  @nonVirtual
  void $setState(State state) {
    _state = state;
    notifyListeners();
  }

  /// Maximum processing time for each event
  Duration? get eventTimeout => null;

  /// Is controller processing your request?
  bool get isProcessing => false;

  FutureOr<void> handle(Stream<State> $stream) => throw UnimplementedError(
      'Controller should use one of concurrency mixin');

  BaseStreamedController({required State initialState}) : _state = initialState;
}
