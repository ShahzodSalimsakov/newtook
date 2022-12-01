// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Organizations {
  final String id;
  final String name;
  final bool active;
  final String? description;
  final int maxDistance;
  final int maxActiveOrderCount;
  final int maxOrderCloseDistance;
  final String supportChatUrl;

  Organizations(
    this.id,
    this.name,
    this.active,
    this.description,
    this.maxDistance,
    this.maxActiveOrderCount,
    this.maxOrderCloseDistance,
    this.supportChatUrl,
  );

  Organizations copyWith({
    String? id,
    String? name,
    bool? active,
    String? description,
    int? maxDistance,
    int? maxActiveOrderCount,
    int? maxOrderCloseDistance,
    String? supportChatUrl,
  }) {
    return Organizations(
      id ?? this.id,
      name ?? this.name,
      active ?? this.active,
      description ?? this.description,
      maxDistance ?? this.maxDistance,
      maxActiveOrderCount ?? this.maxActiveOrderCount,
      maxOrderCloseDistance ?? this.maxOrderCloseDistance,
      supportChatUrl ?? this.supportChatUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'active': active,
      'description': description,
      'max_distance': maxDistance,
      'max_active_order_count': maxActiveOrderCount,
      'max_order_close_distance': maxOrderCloseDistance,
      'support_chat_url': supportChatUrl,
    };
  }

  factory Organizations.fromMap(Map<String, dynamic> map) {
    return Organizations(
      map['id'] as String,
      map['name'] as String,
      map['active'] as bool,
      map['description'] != null ? map['description'] as String : null,
      map['max_distance'] as int,
      map['max_active_order_count'] as int,
      map['max_order_close_distance'] as int,
      map['support_chat_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Organizations.fromJson(String source) =>
      Organizations.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Organizations(id: $id, name: $name, active: $active, description: $description, maxDistance: $maxDistance, maxActiveOrderCount: $maxActiveOrderCount, maxOrderCloseDistance: $maxOrderCloseDistance, supportChatUrl: $supportChatUrl)';
  }

  @override
  bool operator ==(covariant Organizations other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.active == active &&
        other.description == description &&
        other.maxDistance == maxDistance &&
        other.maxActiveOrderCount == maxActiveOrderCount &&
        other.maxOrderCloseDistance == maxOrderCloseDistance &&
        other.supportChatUrl == supportChatUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        active.hashCode ^
        description.hashCode ^
        maxDistance.hashCode ^
        maxActiveOrderCount.hashCode ^
        maxOrderCloseDistance.hashCode ^
        supportChatUrl.hashCode;
  }
}
