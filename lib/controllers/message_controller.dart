
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gaiia_chat/models/geomark_model.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  List<GeoMark> messages = [];

  void addMessage(GeoMark gp) {
    messages.add(gp);
    // messages$.value = messages;
    // messages$.refresh();
  }
}
