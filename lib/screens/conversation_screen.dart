// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:gaiia_chat/models/chatroom_model.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/resources/messages_demo.dart';
// import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/widgets/inputfield_widget.dart';
import 'package:gaiia_chat/widgets/message_widget.dart';
import 'package:get/get.dart';

import '../resources/colors.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  // late final ChatRoom thisroom;
  final FirebaseController fc = Get.find<FirebaseController>();

  // @override
  // void initState() {
  //   var firestore = Get.find<FirebaseController>();
  //   // bool created = await firestore.checkExistance();
  //   // if (!created) {
  //   //   await firestore.makeChatRoom();
  //   // }
  //   // thisroom = await firestore.getMyRoom();

  //   // firestore.checkExistance().then((value) {
  //   //   if (!value) {
  //   //     firestore.makeChatRoom().whenComplete(() {
  //   //       firestore.getMyRoom().then((value) {
  //   //         thisroom = value;
  //   //       });
  //   //     });
  //   //   } else {
  //   //     firestore.getMyRoom().then((value) {
  //   //       thisroom = value;
  //   //     });
  //   //   }
  //   // });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(190),
        child: Column(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/blob.png'),
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
            IconButton(onPressed: () async {
              await fc.signOutUser();
            }, icon: Icon(Icons.logout))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              // child: Obx(
              //   () {
              //     var messages = Get.find<MessageController>().messages$;
              //     return ListView.builder(
              //       itemCount: messages.length,
              //       itemBuilder: (context, index) => MessageWidget(
              //         messages[index],
              //       ),
              //     );
              //   },
              // ),
              child: StreamBuilder<List<Message>>(
                stream: Get.find<FirebaseController>().getRoomMessages(fc.currentRoom!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('No messages here yet.'));
                  }
                  List<Message> messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageWidget(
                        messages[index],
                      );
                    },
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
            ChatInputField(cr: fc.currentRoom!),
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
