import 'dart:async';

import 'package:meta/meta.dart';
import 'package:streamed_controller/src/controller.dart';

// typedef ControllerEvent =

/// ControllerObserver Singleton class
class BaseControllerObserver {
  static final BaseControllerObserver _internalSingleton =
      BaseControllerObserver._internal();
  factory BaseControllerObserver() => _internalSingleton;

  BaseControllerObserver._internal() {
    _$zone = Zone.current.fork(
        specification: ZoneSpecification(
            handleUncaughtError: (_, __, ___, error, stackTrace) =>
                onError(null, error, stackTrace)));
  }

  late final Zone _$zone;

  static Never _overrideError() => throw UnimplementedError(
      'This method should be overrided with your own logging package/solution');

  FutureOr<void> handleError(FutureOr<void> action) async => _$zone.runGuarded(
        () async => action,
      );

  @mustBeOverridden
  void onCreate(BaseStreamedController controller) => _overrideError();

  @mustBeOverridden
  void onDispose(BaseStreamedController controller) => _overrideError();

  @mustBeOverridden
  void onStateChanged(BaseStreamedController controller, Object prevState,
          Object nextState) =>
      _overrideError();

  @mustBeOverridden
  void onError(BaseStreamedController? controller, Object error,
          StackTrace stackTrace) =>
      _overrideError();
}

class StreamedControllerObserver {
  static BaseControllerObserver? observer;
}
