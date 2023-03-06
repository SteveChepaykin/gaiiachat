import 'package:flutter/material.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/resources/colors.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sentByHuman ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: message.sentByHuman
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
            color: message.sentByHuman ? secondary : primary,
          ),
          padding: const EdgeInsets.all(15),
          child: Text(
            message.messagetext,
            style: TextStyle(fontSize: 18, color: message.sentByHuman ? primary : black),
          ),
        ),
      ),
    );
  }
}
