import 'package:flutter/material.dart';
import 'package:streamed_controller/streamed_controller.dart';

void main() {
  runApp(const MyApp());
}

class TestControllerBase extends BaseStreamedController<int> {
  TestControllerBase() : super(initialState: 0);

  void increment() => event(() async* {
        yield state + 1;
        await Future.delayed(const Duration(seconds: 2));
        yield state + 2;
      }());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamedController demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'StreamedController Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final $controller = TestControllerBase();

  @override
  void initState() {
    $controller.addListener(() =>
        print('[${$controller.runtimeType}] State: ${$controller.state}'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // AnimatedBuilder\ListenableBuilder
            // or any widget that accepts [Listenable]
            ListenableBuilder(
                listenable: $controller,
                builder: (context, child) => Text(
                      '${$controller.state}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: $controller.increment,
        tooltip: 'Async increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
