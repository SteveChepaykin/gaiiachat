import 'dart:convert';
import 'dart:typed_data';
import 'package:gaiia_chat/controllers/sharedpref_controller.dart';
import 'package:gaiia_chat/resources/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HttpController extends GetxController {
  static const baseUrl = 'https://api.elevenlabs.io/v1';

  Future<List<Map<String, dynamic>>> getVoices() async {
    var response = await http.get(Uri.parse('$baseUrl/voices'), headers: {
      'xi-api-key': elevenLabsApiKey,
    });
    var decresponse = json.decode(response.body);
    List<Map<String, dynamic>> res = [];
    for (var map in decresponse['voices']) {
      res.add({
        'voiceId': map['voice_id'],
        'name': map['name'],
        'samples': map['samples'],
      });
    }
    return res;
  }

  //Merlin: bmtTy0kLjUiTeam6zbRp

  Future<Uint8List> generateSpeechFromPhrase(String message) async {
    var response = await http.post(Uri.parse('$baseUrl/text-to-speech/${Get.find<SharedprefController>().voiceId}'), headers: {
      'xi-api-key': elevenLabsApiKey,
      'content-type': 'application/json',
      'accept': 'audio/mpeg',
    }, body: json.encode({
      "text": message,
      "voice_settings": {
        "stability": 0,
        "similarity_boost": 0,
      },
    }));

    Uint8List audioresponse = response.bodyBytes;
    return audioresponse;
  }
}
