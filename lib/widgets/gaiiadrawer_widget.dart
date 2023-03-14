import 'package:flutter/material.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:gaiia_chat/screens/account_screen.dart';
import 'package:gaiia_chat/screens/settings_screen.dart';
import 'package:get/get.dart';

class GaiiaDrawer extends StatelessWidget {
  final Function() updateui;
  const GaiiaDrawer({
    super.key,
    required this.updateui,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.person,
              color: secondary,
            ),
            title: const Text('Account'),
            onTap: () {
              Get.to(() => AccountScreen());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_rounded,
              color: secondary,
            ),
            title: const Text('Settings'),
            onTap: () {
              Get.to(() => const SettingsScreen())!.whenComplete(updateui);
            },
          ),
        ],
      ),
    );
  }
}
