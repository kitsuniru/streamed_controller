/*
 * Base class for self-handling Stateful scope that can get controller via
 * `provide` parameters
 * Archie Kitsushimo <Kitsushimo.dev@gmail.com>, 29 July 2023
 */

import 'package:flutter/widgets.dart';
import 'package:streamed_controller/src/controller.dart';

import 'scope_base.dart';

class _InheritedStreamedScope<T extends BaseStreamedController>
    extends StreamedScope<T> {
  const _InheritedStreamedScope({
    required super.controller,
    required super.child,
  });
}

/// Declarative scope that controls full flow of controller lifecycle
abstract class StatefulStreamedScope<T extends BaseStreamedController>
    extends StatefulWidget {
  const StatefulStreamedScope({
    super.key,
    required this.provide,
    required this.child,
  });

  /// Provides or creates new controller that will be handle with this scope
  /// Calls only once
  final T provide;
  final Widget child;

  @override
  State<StatefulStreamedScope<T>> createState() =>
      _StatefulStreamedScopeState<T>();
}

class _StatefulStreamedScopeState<T extends BaseStreamedController>
    extends State<StatefulStreamedScope<T>> {
  late final $controller = widget.provide;

  @override
  Widget build(BuildContext context) =>
      _InheritedStreamedScope(controller: $controller, child: widget.child);

  @override
  void dispose() {
    $controller.dispose();
    super.dispose();
  }
}
