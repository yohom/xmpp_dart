import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:xmpp_stone/xmpp_stone.dart';

import 'login.screen.dart';

class ConversationsScreen extends StatefulWidget {
  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  List<MessageStanza> _messageList;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _messageList = [];
    _controller = TextEditingController();
    MessageHandler.getInstance(gConnection)
        .messagesStream
        .listen((event) => setState(() => _messageList..add(event)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('登录')),
      body: DecoratedColumn(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messageList.length,
              itemBuilder: (context, index) {
                final data = _messageList[index];
                return Card(
                  child: DecoratedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    padding: EdgeInsets.all(kSpace8),
                    children: [
                      Text(data.type.toString()),
                      Text(data.body),
                    ],
                  ),
                );
              },
            ),
          ),
          DecoratedRow(
            safeArea: SafeAreaConfig(),
            children: [
              Expanded(child: TextField(controller: _controller)),
              RaisedButton(onPressed: _handleSend, child: Text('发送')),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    MessageHandler.getInstance(gConnection)
        .sendMessage(Jid.fromFullJid(gPeerId), _controller.text);
  }
}
