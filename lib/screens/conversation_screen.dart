// import 'dart:html';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/widgets/gaiiadrawer_widget.dart';
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
  final FirebaseController fc = Get.find<FirebaseController>();
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(143),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           const CircleAvatar(
      //             backgroundImage: AssetImage('assets/blob.png'),
      //             radius: 40,
      //           ),
      //           const SizedBox(
      //             height: 8,
      //           ),
      //           Text(
      //             'GAIIA',
      //             style: TextStyle(
      //               fontSize: 52,
      //               color: secondary,
      //               shadows: [
      //                 Shadow(
      //                   offset: const Offset(0, 4),
      //                   blurRadius: 4,
      //                   color: Colors.grey.shade400,
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ).paddingOnly(top: 10, left: 20),
      //       IconButton(
      //         onPressed: () async {
      //           await fc.signOutUser();
      //         },
      //         icon: const Icon(
      //           Icons.logout,
      //           color: secondary,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: secondary),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/blob.png'),
              radius: 25,
            ),
            const SizedBox(
              width: 8,
            ),
            Text.rich(
              const TextSpan(children: [
                TextSpan(
                  text: 'G',
                  style: TextStyle(
                    color: secondary,
                  ),
                ),
                TextSpan(text: 'A', style:  TextStyle(
                    color: Color(0xFF2FD4FA),
                  ),),
                TextSpan(text: 'I', style: TextStyle(
                    color: Color(0xFF0AFAA2),
                  ),),
                TextSpan(text: 'IA', style: TextStyle(
                    color: secondary,
                  ),)
              ]),
              // 'GAIIA',
              style: TextStyle(
                fontSize: 42,
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
      endDrawer: GaiiaDrawer(
        updateui: () {
          setState(() {});
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: Get.find<FirebaseController>().getRoomMessagesStream(fc.currentRoom!),
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
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageWidget(
                        messages[index],
                        audioPlayer,
                      );
                    },
                  );
                },
              ),
            ),
            ChatInputField(cr: fc.currentRoom!, ap: audioPlayer),
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
