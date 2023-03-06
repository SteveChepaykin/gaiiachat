import 'package:flutter/material.dart';
import 'package:gaiia_chat/resources/colors.dart';

class SpecialElevatedButton extends StatelessWidget {
  final Function() action;
  final Widget child;
  final Color fg;
  final Color bg;
  const SpecialElevatedButton({Key? key, required this.action, required this.child, this.bg = primary, this.fg = black}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          minimumSize: const Size.fromHeight(70),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: child);
  }
}
