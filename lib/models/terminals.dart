// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:newtook/objectbox.g.dart';

@Entity()
class Terminals {
  @Id()
  int tId = 0;
  final String id;
  final String name;
  Terminals({
    required this.tId,
    required this.id,
    required this.name,
  });

  Terminals copyWith({
    int? tId,
    String? id,
    String? name,
  }) {
    return Terminals(
      tId: tId ?? this.tId,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tId': tId,
      'id': id,
      'name': name,
    };
  }

  factory Terminals.fromMap(Map<String, dynamic> map) {
    return Terminals(
      tId: map['tId'] as int,
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Terminals.fromJson(String source) =>
      Terminals.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Terminals(tId: $tId, id: $id, name: $name)';

  @override
  bool operator ==(covariant Terminals other) {
    if (identical(this, other)) return true;

    return other.tId == tId && other.id == id && other.name == name;
  }

  @override
  int get hashCode => tId.hashCode ^ id.hashCode ^ name.hashCode;
}
