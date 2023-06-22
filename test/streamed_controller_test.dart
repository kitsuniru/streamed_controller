import 'package:flutter_test/flutter_test.dart';
import 'package:streamed_controller/streamed_controller.dart';

class TestControllerBase extends BaseStreamedController<int> {
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

class RestartableController = TestControllerBase
    with StreamedSingleSubMixin, RestartableConcurrencyMixin;
class DroppableController = TestControllerBase
    with StreamedSingleSubMixin, DroppableConcurrencyMixin;
class ConcurrentController = TestControllerBase with ConcurrentConcurrencyMixin;

void main() {
  test('async increment state', () async {
    final controller = DroppableController();
    controller.addListener(
        () => print('[${controller.runtimeType}] State: ${controller.state}'));

    await controller.incrementAwaitable();
    expect(controller.state, 2);
  });

  test('restartable test', () async {
    final controller = RestartableController();
    controller.addListener(
        () => print('[${controller.runtimeType}] State: ${controller.state}'));

    controller.increment();
    await Future.delayed(const Duration(seconds: 1));
    controller.increment();
    await Future.delayed(const Duration(seconds: 1));
    await controller.incrementAwaitable();
    expect(controller.state, 2);
    controller.increment();
    await Future.delayed(const Duration(seconds: 3));
    expect(controller.state, 4);
  });

  test('concurrent test', () async {
    final controller = ConcurrentController();
    controller.addListener(
        () => print('[${controller.runtimeType}] State: ${controller.state}'));

    await controller.incrementAwaitable();
    await controller.incrementAwaitable();
    await controller.incrementAwaitable();
    await controller.incrementAwaitable();

    await Future.delayed(const Duration(seconds: 2));
    expect(controller.state, 2);
  });
}
