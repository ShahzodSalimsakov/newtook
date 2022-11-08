// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

import 'package:arryt/models/terminals.dart';
import 'package:objectbox/objectbox.dart';

import 'customer.dart';
import 'order_next_button.dart';
import 'order_status.dart';

@Entity()
class WaitingOrderModel {
  int id = 0;
  @Index()
  final String identity;
  final double to_lat;
  final double to_lon;
  final int pre_distance;
  final String order_number;
  final int order_price;
  final int? delivery_price;
  final String? delivery_address;
  final String? delivery_comment;
  final DateTime created_at;

  WaitingOrderModel({
    required this.identity,
    required this.to_lat,
    required this.to_lon,
    required this.pre_distance,
    required this.order_number,
    required this.order_price,
    this.delivery_price,
    this.delivery_address,
    this.delivery_comment,
    required this.created_at,
  });

  final customer = ToOne<Customer>();
  final terminal = ToOne<Terminals>();
  final orderStatus = ToOne<OrderStatus>();
  final orderNextButton = ToMany<OrderNextButton>();

  WaitingOrderModel copyWith({
    String? identity,
    double? to_lat,
    double? to_lon,
    int? pre_distance,
    String? order_number,
    int? order_price,
    int? delivery_price,
    String? delivery_address,
    String? delivery_comment,
    DateTime? created_at,
  }) {
    return WaitingOrderModel(
      identity: identity ?? this.identity,
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
      'id': identity,
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

  factory WaitingOrderModel.fromMap(Map<String, dynamic> map) {
    return WaitingOrderModel(
      identity: map['id'] as String,
      to_lat: map['to_lat'] as double,
      to_lon: map['to_lon'] as double,
      pre_distance: map['pre_distance'] as int,
      order_number: map['order_number'] as String,
      order_price: map['order_price'] as int,
      delivery_price: map['delivery_price'] as int?,
      delivery_address: map['delivery_address'] as String?,
      delivery_comment: map['delivery_comment'] as String?,
      created_at: DateTime.parse(map['created_at'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory WaitingOrderModel.fromJson(String source) =>
      WaitingOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Order(id: $identity)';

  @override
  bool operator ==(covariant WaitingOrderModel other) {
    if (identical(this, other)) return true;

    return other.identity == identity;
  }

  @override
  int get hashCode => identity.hashCode;
}
