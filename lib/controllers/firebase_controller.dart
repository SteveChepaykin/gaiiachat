import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gaiia_chat/models/chatroom_model.dart';
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
  // late Rx<UserModel?> currentUser$;
  // late Rx<ChatRoom?> currentRoom$;

  FirebaseController() {
    _firestore = FirebaseFirestore.instance;
    _firebaseAuth = FirebaseAuth.instance;
    // currentUser$ = currentUser.obs;
    // currentRoom$ = currentRoom.obs;
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
      clientId: '588301226396-8eh4l92na91ckfg6co4s8vcgh492uc60.apps.googleusercontent.com',
      // serverClientId: '588301226396-8eh4l92na91ckfg6co4s8vcgh492uc60.apps.googleusercontent.com',
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
    // var user = await getUserByEmail(googleUser.email);
    // user ??= await addUser(googleUser.email);
    // var room = await getMyRoom(user);
    // room ??= await makeChatRoom(user);
    // currentRoom = room;
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
    // if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink)) {
    if(link != null) {
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

  Future<void> addMessage(ChatRoom cr, Map<String, dynamic> m) async {
    var a = _firestore.collection('chatrooms').doc(cr.id);
    // http.Response response = await http.get(Uri.parse("http://worldtimeapi.org/api/timezone/Europe/London"));
    // var file = jsonDecode(response.body);
    await a.collection('messages').add({
      'sentbyhuman': true,
      'messagetext': m['messagetext'],
      'timestamp': DateTime.now(),
    });
  }

  Stream<List<Message>> getRoomMessages(ChatRoom cr) {
    return _firestore.collection('chatrooms').doc(cr.id).collection('messages').snapshots().map((event) {
      List<Message> lm = [];
      for (var m in event.docs) {
        var mes = Message.fromMap(m.id, m.data());
        lm.add(mes);
      }
      // if (lm.length >= 2) {
      lm.sort((m1, m2) {
        return m1.timeSent.compareTo(m2.timeSent);
      });
      // }
      return lm;
    });
  }
}
