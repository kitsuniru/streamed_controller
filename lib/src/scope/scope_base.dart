/*
 * Base class for all named scopes, special to work with StreamedControllers
 * Archie Kitsuniru <archie@kitsuniru.dev>, 29 July 2023
 */

import 'package:flutter/widgets.dart';
import 'package:streamed_controller/src/controller.dart';

/// {@template streamed_scope}
/// StreamedScope widget.
/// {@endtemplate}
abstract class StreamedScope<T extends StreamedController> extends InheritedNotifier<T> {
  /// {@macro streamed_scope}
  const StreamedScope({
    required T controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static S? maybeOf<S extends StreamedScope>(
    BuildContext context, {
    bool listen = true,
  }) =>
      listen ? context.dependOnInheritedWidgetOfExactType<S>() : context.getInheritedWidgetOfExactType<S>();

  static S of<S extends StreamedScope>(
    BuildContext context, {
    bool listen = true,
  }) =>
      maybeOf<S>(context, listen: listen) ?? notFoundInheritedWidgetOfExactType<S>();

  static Never notFoundInheritedWidgetOfExactType<T extends InheritedWidget>() => throw ArgumentError(
        'Out of scope, not found inherited controller '
            'a $T of the exact type',
        'out_of_scope',
      );
}
