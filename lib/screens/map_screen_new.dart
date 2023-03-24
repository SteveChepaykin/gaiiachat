import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gaiia_chat/controllers/firebase_controller.dart';
import 'package:gaiia_chat/controllers/sharedpref_controller.dart';
import 'package:gaiia_chat/models/geomark_model.dart';
import 'package:gaiia_chat/resources/colors.dart';
import 'package:gaiia_chat/widgets/specialelevatedbutton.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapScreenNew extends StatefulWidget {
  final MapController controller;
  // final String filter;
  const MapScreenNew(this.controller,{super.key});

  @override
  State<MapScreenNew> createState() => _MapScreenNewState();
}

class _MapScreenNewState extends State<MapScreenNew> {
  // late final MapController mapcont;
  late Timer? _timer;
  final TextEditingController geotextcont = TextEditingController();
  List<GeoMark> marks = [];
  String filter = 'all';
  bool canreload = false;

  late final MapOptions options;

  @override
  void initState() {
    _timer = Timer(const Duration(milliseconds: 2000), () {
      getPointsFromFB().whenComplete(
        () => _timer?.cancel(),
      );
      // _timer?.cancel();
    });

    options = MapOptions(
    center: LatLng(
      Get.find<SharedprefController>().initPos.latitude,
      Get.find<SharedprefController>().initPos.longitude,
    ),
    minZoom: 2,
    maxZoom: 18,
    onTap: (pos, point) {
      onSingleTapping(point);
    },
    interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  );

    // getPointsFromFB();

    // mapcont = MapController(initMapWithUserPosition: true);
    // widget.controller.mapEventStream;
    super.initState();
  }

  Future<void> getPointsFromFB() async {
    List<GeoMark> fbmarks = await Get.find<FirebaseController>().getGeoMarks();
    // for (GeoMark gp in fbmarks) {
    // widget.controller.addMarker(gp.geoPoint);
    // }
    setState(() {
      marks = fbmarks;
      canreload = true;
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Color markerColor(String f) {
    switch (f) {
      case 'information':
        return Colors.red;
      case 'ecological':
        return Colors.green;
      case 'social':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color clr = markerColor(filter);
    // List<GeoMark> filteredmarks = marks;
    // if (canreload) {
    //   List<GeoMark> filteredmarks = filter != 'all'
    //       ? marks
    //           .where(
    //             (gm) => gm.layer == filter,
    //           )
    //           .toList()
    //       : marks;
    //   widget.controller.removeMarkers(marks.map((e) => e.geoPoint).toList());
    //   for (GeoMark gp in filteredmarks) {
    //     widget.controller.addMarker(gp.geoPoint);
    //   }
    // }
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
      body: FlutterMap(
        options: options,
        mapController: widget.controller,
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          // MarkerLayer(
          //   markers: [
          //     ...marks.where((element) => element.layer == filter).map(
          //           (e) => Marker(
          //             point: LatLng(e.point.latitude, e.point.longitude),
          //             width: 80,
          //             height: 80,
          //             builder: (context) => Icon(
          //               Icons.place,
          //               color: markerColor(filter),
          //             ),
          //           ),
          //         ),
          //   ],
          // ),
          if (filter == 'all')
            MarkerLayer(
              markers: [
                ...marks.map(
                  (e) => Marker(
                    point: LatLng(e.point.latitude, e.point.longitude),
                    width: 80,
                    height: 80,
                    builder: (context) => const Icon(
                      Icons.place,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          if (filter == 'ecological')
            MarkerLayer(
              markers: [
                ...marks.where((element) => element.layer == 'ecological').map(
                      (e) => Marker(
                        point: LatLng(e.point.latitude, e.point.longitude),
                        width: 80,
                        height: 80,
                        builder: (context) => const Icon(
                          Icons.place,
                          color: Colors.green,
                        ),
                      ),
                    ),
              ],
            ),
          if (filter == 'information')
            MarkerLayer(
              markers: [
                ...marks.where((element) => element.layer == 'information').map(
                      (e) => Marker(
                        point: LatLng(e.point.latitude, e.point.longitude),
                        width: 80,
                        height: 80,
                        builder: (context) => const Icon(Icons.place, color: Colors.red),
                      ),
                    ),
              ],
            ),
          if (filter == 'social')
            MarkerLayer(
              markers: [
                ...marks.where((element) => element.layer == 'social').map(
                      (e) => Marker(
                        point: LatLng(e.point.latitude, e.point.longitude),
                        width: 80,
                        height: 80,
                        builder: (context) => const Icon(Icons.place, color: Colors.blue),
                      ),
                    ),
              ],
            ),
        ],
      ),
    );
  }

  void onSingleTapping(LatLng pos) {
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
                  var gm = await Get.find<FirebaseController>().addGeoMark(
                    {
                      'lat': pos.latitude,
                      'lon': pos.longitude,
                      'desc': geotextcont.text,
                      'layer': filter == 'all' ? 'information' : filter,
                    },
                  );
                  // widget.controller.addMarker(gm.geoPoint);
                  marks.add(gm);
                  geotextcont.clear();
                  Get.back();
                  setState(() {});
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
