import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedprefController extends GetxController {
  late bool isVoicing;
  late String voiceId;

  static const String voicingKey = 'isVoicing';
  static const String voiceKey = 'voice';

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isVoicing = getVoicing()!;
    voiceId = getVoice()!;
  }

  Future<void> setVoicing(bool newValue) {
    isVoicing = newValue;
    return prefs.setBool(voicingKey, newValue);
  }

  Future<void> setVoice(String newValue) {
    voiceId = newValue;
    return prefs.setString(voiceKey, newValue);
  }

  bool? getVoicing() {
    return prefs.containsKey(voicingKey) ? prefs.getBool(voicingKey) : false;
  }

  String? getVoice() {
    return prefs.containsKey(voiceKey) ? prefs.getString(voiceKey) : 'EXAVITQu4vr4xnSDxMaL';
  }
}