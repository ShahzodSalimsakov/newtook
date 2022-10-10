// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerCommentsModel {
  final String id;
  final String comment;
  final String customer_id;
  final DateTime created_at;

  CustomerCommentsModel({
    required this.id,
    required this.comment,
    required this.customer_id,
    required this.created_at,
  });

  CustomerCommentsModel copyWith({
    String? id,
    String? comment,
    String? customer_id,
    DateTime? created_at,
  }) {
    return CustomerCommentsModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      customer_id: customer_id ?? this.customer_id,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'customer_id': customer_id,
      'created_at': created_at.millisecondsSinceEpoch,
    };
  }

  factory CustomerCommentsModel.fromMap(Map<String, dynamic> map) {
    return CustomerCommentsModel(
      id: map['id'] as String,
      comment: map['comment'] as String,
      customer_id: map['customer_id'] as String,
      created_at: DateTime.parse(map['created_at'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerCommentsModel.fromJson(String source) =>
      CustomerCommentsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerCommentsModel(id: $id, comment: $comment, customer_id: $customer_id, created_at: $created_at)';
  }

  @override
  bool operator ==(covariant CustomerCommentsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.comment == comment &&
        other.customer_id == customer_id &&
        other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        comment.hashCode ^
        customer_id.hashCode ^
        created_at.hashCode;
  }
}
