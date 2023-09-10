# 1.1.2
* fix: incorrect assertion on (Throttle/Debounce)DroppableConcurrency fixed

# 1.1.1
* feat: now you can create nullable state streams (Stream<State?>)
* fix: hide internal $setState from overriding
## 1.1.0
* feat: handler now can accept eventName that marks each event
* feat: StreamedObserver now have onEvent(Controller, String eventName)

## 1.0.0
* BREAKING: StreamedController now uses custom handlers which passes into constructor (or directly into `super.eventHandler`) instead of mixins

  By default (if no handlers passed), StreamedController uses `ConcurrentConcurrencyHandler`
* feat: Observing: Introducing StreamedControllerObserver
* feat: Custom Handling: create your own concurrency handlers based on `HandlerBase<State>`

## 0.3.0
* feat: SequentalConcurrency mixin using AsyncQueue
* feat: ThrottledDroppableConcurrencyHandler can be awaited until throttle end
* refactor: reorganized package structure
* inner_fix: file signing (myself and author of selector feature)

## 0.2.0

* feat: any event (on ```DroppableConcurrencyHandler``` and it descendants) can be awaited as future (until stream finishes working)
* fix: copyrighting in README.md

## 0.1.0

* feat: ```DroppableConcurrencyHandler, DebouncedDroppableConcurrencyHandler, ThrottleDroppableConcurrencyHandler, RestartableConcurrencyHandler```
* test: ***async increment stat, restartable test, concurrent test***
* example: async counter example
