import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/http_controller.dart';
import 'package:gaiia_chat/controllers/sharedpref_controller.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:get/get.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final AudioPlayer player;
  const MessageWidget(
    this.message,
    this.player, {
    Key? key,
  }) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool isSpeaking = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.message.sentByHuman ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: widget.message.sentByHuman
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(0),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
            color: widget.message.sentByHuman ? secondary : const Color.fromARGB(255, 236, 236, 236),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.message.messagetext.trim(),
                style: TextStyle(fontSize: 18, color: widget.message.sentByHuman ? primary : black),
              ),
              if (!widget.message.sentByHuman && !Get.find<SharedprefController>().isVoicing)
                isSpeaking
                    ? const CircularProgressIndicator()
                    : IconButton(
                      padding: EdgeInsets.all(4),
                        onPressed: () async {
                          setState(() {
                            isSpeaking = true;
                          });
                          Uint8List audio = await Get.find<HttpController>().generateSpeechFromPhrase(widget.message.messagetext);
                          if (widget.player.state != PlayerState.playing) {
                            widget.player.play(BytesSource(audio)).whenComplete(() {
                              setState(() {
                                isSpeaking = false;
                              });
                            });
                          }
                        },
                        icon: const Icon(Icons.volume_up, size: 18,),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
