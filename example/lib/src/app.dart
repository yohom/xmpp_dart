import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:xmpp_stone_example/src/ui/login.screen.dart';

class IMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => Form(child: AutoCloseKeyboard(child: child)),
      home: LoginScreen(),
    );
  }
}
