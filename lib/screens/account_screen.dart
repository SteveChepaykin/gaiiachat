import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:get/get.dart';

import '../resources/colors.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final fc = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await fc.signOutUser();
            },
            icon: const Icon(
              Icons.logout,
              color: secondary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Your email:'),
              Text(
                fc.currentUser!.email,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
