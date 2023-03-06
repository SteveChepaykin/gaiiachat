import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/widgets/message_widget.dart';
import 'package:get/get.dart';

import '../resources/colors.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController inputcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Column(
          children: [
            const CircleAvatar(
              // backgroundColor: secondary,
              backgroundImage: AssetImage('images/blob.png'),
              radius: 40,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'GAIIA AI',
              style: TextStyle(
                fontSize: 52,
                color: secondary,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  var messages = Get.find<MessageController>().messages$;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) => MessageWidget(
                      messages[index],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  SpecialChip(text: 'Flag'),
                  SizedBox(
                    width: 15,
                  ),
                  SpecialChip(text: 'Reply'),
                  SizedBox(
                    width: 15,
                  ),
                  SpecialChip(text: 'Forward')
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: black.withOpacity(0.3),),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: inputcontroller,
                          style: const TextStyle(fontSize: 18,),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type or speak your message...',
                            hintStyle: TextStyle(color: black.withOpacity(0.4), fontSize: 18),
                            contentPadding: const EdgeInsets.all(15),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.find<MessageController>().addMessage(inputcontroller.text);
                          inputcontroller.clear();
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
            )
          ],
        ),
      ),
    );
  }
}

class SpecialChip extends StatelessWidget {
  final String text;
  const SpecialChip({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(fontSize: 18, color: secondary),
      ),
      backgroundColor: Colors.transparent,
      side: const BorderSide(color: secondary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
    );
  }
}
