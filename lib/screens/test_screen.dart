import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class IncrementIntent extends Intent {
  const IncrementIntent();
}

class DecrementIntent extends Intent {
  const DecrementIntent();
}

class TestScreen extends StatefulWidget {
  static const name = 'test';
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // final _controller = StreamController();
  int count = 0;

  final TextEditingController _textEditingController = TextEditingController();
  final channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  void sendMessage() async {
    if (_textEditingController.text.isNotEmpty) {
      channel.sink.add(_textEditingController.text);
    }
  }

  // Stream<int> getStream() async* {
  //   for (int i = 0; i <= 5; i++) {
  //     yield i;
  //     yield* getStream();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Shortcuts(
          shortcuts: <ShortcutActivator, Intent>{
            LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowDown):
                const DecrementIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              IncrementIntent: CallbackAction<IncrementIntent>(
                onInvoke: (IncrementIntent intent) => setState(() {
                  count = count + 1;
                }),
              ),
              DecrementIntent: CallbackAction<DecrementIntent>(
                onInvoke: (DecrementIntent intent) => setState(() {
                  count = count - 1;
                }),
              ),
            },
            child: Focus(
              autofocus: true,
              child: Column(
                children: <Widget>[
                  const Text('Add to the counter by pressing the up arrow key'),
                  const Text(
                      'Subtract from the counter by pressing the down arrow key'),
                  Text('count: $count'),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("TEST"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
    _textEditingController.dispose();
  }
}
