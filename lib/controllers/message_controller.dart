
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  List<GeoPoint> messages = [];

  void addMessage(GeoPoint gp) {
    messages.add(gp);
    // messages$.value = messages;
    // messages$.refresh();
  }
}
