import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/sharedpref_controller.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>  SettingsScreenState();
}

class  SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final prefcont = Get.find<SharedprefController>();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Auto voicing'),
            Switch.adaptive(value: prefcont.isVoicing, onChanged: (value) {
              setState(() {
                prefcont.setVoicing(value);
              });
            })
          ],
        ),
      ),
    );
  }
}