class Message {
  late final String id;
  late final bool sentByHuman;
  late final String messagetext;

  Message.fromMap(this.id, Map<String, dynamic> map) {
    sentByHuman = map['sendbyhuman'] ?? (throw('No author in message$id'));
    messagetext = map['messagetext'] ?? (throw('No text in message$id'));
  }
}