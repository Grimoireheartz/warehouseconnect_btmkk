// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TruckInfoModel {
  final String warranty_start;
  final String warranty_end;
  final String item_catagory;
  final String item_no;
  final String serial_no;
  final String customer_no;
  final String customer_name;
  final String search_name;
  final String contract_no;
  final String constarting_date;
  final String conexpire_date;
  TruckInfoModel({
    required this.warranty_start,
    required this.warranty_end,
    required this.item_catagory,
    required this.item_no,
    required this.serial_no,
    required this.customer_no,
    required this.customer_name,
    required this.search_name,
    required this.contract_no,
    required this.constarting_date,
    required this.conexpire_date,
  });

  TruckInfoModel copyWith({
    String? warranty_start,
    String? warranty_end,
    String? item_catagory,
    String? item_no,
    String? serial_no,
    String? customer_no,
    String? customer_name,
    String? search_name,
    String? contract_no,
    String? constarting_date,
    String? conexpire_date,
  }) {
    return TruckInfoModel(
      warranty_start: warranty_start ?? this.warranty_start,
      warranty_end: warranty_end ?? this.warranty_end,
      item_catagory: item_catagory ?? this.item_catagory,
      item_no: item_no ?? this.item_no,
      serial_no: serial_no ?? this.serial_no,
      customer_no: customer_no ?? this.customer_no,
      customer_name: customer_name ?? this.customer_name,
      search_name: search_name ?? this.search_name,
      contract_no: contract_no ?? this.contract_no,
      constarting_date: constarting_date ?? this.constarting_date,
      conexpire_date: conexpire_date ?? this.conexpire_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'warranty_start': warranty_start,
      'warranty_end': warranty_end,
      'item_catagory': item_catagory,
      'item_no': item_no,
      'serial_no': serial_no,
      'customer_no': customer_no,
      'customer_name': customer_name,
      'search_name': search_name,
      'contract_no': contract_no,
      'constarting_date': constarting_date,
      'conexpire_date': conexpire_date,
    };
  }

  factory TruckInfoModel.fromMap(Map<String, dynamic> map) {
    return TruckInfoModel(
      warranty_start: map['warranty_start'] as String,
      warranty_end: map['warranty_end'] as String,
      item_catagory: map['item_catagory'] as String,
      item_no: map['item_no'] as String,
      serial_no: map['serial_no'] as String,
      customer_no: map['customer_no'] as String,
      customer_name: map['customer_name'] as String,
      search_name: map['search_name'] as String,
      contract_no: map['contract_no'] as String,
      constarting_date: map['constarting_date'] as String,
      conexpire_date: map['conexpire_date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckInfoModel.fromJson(String source) =>
      TruckInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TruckInfoModel(warranty_start: $warranty_start, warranty_end: $warranty_end, item_catagory: $item_catagory, item_no: $item_no, serial_no: $serial_no, customer_no: $customer_no, customer_name: $customer_name, search_name: $search_name, contract_no: $contract_no, constarting_date: $constarting_date, conexpire_date: $conexpire_date)';
  }

  @override
  bool operator ==(covariant TruckInfoModel other) {
    if (identical(this, other)) return true;

    return other.warranty_start == warranty_start &&
        other.warranty_end == warranty_end &&
        other.item_catagory == item_catagory &&
        other.item_no == item_no &&
        other.serial_no == serial_no &&
        other.customer_no == customer_no &&
        other.customer_name == customer_name &&
        other.search_name == search_name &&
        other.contract_no == contract_no &&
        other.constarting_date == constarting_date &&
        other.conexpire_date == conexpire_date;
  }

  @override
  int get hashCode {
    return warranty_start.hashCode ^
        warranty_end.hashCode ^
        item_catagory.hashCode ^
        item_no.hashCode ^
        serial_no.hashCode ^
        customer_no.hashCode ^
        customer_name.hashCode ^
        search_name.hashCode ^
        contract_no.hashCode ^
        constarting_date.hashCode ^
        conexpire_date.hashCode;
  }
}
