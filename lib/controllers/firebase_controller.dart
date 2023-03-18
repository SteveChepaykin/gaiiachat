import 'dart:async';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaiia_chat/controllers/http_controller.dart';
import 'package:gaiia_chat/controllers/sharedpref_controller.dart';
import 'package:gaiia_chat/models/chatroom_model.dart';
import 'package:gaiia_chat/models/geomark_model.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/models/user_model.dart';
import 'package:gaiia_chat/screens/boarding_screen.dart';
import 'package:gaiia_chat/screens/conversation_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseController extends GetxController {
  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _firebaseAuth;

  UserModel? currentUser;
  ChatRoom? currentRoom;

  FirebaseController() {
    _firestore = FirebaseFirestore.instance;
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    var query = await _firestore.collection('people').where('email', isEqualTo: email).limit(1).get();
    if (query.docs.isEmpty) return null;
    return UserModel(query.docs[0].id, query.docs[0].data());
  }

  // Future<String?> signInUser(Map<String, String> m) async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(email: m['email']!, password: m['password']!);
  //   } on FirebaseAuthException catch (_) {
  //     return 'loginerror';
  //   }
  //   var a = await _firestore.collection('people').where('email', isEqualTo: m['email']!).limit(1).get();
  //   var u = UserModel(a.docs[0].id, a.docs[0].data());
  //   setCurrentUser(u);
  //   return null;
  // }

  Future<String?> signInUserGoogle() async {
    final gsi = GoogleSignIn(
      // clientId: '588301226396-8eh4l92na91ckfg6co4s8vcgh492uc60.apps.googleusercontent.com',
      serverClientId: '588301226396-8eh4l92na91ckfg6co4s8vcgh492uc60.apps.googleusercontent.com',
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    final GoogleSignInAccount? googleUser = await gsi.signIn();
    if (googleUser == null) return 'login google error';
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (_) {
      return 'login google error';
    }
    return null;
  }

  // Future<void> signInUserBySMS(String number) async {
  //   if (kIsWeb) {
  //     ConfirmationResult confirmationResult = await _firebaseAuth.signInWithPhoneNumber(number);
  //     String? smscode = '';
  //     Get.to<String>(() => const SMSCodeScreen())!.then((value) {
  //       smscode = value;
  //     });
  //     if (smscode != null) {
  //       UserCredential credential = await confirmationResult.confirm(smscode!);
  //       // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smscode!);
  //       _firebaseAuth.signInWithCredential(credential);
  //     }
  //   } else {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: number,
  //       timeout: const Duration(seconds: 60),
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         try {
  //           await _firebaseAuth.signInWithCredential(credential);
  //         } on FirebaseAuthException catch (_) {
  //           print('login google error');
  //         }
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         Get.showSnackbar(const GetSnackBar(
  //           message: 'There was an error, login failed',
  //         ));
  //       },
  //       codeSent: (String verificationId, int? resendToken) async {
  //         String? smscode = '';
  //         Get.to<String>(() => const SMSCodeScreen())!.then((value) {
  //           smscode = value;
  //         });
  //         if (smscode != null) {
  //           PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smscode!);
  //           _firebaseAuth.signInWithCredential(credential);
  //         }
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //     );
  //   }
  // }

  Future<void> signInUserEmailLink(String email) async {
    var acs = ActionCodeSettings(
      url: 'https://gaiiachat.page.link/',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.gaiia_chat',
      androidPackageName: 'com.example.gaiia_chat',
      androidInstallApp: true,
      androidMinimumVersion: '19',
    );

    _firebaseAuth
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError((onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  Future<void> handleLink(Uri? link, String email) async {
    if (link != null) {
      try {
        await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link.toString());
        print('Successfully signed in with email link!');
      } catch (error) {
        print('Error signing in with email link.');
      }
    }
  }

  Future<UserModel> addUser(String email) async {
    var userlink = await _firestore.collection('people').add({
      'email': email,
    });
    var doc = await userlink.get();
    var user = UserModel(doc.id, doc.data()!);
    return user;
  }

  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }

  void setCurrentUser(UserModel? user) {
    currentUser = user;
    if (user == null) {
      Get.offAll(() => const BoardingScreen());
    } else {
      Get.offAll(() => const ConversationScreen());
    }
  }

  void listenUserAuthState() {
    _firebaseAuth.authStateChanges().distinct().listen(onUserAuthStateChange);
  }

  Future<void> onUserAuthStateChange(User? googleUser) async {
    if (googleUser != null) {
      var user = await getUserByEmail(googleUser.email!);
      user ??= await addUser(googleUser.email!);
      ChatRoom? room = await getMyRoom(user);
      room ??= await makeChatRoom(user);
      currentRoom = room;
      setCurrentUser(user);
    } else {
      setCurrentUser(null);
    }
  }

  Future<ChatRoom> makeChatRoom(UserModel user) async {
    var doclink = await _firestore.collection('chatrooms').add(
      {
        'personid': user.id,
        'timecreated': DateTime.now(),
      },
    );

    var doc = await doclink.get();
    return ChatRoom.fromMap(doc.id, doc.data()!);
  }

  // Future<bool> checkRoomExistance(UserModel u) async {
  //   var a = await _firestore.collection('chatrooms').where('personid', isEqualTo: u.id).get();
  //   return a.docs.isNotEmpty;
  // }

  Future<ChatRoom?> getMyRoom(UserModel user) async {
    var a = await _firestore.collection('chatrooms').where('personid', isEqualTo: user.id).get();
    if (a.docs.isEmpty) return null;
    ChatRoom room = ChatRoom.fromMap(a.docs[0].id, a.docs[0].data());
    return room;
  }

  Future<void> addMessage(
    ChatRoom cr,
    Map<String, dynamic> messagemap,
    OpenAI? openai,
    AudioPlayer player,
    // ChatGPT? chatgpt,
  ) async {
    var a = _firestore.collection('chatrooms').doc(cr.id);
    await a.collection('messages').add({
      'sentbyhuman': true,
      'messagetext': messagemap['messagetext'],
      'timestamp': DateTime.now(),
    });

    // var completion = await chatgpt!.textCompletion(
    //   request: CompletionRequest(
    //     prompt: messagemap['messagetext'],
    //     maxTokens: 100,
    //   ),
    // );

    // await a.collection('messages').add({
    //   'sentbyhuman': false,
    //   'messagetext': completion!.choices!.first.text,
    //   'timestamp': DateTime.now(),
    // });

    var roommes = await getRoomLastMessages(cr);
    var messages = roommes
        .map((message) => {
              'role': message.sentByHuman ? 'user' : 'assistant',
              'content': message.messagetext,
            })
        .toList();

    messages.insert(0, {
      'role': 'system',
      'content': 'You are a helpful assistant. Your name is GAIIA.',
    });

    // var request = ChatCompleteText(
    //   messages: messages,
    //   model: kChatGptTurbo0301Model,
    //   maxToken: 200,
    // );

    // var completion;

    // try {
    //   completion = await openai!.onChatCompletion(request: request);
    // } catch (e) {
    //   print(e);
    // }

    var response = await Get.find<HttpController>().completeChat(messages);

    Uint8List? messageAudio;
    if (Get.find<SharedprefController>().isVoicing) {
      // messageAudio = await Get.find<HttpController>().generateSpeechFromPhrase(completion!.choices.first.message.content);
      messageAudio = await Get.find<HttpController>().generateSpeechFromPhrase(response);

    }

    await a.collection('messages').add({
      'sentbyhuman': false,
      // 'messagetext': completion!.choices.first.message.content,
      'messagetext': response,
      'timestamp': DateTime.now(),
    });
    if (messageAudio != null) {
      player.play(BytesSource(messageAudio));
    }
  }

  Stream<List<Message>> getRoomMessagesStream(ChatRoom cr) {
    return _firestore.collection('chatrooms').doc(cr.id).collection('messages').snapshots().map((event) {
      List<Message> lm = [];
      for (var m in event.docs) {
        var mes = Message.fromMap(m.id, m.data());
        lm.add(mes);
      }
      // if (lm.length >= 2) {
      lm.sort((m1, m2) {
        return m2.timeSent.compareTo(m1.timeSent);
      });
      // }
      return lm;
    });
  }

  Future<List<Message>> getRoomLastMessages(ChatRoom cr) async {
    var docs = await _firestore.collection('chatrooms')
      .doc(cr.id).collection('messages')
      .orderBy('timestamp')
      .limitToLast(10)
      .get();
    var messages = docs.docs.map((e) => Message.fromMap(e.id, e.data())).toList();
    // messages.sort((m1, m2) {
    //   return m1.timeSent.compareTo(m2.timeSent);
    // });
    return messages;
  }

  Future<GeoMark> addGeoMark(Map<String, dynamic> map) async {
    var doc = await _firestore.collection('geomarks').add({
      'lat': map['lat'],
      'lon': map['lon'],
      'description': map['desc'],
    });
    var d = await doc.get();
    GeoMark gm = GeoMark(d.id, d.data()!);
    return gm;
  }

  Future<List<GeoMark>> getGeoMarks() async {
    var docs = await _firestore.collection('geomarks').get();
    var marks = docs.docs.map((e) => GeoMark(e.id, e.data())).toList();
    return marks;
  }
}
