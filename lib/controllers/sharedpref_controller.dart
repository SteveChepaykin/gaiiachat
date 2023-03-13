import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedprefController extends GetxController {
  late bool isVoicing;

  static const String voicingKey = 'isVoicing';

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isVoicing = getVoicing()!;
  }

  Future<void> setVoicing(bool newValue) {
    return prefs.setBool(voicingKey, newValue);
  }

  bool? getVoicing() {
    return prefs.containsKey(voicingKey) ? prefs.getBool(voicingKey) : false;
  }
}