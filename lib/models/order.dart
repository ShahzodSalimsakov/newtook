// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

import 'package:objectbox/objectbox.dart';

@Entity()
class OrderModel {
  @Id()
  int oId = 0;
  final String id;
  final String name;
  final String status;
  final int to_lat;
  final int to_lon;
  final Float? pre_distance;
  final int order_number;
  final int order_price;
  final int? delivery_price;
  final String? delivery_address;
  final String? delivery_comment;
  final DateTime created_at;

  OrderModel({
    required this.oId,
    required this.id,
    required this.name,
    required this.status,
    required this.to_lat,
    required this.to_lon,
    this.pre_distance,
    required this.order_number,
    required this.order_price,
    this.delivery_price,
    this.delivery_address,
    this.delivery_comment,
    required this.created_at,
  });

  OrderModel copyWith({
    int? oId,
    String? id,
    String? name,
    String? status,
    int? to_lat,
    int? to_lon,
    Float? pre_distance,
    int? order_number,
    int? order_price,
    int? delivery_price,
    String? delivery_address,
    String? delivery_comment,
    DateTime? created_at,
  }) {
    return OrderModel(
      oId: oId ?? this.oId,
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      to_lat: to_lat ?? this.to_lat,
      to_lon: to_lon ?? this.to_lon,
      pre_distance: pre_distance ?? this.pre_distance,
      order_number: order_number ?? this.order_number,
      order_price: order_price ?? this.order_price,
      delivery_price: delivery_price ?? this.delivery_price,
      delivery_address: delivery_address ?? this.delivery_address,
      delivery_comment: delivery_comment ?? this.delivery_comment,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'oId': oId,
      'id': id,
      'name': name,
      'status': status,
      'to_lat': to_lat,
      'to_lon': to_lon,
      'pre_distance': pre_distance,
      'order_number': order_number,
      'order_price': order_price,
      'delivery_price': delivery_price,
      'delivery_address': delivery_address,
      'delivery_comment': delivery_comment,
      'created_at': created_at.millisecondsSinceEpoch,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      oId: map['oId'] as int,
      id: map['id'] as String,
      name: map['name'] as String,
      status: map['status'] as String,
      to_lat: map['to_lat'] as int,
      to_lon: map['to_lon'] as int,
      pre_distance: map['pre_distance'] as Float?,
      order_number: map['order_number'] as int,
      order_price: map['order_price'] as int,
      delivery_price: map['delivery_price'] as int?,
      delivery_address: map['delivery_address'] as String?,
      delivery_comment: map['delivery_comment'] as String?,
      created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Order(id: $id, name: $name, status: $status)';

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ status.hashCode;
}
