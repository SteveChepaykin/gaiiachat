import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late final String id;
  late final bool sentByHuman;
  late final String messagetext;
  late final DateTime timeSent;
  late final Uint8List? audioBytes;

  Message.fromMap(this.id, Map<String, dynamic> map) {
    sentByHuman = map['sentbyhuman'] ?? (throw ('No author in message$id'));
    messagetext = map['messagetext'] ?? (throw ('No text in message$id'));
    timeSent =
        map['timestamp'] != null ? DateTime.fromMicrosecondsSinceEpoch((map['timestamp'] as Timestamp).millisecondsSinceEpoch) : throw 'NEED DATETIME IN $id';
    audioBytes = map['audio'] != null ? Uint8List.fromList(map['audio']!) : null;
  }
}
