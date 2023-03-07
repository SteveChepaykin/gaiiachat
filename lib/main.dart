import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:gaiia_chat/models/user_model.dart';
import 'package:gaiia_chat/screens/boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gaiia_chat/screens/conversation_screen.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var mescont = MessageController();
  var fcont = FirebaseController();
  fcont.listenUserAuthState();
  mescont.init();
  Get.put<MessageController>(mescont);
  Get.put<FirebaseController>(fcont);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<UserModel?>(
          stream: Get.find<FirebaseController>().currentUser$.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // return const LogInScreen();
              return const BoardingScreen();
            }
            return const ConversationScreen();
          },
        ),
    );
  }
}
