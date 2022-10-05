// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import '../objectbox.g.dart';

@Entity()
class OrderStatus {
  @Id()
  int osId = 0;
  final String id;
  final String name;
  OrderStatus({
    required this.osId,
    required this.id,
    required this.name,
  });

  OrderStatus copyWith({
    int? osId,
    String? id,
    String? name,
  }) {
    return OrderStatus(
      osId: osId ?? this.osId,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'osId': osId,
      'id': id,
      'name': name,
    };
  }

  factory OrderStatus.fromMap(Map<String, dynamic> map) {
    return OrderStatus(
      osId: map['osId'] as int,
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderStatus.fromJson(String source) =>
      OrderStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OrderStatus(osId: $osId, id: $id, name: $name)';

  @override
  bool operator ==(covariant OrderStatus other) {
    if (identical(this, other)) return true;

    return other.osId == osId && other.id == id && other.name == name;
  }

  @override
  int get hashCode => osId.hashCode ^ id.hashCode ^ name.hashCode;
}
