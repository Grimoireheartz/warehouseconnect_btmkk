// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TruckInStock {
  final String serial;
  final String model_item;
  final String truck_status;
  final String site;
  final String note_info;
  final String price;
  final String model_year;
  final String picture;
  final String qty;
  TruckInStock({
    required this.serial,
    required this.model_item,
    required this.truck_status,
    required this.site,
    required this.note_info,
    required this.price,
    required this.model_year,
    required this.picture,
    required this.qty,
  });

  TruckInStock copyWith({
    String? serial,
    String? model_item,
    String? truck_status,
    String? site,
    String? note_info,
    String? price,
    String? model_year,
    String? picture,
    String? qty,
  }) {
    return TruckInStock(
      serial: serial ?? this.serial,
      model_item: model_item ?? this.model_item,
      truck_status: truck_status ?? this.truck_status,
      site: site ?? this.site,
      note_info: note_info ?? this.note_info,
      price: price ?? this.price,
      model_year: model_year ?? this.model_year,
      picture: picture ?? this.picture,
      qty: qty ?? this.qty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serial': serial,
      'model_item': model_item,
      'truck_status': truck_status,
      'site': site,
      'note_info': note_info,
      'price': price,
      'model_year': model_year,
      'picture': picture,
      'qty': qty,
    };
  }

  factory TruckInStock.fromMap(Map<String, dynamic> map) {
    return TruckInStock(
      serial: map['serial'] as String,
      model_item: map['model_item'] as String,
      truck_status: map['truck_status'] as String,
      site: map['site'] as String,
      note_info: map['note_info'] as String,
      price: map['price'] as String,
      model_year: map['model_year'] as String,
      picture: map['picture'] as String,
      qty: map['qty'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckInStock.fromJson(String source) =>
      TruckInStock.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TruckInStock(serial: $serial, model_item: $model_item, truck_status: $truck_status, site: $site, note_info: $note_info, price: $price, model_year: $model_year, picture: $picture, qty: $qty)';
  }

  @override
  bool operator ==(covariant TruckInStock other) {
    if (identical(this, other)) return true;

    return other.serial == serial &&
        other.model_item == model_item &&
        other.truck_status == truck_status &&
        other.site == site &&
        other.note_info == note_info &&
        other.price == price &&
        other.model_year == model_year &&
        other.picture == picture &&
        other.qty == qty;
  }

  @override
  int get hashCode {
    return serial.hashCode ^
        model_item.hashCode ^
        truck_status.hashCode ^
        site.hashCode ^
        note_info.hashCode ^
        price.hashCode ^
        model_year.hashCode ^
        picture.hashCode ^
        qty.hashCode;
  }
}
