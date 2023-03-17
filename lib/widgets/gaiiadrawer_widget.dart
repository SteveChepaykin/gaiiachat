import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:gaiia_chat/screens/account_screen.dart';
import 'package:gaiia_chat/screens/map_screen.dart';
import 'package:gaiia_chat/screens/settings_screen.dart';
import 'package:get/get.dart';

class GaiiaDrawer extends StatelessWidget {
  final Function() updateui;
  final MapController mapcontroller;
  const GaiiaDrawer({
    super.key,
    required this.updateui,
    required this.mapcontroller,
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
              Icons.map_rounded,
              color: secondary,
            ),
            title: const Text('Map'),
            onTap: () {
              Get.to(() => MapScreen(mapcontroller));
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
