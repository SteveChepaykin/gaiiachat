import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:gaiia_chat/models/geomark_model.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:gaiia_chat/widgets/specialelevatedbutton.dart';
import 'package:get/get.dart';

class MapScreen extends StatefulWidget {
  final MapController controller;
  const MapScreen(this.controller, {super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // late final MapController mapcont;
  late Timer? _timer;

  final TextEditingController geotextcont = TextEditingController();
  List<GeoMark> marks = [];

  @override
  void initState() {
    _timer = Timer(const Duration(milliseconds: 2000), () {
      getPointsFromFB().whenComplete(
        () => _timer?.cancel(),
      );
      // _timer?.cancel();
    });
    // mapcont = MapController(initMapWithUserPosition: true);
    widget.controller.listenerMapSingleTapping.addListener(onSingleTapping);
    super.initState();
  }

  Future<void> getPointsFromFB() async {
    List<GeoMark> fbmarks = await Get.find<FirebaseController>().getGeoMarks();
    for (GeoMark gp in fbmarks) {
      widget.controller.addMarker(gp.geoPoint);
    }
    marks = fbmarks;
  }

  @override
  void dispose() {
    widget.controller.listenerMapSingleTapping.removeListener(onSingleTapping);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
      ),
      body: OSMFlutter(
        controller: widget.controller,
        initZoom: 12,
        maxZoomLevel: 18,
        minZoomLevel: 6,
        isPicker: false,
        onGeoPointClicked: (point) {
          GeoMark m = marks.firstWhere(
            (element) => element.geoPoint == point,
          );
          Get.bottomSheet(
            BottomSheet(
              onClosing: () {
                // setState(() {});
              },
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20),
                child: Text(m.description),
              ),
            ),
          );
        },
      ),
    );
  }

  void onSingleTapping() {
    if (widget.controller.listenerMapSingleTapping.value != null) {
      Get.bottomSheet(
        BottomSheet(
          onClosing: () {
            // setState(() {});
          },
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: geotextcont,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                SpecialElevatedButton(
                  action: () async {
                    var gm = await Get.find<FirebaseController>().addGeoMark({
                      'lat': widget.controller.listenerMapSingleTapping.value!.latitude,
                      'lon': widget.controller.listenerMapSingleTapping.value!.longitude,
                      'desc': geotextcont.text,
                    });
                    widget.controller.addMarker(gm.geoPoint);
                    marks.add(gm);
                    Get.back();
                  },
                  child: const Text('Add geo mark'),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
