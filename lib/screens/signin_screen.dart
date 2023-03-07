import 'package:flutter/material.dart';
import 'package:gaiia_chat/screens/conversation_screen.dart';
import 'package:gaiia_chat/widgets/specialelevatedbutton.dart';

import '../resources/colors.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            const Text(
              'Sign in',
              style: TextStyle(
                fontSize: 36,
                color: black,
                shadows: [
                  Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 2,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const Spacer(),
            SpecialElevatedButton(
              action: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ConversationScreen()));
              },
              child: Row(
                children: const [
                  Icon(Icons.apple),
                  Spacer(),
                  Text(
                    'Sign in with Apple',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SpecialElevatedButton(
                action: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ConversationScreen()));
                },
                child: Row(
                  children: const [
                    Icon(Icons.keyboard_command_key_rounded),
                    Spacer(),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    Spacer(),
                  ],
                )),
            const Spacer(),
            Text(
              'or get a link emailed to you',
              style: TextStyle(
                fontSize: 20,
                color: black.withOpacity(0.4),
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primary,
                // boxShadow: [
                //   BoxShadow(
                //     offset: Offset(0, 4),
                //     blurRadius: 8,
                //   )
                // ]
              ),
              child: TextField(
                maxLines: 1,
                controller: emailcontroller,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Work email adress',
                    hintStyle: TextStyle(color: black.withOpacity(0.4), fontSize: 20),
                    contentPadding: const EdgeInsets.all(25)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SpecialElevatedButton(
              action: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ConversationScreen()));
              },
              bg: secondary,
              fg: primary,
              child: const Text(
                'Send me a signup link',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              thickness: 1.5,
            ),
            const Spacer(),
            const Text(
              'You are completely safe.',
              style: TextStyle(
                fontSize: 15,
                color: black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See our Terms & Conditions.',
                style: TextStyle(
                  color: secondary,
                  fontSize: 15,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
