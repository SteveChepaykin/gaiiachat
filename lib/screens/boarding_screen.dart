import 'package:flutter/material.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:gaiia_chat/screens/signin_screen.dart';
import 'package:gaiia_chat/widgets/specialelevatedbutton.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const CircleAvatar(
              // backgroundColor: secondary,
              backgroundImage: AssetImage('assets/blob.png'),
              radius: 90,
            ),
            const Spacer(),
            Text(
              'GAIIA AI',
              style: TextStyle(
                fontSize: 62,
                color: secondary,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'The Living Planet`s voice.',
              style: TextStyle(
                fontSize: 20,
                color: black,
                shadows: [
                  Shadow(
                    offset: Offset(0, 3),
                    blurRadius: 2,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            SpecialElevatedButton(
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SigninScreen(),
                  ),
                );
              },
              bg: secondary,
              fg: primary,
              child: const Text(
                'Get started',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SpecialElevatedButton(
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SigninScreen(),
                  ),
                );
              },
              bg: primary,
              fg: secondary,
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New Around here?',
                  style: TextStyle(color: black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: secondary,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
