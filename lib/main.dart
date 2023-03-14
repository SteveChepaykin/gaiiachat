import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:gaiia_chat/controllers/http_controller.dart';
import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gaiia_chat/controllers/sharedpref_controller.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  
  var mescont = MessageController();
  var fcont = FirebaseController();
  var httpcont = HttpController();
  var prefcont = SharedprefController();
  // fcont.listenUserAuthState();
  mescont.init();
  await prefcont.init();
  Get.put<MessageController>(mescont);
  Get.put<FirebaseController>(fcont);
  Get.put<HttpController>(httpcont);
  Get.put<SharedprefController>(prefcont);
  // final ap = AudioPlayer();
  // Uint8List audio = await httpcont.generateSpeechFromPhrase('HELLO');
  // ap.play(BytesSource(audio));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.find<FirebaseController>().listenUserAuthState();
    });
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Actor'
      ),
      debugShowCheckedModeBanner: false,
      home: Placeholder(),
      // home: StreamBuilder<UserModel?>(
      //   stream: Get.find<FirebaseController>().currentUser$.stream,
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       // return const LogInScreen();
      //       return const BoardingScreen();
      //     } else {
      //       return const ConversationScreen();
      //     }
      //   },
      // ),
    );
  }
}
