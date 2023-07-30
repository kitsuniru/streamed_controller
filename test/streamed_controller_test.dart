import 'package:flutter_test/flutter_test.dart';
import 'package:streamed_controller/streamed_controller.dart';

class TestControllerBase extends StreamedController<int> {
  TestControllerBase({required HandlerBase<int> handleHandler})
      : super(initialState: 0, eventHandler: handleHandler);

  Future<void> incrementAwaitable() async => handle(() async* {
        await Future.delayed(const Duration(seconds: 1));
        yield state + 1;
      }());

  void clear() => handle(() async* {
        yield 0;
      }());
}

void main() {
  StreamedController.observer = StreamedControllerObserver.dartLog();
  final sequentalController =
      TestControllerBase(handleHandler: SequentalConcurrentHandler());
  final droppableController =
      TestControllerBase(handleHandler: DroppableConcurrencyHandler());
  final concurrentController =
      TestControllerBase(handleHandler: ConcurrentConcurrencyHandler());
  final restartableController =
      TestControllerBase(handleHandler: RestartableConcurrencyHandler());

  test('sequentalTest', () async {
    sequentalController.incrementAwaitable();
    sequentalController.incrementAwaitable();
    sequentalController.incrementAwaitable();
    sequentalController.incrementAwaitable();
    sequentalController.incrementAwaitable();

    await Future.delayed(const Duration(seconds: 6));
    expect(sequentalController.state, 5);
  });

  test('droppableController', () async {
    await droppableController.incrementAwaitable();
    await droppableController.incrementAwaitable();
    await droppableController.incrementAwaitable();
    await droppableController.incrementAwaitable();
    await droppableController.incrementAwaitable();

    await Future.delayed(const Duration(seconds: 6));
    expect(droppableController.state, 5);
  });

  test('restartableController', () async {
    restartableController.incrementAwaitable();
    restartableController.incrementAwaitable();
    restartableController.incrementAwaitable();
    restartableController.incrementAwaitable();
    restartableController.incrementAwaitable();
    await Future.delayed(const Duration(seconds: 3));
    expect(restartableController.state, 1);
  });
}
