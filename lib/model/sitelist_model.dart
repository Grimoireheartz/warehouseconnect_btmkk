// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SiteListModel {
  final String location_name;
  final String latlang;
  final String area_map;
  final String parking_lot;
  SiteListModel({
    required this.location_name,
    required this.latlang,
    required this.area_map,
    required this.parking_lot,
  });

  SiteListModel copyWith({
    String? location_name,
    String? latlang,
    String? area_map,
    String? parking_lot,
  }) {
    return SiteListModel(
      location_name: location_name ?? this.location_name,
      latlang: latlang ?? this.latlang,
      area_map: area_map ?? this.area_map,
      parking_lot: parking_lot ?? this.parking_lot,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location_name': location_name,
      'latlang': latlang,
      'area_map': area_map,
      'parking_lot': parking_lot,
    };
  }

  factory SiteListModel.fromMap(Map<String, dynamic> map) {
    return SiteListModel(
      location_name: map['location_name'] as String,
      latlang: map['latlang'] as String,
      area_map: map['area_map'] as String,
      parking_lot: map['parking_lot'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SiteListModel.fromJson(String source) =>
      SiteListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SiteListModel(location_name: $location_name, latlang: $latlang, area_map: $area_map, parking_lot: $parking_lot)';
  }

  @override
  bool operator ==(covariant SiteListModel other) {
    if (identical(this, other)) return true;

    return other.location_name == location_name &&
        other.latlang == latlang &&
        other.area_map == area_map &&
        other.parking_lot == parking_lot;
  }

  @override
  int get hashCode {
    return location_name.hashCode ^
        latlang.hashCode ^
        area_map.hashCode ^
        parking_lot.hashCode;
  }
}
