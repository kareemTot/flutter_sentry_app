import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init((options) {
    options.dsn =
        'https://9cc8af2ca2367e4d029c0b4e5f15f644@o4511190288760832.ingest.us.sentry.io/4511190291775488';
    options.debug = true;
    options.environment = 'development';
    options.sendDefaultPii = false;
  }, appRunner: () => runApp(SentryWidget(child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
          children: const [
            Text('Tap the button to send a test event to Sentry.'),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          try {
            throw StateError('This is test exception');
          } catch (exception, stackTrace) {
            final eventId = await Sentry.captureException(
              exception,
              stackTrace: stackTrace,
            );
            debugPrint('Sentry event id: $eventId');

            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Sent to Sentry: $eventId')));
          }
        },
        child: const Text('Verify Sentry Setup'),
      ),
    );
  }
}
