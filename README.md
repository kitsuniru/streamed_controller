<!--
streamed_controller
2023, Archie Iwakura
-->

# streamed_controller

 Tiny predictable state management library with prebuilt concurrency helpers that implement the Business Logic Component design pattern without complexity of BLoC.

## Features

* Concurrency: supports variative concurrency mixins (droppable, throttled, debounced, concurrent, restartable)
* Lightweight: tiny solution in 3 files without any external dependencies
* Ready to complex state managment: can handle many various cases like auth, pagination, notifications, complex loading and state handling

## Getting started

```flutter pub add streamed_controller```

## Usage

1) Define controller class (and state class, if you using streamed_controller for complex state managment):

```dart
class TestControllerBase extends BaseStreamedController<int> with ConcurrentConcurrencyMixin {
    TestControllerBase() : super(initialState: 0);
    
    Future<void> incrementAwaitable() => handleStream(() async* {
           yield 1;
           await Future.delayed(const Duration(seconds: 1));
           yield 2;
       }());
    
    void increment() => handleStream(() async* {
           yield 3;
           await Future.delayed(const Duration(seconds: 2));
           yield 4;
       }());
}
```

2) Create controller variable in any place where you ready to store it (Stateful Scopes, Singletons or other storages):


```dart
final $controller = TestControllerBase();
```

3) Wrap widget which will reacts to controller changes into ListenableBuilder/AnimatedBuilder:

```dart
ListenableBuilder(
    listenable: $controller,
    builder: (context, child) => Text(
            '${$controller.state}',
            style: Theme.of(context).textTheme.headlineMedium,
        ))
```

4) And then call these functions from your code
```dart
FloatingActionButton(
    onPressed: $controller.increment,
    tooltip: 'Async increment',
    child: const Icon(Icons.add),
)
```


---

2023, Archie Iwakura (hot-moms)
