## 0.3.0
* feat: SequentalConcurrency mixin using AsyncQueue
* feat: ThrottledDroppableConcurrencyMixin can be awaited until throttle end
* refactor: reorganized package structure
* inner_fix: file signing (myself and author of selector feature)

## 0.2.0

* feat: any event (on ```DroppableConcurrencyMixin``` and it descendants) can be awaited as future (until stream finishes working)
* fix: copyrighting in README.md

## 0.1.0

* feat: ```DroppableConcurrencyMixin, DebouncedDroppableConcurrencyMixin, ThrottleDroppableConcurrencyMixin, RestartableConcurrencyMixin```
* test: ***async increment stat, restartable test, concurrent test***
* example: async counter example
