import 'dart:io';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:xmpp_stone/xmpp_stone.dart';
import 'package:xmpp_stone_example/src/ui/conversations.screen.dart';

Connection gConnection;
String gAccount =
    Platform.isAndroid ? 'user003@xmpp.tuobaye.cn' : 'yohom@xmpp.tuobaye.cn';
String gPassword = Platform.isAndroid ? '123456' : 'yohom123456';

String gPeerId = Platform.isAndroid
    ? 'yohom@openfire.tuobaye.cn'
    : 'user003@openfire.tuobaye.cn';

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
    _accountController = TextEditingController(text: gAccount);
    _passwordController = TextEditingController(text: gPassword);
  }

  @override
  void reassemble() {
    super.reassemble();
    gConnection?.close();
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
    final jid = Jid.fromFullJid(_accountController.text);
    final account = XmppAccountSettings(
      _accountController.text,
      jid.local,
      jid.domain,
      _passwordController.text,
      5222,
      resource: 'xmppstone',
    );
    gConnection = Connection(account)
      ..connect()
      ..connectionStateStream.listen((event) {
        switch (event) {
          case XmppConnectionState.Authenticated:
            context.rootNavigator.push(
              MaterialPageRoute(builder: (context) => ConversationsScreen()),
            );
            break;
          case XmppConnectionState.AuthenticationFailure:
            toast('登录失败');
            break;
          default:
            break;
        }
      });
    PresenceManager.getInstance(gConnection)
        .presenceStream
        .listen((event) => L.d('收到上线消息: $event'));
  }
}
