import 'package:xmpp_stone/src/data/Jid.dart';
import 'package:xmpp_stone/src/elements/stanzas/MessageStanza.dart';

abstract class MessageApi {
  MessageStanza sendMessage(Jid to, String text);
}
