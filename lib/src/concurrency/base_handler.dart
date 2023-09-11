/*
 *
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 11 September 2023
 */

import 'dart:async';

import 'package:meta/meta.dart';

/// Base for mutators that describes their lifecycle and main methods
abstract class HandlerBase<State extends Object> {
  void dispose();
  bool get isProcessing;
  Future<void> handle(Stream<State> $stream, void Function(State) stateCallback);

  @override
  @mustBeOverridden
  String toString();
}

abstract class SingleSubscriptionHandlerBase<State extends Object> implements HandlerBase<State> {
  StreamSubscription<State>? $subscription;

  @override
  bool get isProcessing => $subscription != null;

  @protected
  @nonVirtual
  Future<void> $destroySubscription() async {
    await $subscription?.cancel();
    $subscription = null;
  }

  @override
  Future<void> dispose() async {
    await $destroySubscription();
  }

  @override
  Future<void> handle(Stream<State> $stream, void Function(State) stateCallback) =>
      throw UnimplementedError('$runtimeType does not have a specific implementation of event handling');

  SingleSubscriptionHandlerBase();

  @override
  @mustBeOverridden
  String toString() => 'SingleSubscriptionHandlerBase';
}
