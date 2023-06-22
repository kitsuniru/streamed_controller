import 'dart:async';

import 'package:meta/meta.dart';

import 'controller.dart';

/// A mixin that introduces a restriction on one state stream subcription being
/// processed at a time
mixin StreamedSingleSubMixin<State extends Object>
    on BaseStreamedController<State> {
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
    super.dispose();
  }
}
