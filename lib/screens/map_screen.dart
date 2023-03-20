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
  // final String filter;
  const MapScreen(this.controller, {super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // late final MapController mapcont;
  late Timer? _timer;
  final TextEditingController geotextcont = TextEditingController();
  List<GeoMark> marks = [];
  String filter = 'all';
  bool canreload = false;

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
    canreload = true;
  }

  @override
  void dispose() {
    widget.controller.listenerMapSingleTapping.removeListener(onSingleTapping);
    super.dispose();
  }

  // Color markerColor(String f) {
  //   switch (f) {
  //     case 'information':
  //       return Colors.red;
  //     case 'ecological':
  //       return Colors.green;
  //     case 'social':
  //       return Colors.blue;
  //     default:
  //       return Colors.black;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Color clr = markerColor(filter);
    List<GeoMark> filteredmarks = marks;
    if (canreload) {
      List<GeoMark> filteredmarks = filter != 'all'
          ? marks
              .where(
                (gm) => gm.layer == filter,
              )
              .toList()
          : marks;
      widget.controller.removeMarkers(marks.map((e) => e.geoPoint).toList());
      for (GeoMark gp in filteredmarks) {
        widget.controller.addMarker(gp.geoPoint);
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButton<String>(
                value: filter,
                items: const [
                  DropdownMenuItem(
                    value: 'all',
                    child: Text('all'),
                  ),
                  DropdownMenuItem(
                    value: 'information',
                    child: Text('information'),
                  ),
                  DropdownMenuItem(
                    value: 'ecological',
                    child: Text('ecological'),
                  ),
                  DropdownMenuItem(
                    value: 'social',
                    child: Text('social'),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    filter = v!;
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: OSMFlutter(
        controller: widget.controller,
        initZoom: 12,
        maxZoomLevel: 18,
        minZoomLevel: 2,
        isPicker: false,
        markerOption: MarkerOption(
          defaultMarker: const MarkerIcon(
            icon: Icon(
              Icons.place,
              color: Colors.red,
            ),
          ),
        ),
        onGeoPointClicked: (point) {
          GeoMark m = filteredmarks.firstWhere(
            (element) => element.geoPoint == point,
          );
          Get.bottomSheet(
            BottomSheet(
              onClosing: () {
                // setState(() {});
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                  ],
                ),
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
            geotextcont.clear();
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: geotextcont,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Describe what you found....',
                  ),
                  maxLines: 5,
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
                      'layer': filter == 'all' ? 'information' : filter
                    });
                    widget.controller.addMarker(gm.geoPoint);
                    marks.add(gm);
                    geotextcont.clear();
                    Get.back();
                  },
                  bg: secondary,
                  fg: primary,
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
