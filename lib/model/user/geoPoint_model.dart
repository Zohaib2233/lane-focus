import 'package:cloud_firestore/cloud_firestore.dart';

/// An entity of `geo` field of Cloud Firestore location document.
class Geo {
  final String? geohash;
  final GeoPoint? geopoint;
  Geo({
    this.geohash,
    this.geopoint,
  });



  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
    geohash: json.containsKey("geohash")?json['geohash'] as String:'',
    geopoint: json.containsKey('geopoint')?json['geopoint'] as GeoPoint:GeoPoint(0, 0),
  );



  Map<String, dynamic> toJson() => <String, dynamic>{
    if(geohash!=null) 'geohash': geohash,
    if(geopoint!=null ) 'geopoint': geopoint,
  };
}