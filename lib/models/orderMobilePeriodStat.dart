import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderMobilePeriodStat {
  int successCount;
  int failedCount;
  int totalPrice;
  String labelCode;
  OrderMobilePeriodStat({
    required this.successCount,
    required this.failedCount,
    required this.totalPrice,
    required this.labelCode,
  });

  OrderMobilePeriodStat copyWith({
    int? successCount,
    int? failedCount,
    int? totalPrice,
    String? labelCode,
  }) {
    return OrderMobilePeriodStat(
      successCount: successCount ?? this.successCount,
      failedCount: failedCount ?? this.failedCount,
      totalPrice: totalPrice ?? this.totalPrice,
      labelCode: labelCode ?? this.labelCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'successCount': successCount,
      'failedCount': failedCount,
      'totalPrice': totalPrice,
      'labelCode': labelCode,
    };
  }

  factory OrderMobilePeriodStat.fromMap(Map<String, dynamic> map) {
    return OrderMobilePeriodStat(
      successCount: map['successCount'] as int,
      failedCount: map['failedCount'] as int,
      totalPrice: map['totalPrice'] as int,
      labelCode: map['labelCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderMobilePeriodStat.fromJson(String source) =>
      OrderMobilePeriodStat.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OrderMobilePeriodStat(successCount: $successCount, failedCount: $failedCount, totalPrice: $totalPrice, labelCode: $labelCode)';

  @override
  bool operator ==(covariant OrderMobilePeriodStat other) {
    if (identical(this, other)) return true;

    return other.successCount == successCount &&
        other.failedCount == failedCount &&
        other.totalPrice == totalPrice &&
        other.labelCode == labelCode;
  }

  @override
  int get hashCode =>
      successCount.hashCode ^
      failedCount.hashCode ^
      totalPrice.hashCode ^
      labelCode.hashCode;
}
