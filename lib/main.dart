import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Socket Demo',
        channel: IOWebSocketChannel.connect("ws://echo.websocket.org"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({Key key, this.title, @required this.channel}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController _editController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _sendMessage() {
    if(_editController.text.isNotEmpty) {
      widget.channel.sink.add(
        _editController.text
      );
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Form(
            child: TextFormField(
              decoration: InputDecoration(labelText: "Send a message"),
              controller: _editController,
            ),
          ),
          StreamBuilder(
            stream: widget.channel.stream,
            builder: (bontext, snapshot) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
              );
            },
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        child: Icon(Icons.send),
      ),
    );
  }
}
