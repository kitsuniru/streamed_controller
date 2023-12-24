<!--
streamed_controller
2023, Archie Kitsuniru
-->

# streamed_controller

Tiny predictable opinionated state management package with prebuilt concurrency
handlers that implement the Business Logic Component design pattern without
complexity of flutter_bloc.

## Features

- Concurrency: supports variative and expandable concurrency handlers
  (droppable, throttled, debounced, concurrent, restartable) and gives you
  possibility to create your own concurrency handler
- No third-part dependencies: based on Flutter's `ChangeNotifier`, `Stream` and
  `InheritedNotifier` for scoping
- Can be listened in various ways: `ListenableBuilder`,
  `InheritedWidget/InheritedNotifier`, `StreamBuilder`, etc..
- Ready to complex state managment: can handle many various cases like auth,
  pagination, notifications, complex loading and state handling

## Getting started

`flutter pub add streamed_controller`

## Usage

1. Define controller class (and state class, if you using streamed_controller
   for complex state managment):

```dart
class TestControllerBase extends StreamedController<int>  {
    TestControllerBase() : super(initialState: 0, eventHandler: ConcurrentConcurrencyHandler());

    Future<void> incrementAwaitable() => handle(() async* {

           await Future.delayed(const Duration(seconds: 1));
           yield state+1;
       }());


}
```

2. Create controller variable in any place where you ready to store it (Stateful
   Scopes, Singletons or other storages):

```dart
final $controller = TestControllerBase();
```

3. Wrap widget which will reacts to controller changes into
   ListenableBuilder/AnimatedBuilder:

```dart
ListenableBuilder(
    listenable: $controller,
    builder: (context, child) => Text(
            '${$controller.state}',
            style: Theme.of(context).textTheme.headlineMedium,
        ))
```

4. And then call these functions from your code

```dart
FloatingActionButton(
    onPressed: $controller.increment,
    tooltip: 'Async increment',
    child: const Icon(Icons.add),
)
```

### Observing

To create your own controller observer, that watches for all controller's
lifecycles, you need to extend StreamedControllerObserver and override its
methods:

- `onCreate`
- `onDispose`
- `onError`
- `onStateChanged`

Then you need to assign a static variable `observer` to your observer object in
the initialization (or other place) of your code
`StreamedController.observer = MyCoolObserver();`

By default, you can try logger that uses internal `dart:developer` `log` method

Pass it like this:
`StreamedController.observer = StreamedControllerObserver.dartLog();`

StreamedControllerObserver example:

```dart
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
```

### Streams

`StreamedController` exposes `stateChanges` lazy `Stream<State>` that emits new
state to it listeners, basing on Stream API In general, you won't have to use
this stream for rebuilding states or etc, because you have all features from
`ChangeNotifier` API

`stateChanges` stream is lazy, which means it doesn't create until first call

---

2023, Archie Kitsuniru (kitsuniru)
