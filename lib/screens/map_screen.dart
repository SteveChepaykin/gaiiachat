import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gaiia_chat/controllers/message_controller.dart';
import 'package:gaiia_chat/resources/colors.dart';
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

  bool ispick = false;

  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: 2000), () {
      for (GeoPoint gp in Get.find<MessageController>().messages) {
        print(gp);
        widget.controller.addMarker(gp);
      }
      _timer?.cancel();
    });
    // mapcont = MapController(initMapWithUserPosition: true);
    widget.controller.listenerMapSingleTapping.addListener(onSingleTapping);
    super.initState();
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
          // StaticPositionGeoPoint p = StaticPositionGeoPoint('asdasd', MarkerIcon(icon: Icon(Icons.location_pin),), )
          // setState(() {
          //   points.add(point);
          // });
          print(point.latitude);
          print(point.longitude);
        },
      ),
      // floatingActionButton: FloatingActionButton(onPressed: !ispick ? () {
      //   setState(() {
      //     ispick = !ispick;
      //   });
      // } : () async {
      //   var gp = await mapcont.centerMap;
      //   mapcont.addMarker(gp);
      //   setState(() {
      //     ispick = !ispick;
      //   });
      // }, child: Icon(ispick ? Icons.place : Icons.abc),),
    );
  }

  void onSingleTapping() {
    if (widget.controller.listenerMapSingleTapping.value != null) {
      Get.find<MessageController>().addMessage(widget.controller.listenerMapSingleTapping.value!);
      widget.controller.addMarker(widget.controller.listenerMapSingleTapping.value!);
      // setState(() {});
    }
  }
}
