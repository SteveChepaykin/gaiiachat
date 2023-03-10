// import 'package:chat_gpt_api/chat_gpt.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:gaiia_chat/models/chatroom_model.dart';
import 'package:gaiia_chat/resources/api.dart';
// import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:gaiia_chat/screens/conversation_screen.dart';
import 'package:get/get.dart';

class ChatInputField extends StatefulWidget {
  final ChatRoom cr;
  const ChatInputField({super.key, required this.cr});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  TextEditingController inputcontroller = TextEditingController();

  final openAi = OpenAI.instance.build(token: apiKey);

  bool waitingAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (waitingAnswer)
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'GAIIA thinks...',
                    style: TextStyle(
                      color: black.withOpacity(0.4),
                      fontSize: 18,
                    ),
                  ),
                ),
              const Spacer(),
              const SpecialChip(text: 'Flag'),
              const SizedBox(
                width: 15,
              ),
              const SpecialChip(text: 'Reply'),
              const SizedBox(
                width: 15,
              ),
              const SpecialChip(text: 'Forward')
            ],
          ),
        ),
        SizedBox(
          height: 100,
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
                      enabled: !waitingAnswer,
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
                    onPressed: waitingAnswer ? null : () async {
                      setState(() {
                        waitingAnswer = true;
                      });
                      Get.find<FirebaseController>()
                          .addMessage(
                        widget.cr,
                        {'messagetext': inputcontroller.text},
                        openAi,
                      )
                          .whenComplete(
                        () {
                          setState(() {
                            waitingAnswer = false;
                            inputcontroller.clear();
                          });
                        },
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
        ),
      ],
    );
  }
}
