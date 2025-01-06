import 'dart:convert';
import 'package:vouchee/model/voucher_code.dart';

class Media {
  final String id;
  final String url;
  final int index;

  Media({
    required this.id,
    required this.url,
    required this.index,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? "Unknown",
      url: json['url'] ?? "", // Empty string if null
      index: json['index'] ?? 0, // Default to 0 if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'index': index,
    };
  }
}

class Refund {
  final String id;
  final List<Media> medias;
  final dynamic walletTransaction; // nullable type
  final List<VoucherCode> voucherCode;
  final String? reason;
  final String supplierName;
  final String status;
  final DateTime createDate;
  final DateTime expireTime;
  final String createBy;
  final String? updateDate;
  final String? updateBy;
  final List<String> images;
  final String voucherCodeId;
  final String content;
  final double lon;
  final double lat;

  Refund({
    required this.id,
    required this.medias,
    this.walletTransaction,
    required this.voucherCode,
    this.reason,
    required this.supplierName,
    required this.status,
    required this.createDate,
    required this.expireTime,
    required this.createBy,
    this.updateDate,
    this.updateBy,
    required this.images,
    required this.voucherCodeId,
    required this.content,
    required this.lon,
    required this.lat,
  });

  // Helper method to parse date
  DateTime parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now(); // Fallback to current date if parsing fails
    }
  }

  factory Refund.fromJson(Map<String, dynamic> json) {
    return Refund(
      id: json['id'] ?? "Unknown", // Handle null values
      medias: (json['medias'] as List?)
              ?.map((mediaJson) => Media.fromJson(mediaJson))
              .toList() ??
          [], // Default to empty list if null
      voucherCode: (json['voucherCode'] as List<dynamic>?)
              ?.map((code) => VoucherCode.fromJson(code))
              .toList() ??
          [], // Handle empty or null list
      walletTransaction: json['walletTransaction'],
      reason: json['reason'], // Nullable
      supplierName: json['supplierName'] ?? "Unknown",
      status: json['status'] ?? "Unknown",
      createDate: (json['createDate']),
      expireTime: (json['expireTime']),
      createBy: json['createBy'] ?? "Unknown",
      updateDate: json['updateDate'],
      updateBy: json['updateBy'],
      images: List<String>.from(json['images'] ?? []), // Default to empty list
      voucherCodeId: json['voucherCodeId'] ?? "Unknown",
      content: json['content'] ?? "Unknown",
      lon: json['lon']?.toDouble() ?? 0.0, // Default to 0.0 if null
      lat: json['lat']?.toDouble() ?? 0.0, // Default to 0.0 if null
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'medias': medias.map((media) => media.toJson()).toList(),
      'walletTransaction': walletTransaction,
      'voucherCode': voucherCode.map((code) => code.toMap()).toList(),
      'reason': reason,
      'supplierName': supplierName,
      'status': status,
      'createDate': createDate.toIso8601String(),
      'expireTime': expireTime.toIso8601String(),
      'createBy': createBy,
      'updateDate': updateDate,
      'updateBy': updateBy,
      'images': images,
      'voucherCodeId': voucherCodeId,
      'content': content,
      'lon': lon,
      'lat': lat,
    };
  }
}
