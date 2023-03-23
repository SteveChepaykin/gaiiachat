import 'dart:math';
import 'dart:typed_data';
import 'package:gaiia_chat/controllers/http_controller.dart';
import 'package:gaiia_chat/models/message_model.dart';
import 'package:get/get.dart';


class LruCacheController extends GetxController {
  late final int _ssize;
  late final HttpController _cont;
  final Map<String, Uint8List> _audios = {};
  final Map<String, int> _dates = {};
  
  LruCacheController({required int size, required HttpController cont}) {
    _ssize = size;
    _cont = cont;
  }

  Future<Uint8List> getAudioFromCache(Message mes) async {
    if(_audios.keys.contains(mes.id)) {
      _dates[mes.id] = DateTime.now().millisecondsSinceEpoch;
      return _audios[mes.id]!;
    }
    var audio = await _cont.generateSpeechFromPhrase(mes.messagetext);
    if (_audios.length == _ssize) {
      _removeFromCache();
    }
    _audios[mes.id] = audio;
    _dates[mes.id] = DateTime.now().millisecondsSinceEpoch;
    return audio; 
  }

  void _removeFromCache() {
    String minId = '';
    int minmilliseconds = _dates.values.reduce((value, element) => min(value, element));
    for(var i in _dates.keys) {
      if(_dates[i] == minmilliseconds) {
        minId = i;
        break;
      }
    }
    _dates.remove(minId);
    _audios.remove(minId);
  }
}