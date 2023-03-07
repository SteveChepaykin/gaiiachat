import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaiia_chat/models/chatroom_model.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:gaiia_chat/models/user_model.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseController extends GetxController {
  late final FirebaseFirestore _firestore;

  UserModel? currentUser;
  late Rx<UserModel?> currentUser$;

  FirebaseController() {
    _firestore = FirebaseFirestore.instance;
    currentUser$ = currentUser.obs;
  }

  Future<UserModel> getUserByEmail(String email) async {
    var a = await _firestore.collection('people').where('email', isEqualTo: email).limit(1).get();
    return UserModel(a.docs[0].id, a.docs[0][0]);
  }

  Future<String?> signInUser(Map<String, String> m) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: m['email']!, password: m['password']!);
    } on FirebaseAuthException catch (_) {
      return 'loginerror';
    }
    var a = await _firestore.collection('people').where('email', isEqualTo: m['email']!).limit(1).get();
    var u = UserModel(a.docs[0].id, a.docs[0][0]);
    setCurrentUser(u);
    return null;
  }

  Future<String?> signInUserGoogle() async {
    final gsi = GoogleSignIn(
      clientId: '588301226396-8eh4l92na91ckfg6co4s8vcgh492uc60.apps.googleusercontent.com',
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    final GoogleSignInAccount? googleUser = await gsi.signIn();
    if (googleUser == null) return null;
    var a = await _firestore.collection('people').where('email', isEqualTo: googleUser.email).limit(1).get();
    if (a.docs.isEmpty) {
      return '## ${googleUser.email}';
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (_) {
      return 'login google error';
    }
    var u = UserModel(a.docs[0].id, a.docs[0][0]);
    setCurrentUser(u);
    return null;
  }

  Future<void> adduser(Map<String, dynamic> m) async {
    var q = await _firestore.collection('people').add({
      'email': m['email']!,
    });
    var z = await q.get();
    var u = UserModel(z.id, z.data()!['email']);
    setCurrentUser(u);
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
    setCurrentUser(null);
  }

  void setCurrentUser(UserModel? user) {
    currentUser = user;
    currentUser$.value = user;
  }

  void listenUserAuthState() {
    FirebaseAuth.instance.authStateChanges().listen(onUserAuthStateChange);
  }

  Future<void> onUserAuthStateChange(User? user) async {
    if (user != null) {
      var u = await getUserByEmail(user.email!);
      setCurrentUser(u);
    } else {
      setCurrentUser(null);
    }
  }

  Future<void> makeChatRoom() async {
    var a = _firestore.collection('chatrooms');
    await a.add(
      {
        'personid': currentUser!.id,
        'timecreated': DateTime.now(),
      },
    );
  }

  Future<bool> checkExistance() async {
    var a = await _firestore.collection('chatrooms').where('personid', isEqualTo: currentUser!.id).get();
    return a.docs.isNotEmpty;
  }

  Future<ChatRoom> getMyRoom() async {
    var a = await _firestore.collection('chatrooms').where('personid', isEqualTo: currentUser!.id).get();
    ChatRoom r = ChatRoom.fromMap(a.docs[0].id, a.docs[0].data());
    return r;
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
      lm.sort((m1, m2) {
        return m1.timeSent!.compareTo(m2.timeSent!);
      });
      return lm;
    });
  }
}
