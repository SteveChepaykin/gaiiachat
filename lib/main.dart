import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:gaiia_chat/screens/boarding_screen.dart';
import 'package:gaiia_chat/screens/conversation_screen.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var mescont = MessageController();
  mescont.init();
  Get.put<MessageController>(mescont);
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
      home: ConversationScreen(),
    );
  }
}
