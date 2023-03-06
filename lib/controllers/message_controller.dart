import 'package:gaiia_chat/models/message_model.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  List<Message> messages = [];
  late var messages$ = messages.obs;

  void init() {
    messages.addAll([
      Message.fromMap('0', {'sendbyhuman': false, 'messagetext': 'Hi, Paolo. How can I help you?'}),
      Message.fromMap('1', {'sendbyhuman': true, 'messagetext': 'Hi GAIIA please send me presentation about innovative GAIIA Charity tools'}),
      Message.fromMap('2', {'sendbyhuman': false, 'messagetext': 'Sure. Sending...'}),
    ]);
    messages$.value = messages;
    messages$.refresh();
  }

  void addMessage(String text) {
    var message = Message.fromMap(messages.length.toString(), {'sendbyhuman': true, 'messagetext': text});
    messages.add(message);
    messages$.value = messages;
    messages$.refresh();
  }
}
