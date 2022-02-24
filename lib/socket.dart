import 'package:socket_io_client/socket_io_client.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class SocketView extends StatefulWidget {
  const SocketView({Key? key}) : super(key: key);

  @override
  _SocketViewState createState() => _SocketViewState();
}

class _SocketViewState extends State<SocketView> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _messages = [];
  late Socket socket;

  @override
  void initState() {
    socket = io('http://10.29.124.31:3000/', {
      "transports": ["websocket"],
      "autoConnect": false,
    });
    initializeSocket();
    super.initState();
  }

  void initializeSocket() {
    if(socket.connected) socket.disconnect();
    socket.connect();
    socket.on('connect', (data) {
      print(socket.connected);
    });
    socket.on('message', (data) => setState(() {
      _messages.add(data);
    }));
    socket.onDisconnect((_) => print('disconnect'));
  }

  void checkUrl() async {
    http.Response reponse = await http.get(Uri.parse('http://10.29.124.31:3000/'));
    print(reponse.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Socket"),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              _messages.clear();
            }),
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_messages[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      socket.emit('message', _controller.text);
    }

  }

  @override
  void dispose() {
    socket.dispose();
    _controller.dispose();
    super.dispose();
  }
}