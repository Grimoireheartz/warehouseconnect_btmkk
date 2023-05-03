// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CampaignModel {
  final String id;
  final String promo_name;
  final String promo_detial;
  final String picture;
  final String url;
  final String stdate;
  final String enddate;
  final String present_datecampaign;
  final String notifications;
  final String notifications_time;
  CampaignModel({
    required this.id,
    required this.promo_name,
    required this.promo_detial,
    required this.picture,
    required this.url,
    required this.stdate,
    required this.enddate,
    required this.present_datecampaign,
    required this.notifications,
    required this.notifications_time,
  });

  CampaignModel copyWith({
    String? id,
    String? promo_name,
    String? promo_detial,
    String? picture,
    String? url,
    String? stdate,
    String? enddate,
    String? present_datecampaign,
    String? notifications,
    String? notifications_time,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      promo_name: promo_name ?? this.promo_name,
      promo_detial: promo_detial ?? this.promo_detial,
      picture: picture ?? this.picture,
      url: url ?? this.url,
      stdate: stdate ?? this.stdate,
      enddate: enddate ?? this.enddate,
      present_datecampaign: present_datecampaign ?? this.present_datecampaign,
      notifications: notifications ?? this.notifications,
      notifications_time: notifications_time ?? this.notifications_time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'promo_name': promo_name,
      'promo_detial': promo_detial,
      'picture': picture,
      'url': url,
      'stdate': stdate,
      'enddate': enddate,
      'present_datecampaign': present_datecampaign,
      'notifications': notifications,
      'notifications_time': notifications_time,
    };
  }

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    return CampaignModel(
      id: map['id'] as String,
      promo_name: map['promo_name'] as String,
      promo_detial: map['promo_detial'] as String,
      picture: map['picture'] as String,
      url: map['url'] as String,
      stdate: map['stdate'] as String,
      enddate: map['enddate'] as String,
      present_datecampaign: map['present_datecampaign'] as String,
      notifications: map['notifications'] as String,
      notifications_time: map['notifications_time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CampaignModel.fromJson(String source) =>
      CampaignModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CampaignModel(id: $id, promo_name: $promo_name, promo_detial: $promo_detial, picture: $picture, url: $url, stdate: $stdate, enddate: $enddate, present_datecampaign: $present_datecampaign, notifications: $notifications, notifications_time: $notifications_time)';
  }

  @override
  bool operator ==(covariant CampaignModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.promo_name == promo_name &&
        other.promo_detial == promo_detial &&
        other.picture == picture &&
        other.url == url &&
        other.stdate == stdate &&
        other.enddate == enddate &&
        other.present_datecampaign == present_datecampaign &&
        other.notifications == notifications &&
        other.notifications_time == notifications_time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        promo_name.hashCode ^
        promo_detial.hashCode ^
        picture.hashCode ^
        url.hashCode ^
        stdate.hashCode ^
        enddate.hashCode ^
        present_datecampaign.hashCode ^
        notifications.hashCode ^
        notifications_time.hashCode;
  }
}
