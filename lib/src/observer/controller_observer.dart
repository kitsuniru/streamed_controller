import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:streamed_controller/src/controller.dart';

/// ControllerObserver Singleton class
class StreamedControllerObserver {
  @protected
  StreamedControllerObserver();

  factory StreamedControllerObserver.dartLog() => _TestControllerObserver();

  static Never _overrideError() => throw UnimplementedError(
      'This method should be overrided with your own logging package/solution');

  @mustBeOverridden
  void onCreate(StreamedController controller) => _overrideError();

  @mustBeOverridden
  void onDispose(StreamedController controller) => _overrideError();

  @mustBeOverridden
  void onStateChanged(
          StreamedController controller, Object prevState, Object nextState) =>
      _overrideError();

  @mustBeOverridden
  void onError(StreamedController? controller, Object? error,
          StackTrace stackTrace) =>
      _overrideError();
}

class _TestControllerObserver extends StreamedControllerObserver {
  @override
  void onCreate(StreamedController<Object> controller) =>
      log('${controller.runtimeType} created');

  @override
  void onDispose(StreamedController<Object> controller) =>
      log('${controller.runtimeType} disposed');
  @override
  void onError(StreamedController<Object>? controller, Object? error,
          StackTrace stackTrace) =>
      log('${controller.runtimeType} got error: $error');

  @override
  void onStateChanged(StreamedController<Object> controller, Object prevState,
          Object nextState) =>
      log('${controller.runtimeType} state updated, new state: $nextState');
}
