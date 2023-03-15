import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/sharedpref_controller.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  List<Map<String, dynamic>> voices = [
    {'name': 'Bella', 'id': 'EXAVITQu4vr4xnSDxMaL'},
    {'name': 'Josh', 'id': 'TxGEqnHWrfWFTfGW9XjX'},
  ];
  late String currentVoice;

  @override
  void initState() {
    currentVoice = Get.find<SharedprefController>().getVoice()!;
    super.initState();
  }

  void setCurrentVoice(String newvoice) async {
    setState(() {
      currentVoice = newvoice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefcont = Get.find<SharedprefController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            functionalRow(
              'Auto voicing',
              Switch.adaptive(
                value: prefcont.isVoicing,
                activeColor: secondary,
                onChanged: (value) {
                  setState(() {
                    prefcont.setVoicing(value);
                  });
                },
              ),
            ),
            functionalRow(
                'Voice',
                DropdownButton<String?>(
                  value: currentVoice,
                  items: [
                    ...voices.map(
                      (e) => DropdownMenuItem(
                        value: e['id'],
                        child: Text(
                          e['name'],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                  onChanged: (value) async {
                    await Get.find<SharedprefController>().setVoice(value!);
                    setCurrentVoice(value);
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget functionalRow(String label, Widget child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 20),
          ),
          child,
        ],
      ).paddingSymmetric(
        vertical: 4,
      );
}
