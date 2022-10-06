// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class OrderStatus {
  int id = 0;
  final String identity;
  final String name;
  OrderStatus({
    required this.identity,
    required this.name,
  });

  OrderStatus copyWith({
    String? identity,
    String? name,
  }) {
    return OrderStatus(
      identity: identity ?? this.identity,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': identity,
      'name': name,
    };
  }

  factory OrderStatus.fromMap(Map<String, dynamic> map) {
    return OrderStatus(
      identity: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderStatus.fromJson(String source) =>
      OrderStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OrderStatus(id: $identity, name: $name)';

  @override
  bool operator ==(covariant OrderStatus other) {
    if (identical(this, other)) return true;

    return other.identity == identity && other.name == name;
  }

  @override
  int get hashCode => identity.hashCode ^ name.hashCode;
}
