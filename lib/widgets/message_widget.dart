import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/http_controller.dart';
import 'package:gaiia_chat/controllers/sharedpref_controller.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:gaiia_chat/resources/messages_demo.dart';
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
        child: GestureDetector(
          onLongPress: () {
            FlutterClipboard.copy(widget.message.messagetext);
            Get.snackbar(
              'Copied!',
              'Text copied succesfully.',
              duration: const Duration(
                seconds: 2,
              ),
            );
          },
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
                          padding: const EdgeInsets.all(4),
                          onPressed: () async {
                            if (widget.player.state != PlayerState.playing && widget.message.audioBytes != null) {
                              setState(() {
                                isSpeaking = true;
                              });
                              widget.player.play(BytesSource(widget.message.audioBytes!)).whenComplete(() {
                                setState(() {
                                  isSpeaking = false;
                                });
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.volume_up,
                            size: 18,
                          ),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
