import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _accountController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController(text: 'user003@xmpp.tuobaye.cn');
    _passwordController = TextEditingController(text: '123456');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('登录')),
      body: DecoratedColumn(
        padding: EdgeInsets.all(kSpace16),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(controller: _accountController),
          TextFormField(controller: _passwordController),
          SPACE_24_VERTICAL,
          RaisedButton(onPressed: _handleLogin, child: Text('登录')),
        ],
      ),
    );
  }

  void _handleLogin() {
    final jid = xmpp.Jid.fromFullJid(_accountController.text);
    final account = xmpp.XmppAccountSettings(
      _accountController.text,
      jid.local,
      jid.domain,
      _passwordController.text,
      5222,
      resource: 'xmppstone',
    );
    final connection = xmpp.Connection(account)
      ..connect()
      ..connectionStateStream.listen((event) => L.d('链接状态: $event'));
    xmpp.MessageHandler.getInstance(connection)
        .messagesStream
        .listen((event) => L.d('收到消息: $event'));
    xmpp.PresenceManager.getInstance(connection)
        .presenceStream
        .listen((event) => L.d('收到上线消息: $event'));
  }
}
