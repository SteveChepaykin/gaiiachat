import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class GeoMark {
  final String id;
  late final GeoPoint geoPoint;
  late final String description;

  GeoMark(this.id, Map<String, dynamic> map) {
    description = map['description'] ?? '';
    if (map['lat'] != null && map['lon'] != null) {
      geoPoint = GeoPoint(latitude: map['lat'], longitude: map['lon']);
    } else {
      throw 'NO GEO DATA IN GEOMARK $id';
    }
  }

  GeoMark.fromGeoPoint(this.id, this.geoPoint, this.description);
}