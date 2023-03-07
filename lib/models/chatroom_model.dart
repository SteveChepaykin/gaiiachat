import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  late final String personId;
  late final DateTime? timeCreated;
  // late DateTime? lastmessageTS;
  // late String? lastmessagesenderID;
  // late String? lastmessage;

  ChatRoom.fromMap(this.id, Map<String, dynamic> map,) {
    // purpose = map['purpose'] != null ? prps((map['purpose'] as double).round()) : throw 'NEED PURPOSE IN CHAT $id';
    
    personId = map['personid'] ?? (throw 'NO PERSON IN ROOM $id');
    timeCreated = map['timecreated'] != null ? DateTime.fromMicrosecondsSinceEpoch((map['timecreated'] as Timestamp).millisecondsSinceEpoch) : null; 
    // lastmessage = lm;
  }
}