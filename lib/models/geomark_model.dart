import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';

class GeoMark {
  final String id;
  late final GeoPoint geoPoint;
  late final LatLng point;
  late final String description;
  late final String layer;

  GeoMark(this.id, Map<String, dynamic> map) {
    description = map['description'] ?? '';
    if (map['lat'] != null && map['lon'] != null) {
      geoPoint = GeoPoint(latitude: map['lat'], longitude: map['lon']);
      point = LatLng(map['lat'], map['lon']);
    } else {
      throw 'NO GEO DATA IN GEOMARK $id';
    }
    layer = map['layer'] ?? (throw 'NEED A LAYER IN GEOMARK $id');
  }

  GeoMark.fromGeoPoint(this.id, this.point, this.description, this.layer);
}