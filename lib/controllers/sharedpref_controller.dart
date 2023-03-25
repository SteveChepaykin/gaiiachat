import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class SharedprefController extends GetxController {
  late bool isVoicing;
  late String voiceId;
  late Position initPos;

  static const String voicingKey = 'isVoicing';
  static const String voiceKey = 'voice';

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isVoicing = getVoicing()!;
    voiceId = getVoice()!;
    initPos = await _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
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
