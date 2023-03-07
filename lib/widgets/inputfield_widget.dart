import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:gaiia_chat/models/chatroom_model.dart';
// import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:get/get.dart';

class ChatInputField extends StatefulWidget {
  final ChatRoom cr;
  const ChatInputField({super.key, required this.cr});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  TextEditingController inputcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
                color: black.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(40)),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: inputcontroller,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type or speak your message...',
                    hintStyle: TextStyle(color: black.withOpacity(0.4), fontSize: 18),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Get.find<FirebaseController>().addMessage(
                    widget.cr,
                    {'messagetext': inputcontroller.text},
                  ).whenComplete(
                    () => inputcontroller.clear(),
                  );
                  // inputcontroller.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondary,
                  fixedSize: const Size(25, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
