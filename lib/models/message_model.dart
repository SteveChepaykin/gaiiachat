import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late final String id;
  late final bool sentByHuman;
  late final String messagetext;
  late final DateTime? timeSent;

  Message.fromMap(this.id, Map<String, dynamic> map) {
    sentByHuman = map['sendbyhuman'] ?? (throw ('No author in message$id'));
    messagetext = map['messagetext'] ?? (throw ('No text in message$id'));
    timeSent = map['timestamp'] != null ? DateTime.fromMicrosecondsSinceEpoch((map['timestamp'] as Timestamp).millisecondsSinceEpoch) : null;
  }
}
