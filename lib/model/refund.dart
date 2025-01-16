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
      id: json['id'] ?? "",
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
  final List<VoucherCode> voucherCode;
  final String? reason;
  final String supplierName;
  final String status;
  final String createDate; // Change to String
  final String expireTime; // Change to String
  final String createBy;
  final String? updateDate; // Change to String?
  final String? updateBy; // Change to String?
  final String voucherCodeId;
  final String content;
  final double lon;
  final double lat;

  Refund({
    required this.id,
    required this.medias,
    required this.voucherCode,
    this.reason,
    required this.supplierName,
    required this.status,
    required this.createDate,
    required this.expireTime,
    required this.createBy,
    this.updateDate,
    this.updateBy,
    required this.voucherCodeId,
    required this.content,
    required this.lon,
    required this.lat,
  });

  factory Refund.fromJson(Map<String, dynamic> json) {
    return Refund(
      id: json['id'] ?? " ",
      medias: (json['medias'] as List?)
              ?.map((mediaJson) => Media.fromJson(mediaJson))
              .toList() ??
          [], // Default to empty list if null
      voucherCode: json['voucherCode'] != null
          ? [VoucherCode.fromJson(json['voucherCode'])]
          : [], // If voucherCode exists, map it, otherwise return empty list
      reason: json['reason'], // Nullable
      supplierName: json['supplierName'] ?? " ",
      status: json['status'] ?? " ",
      createDate: json['createDate'] ?? " ", // Directly assign string
      expireTime: json['expireTime'] ?? " ", // Directly assign string
      createBy: json['createBy'] ?? " ",
      updateDate: json['updateDate'], // Directly assign string
      updateBy: json['updateBy'], // Directly assign string
      voucherCodeId: json['voucherCodeId'] ?? " ",
      content: json['content'] ?? " ",
      lon: json['lon']?.toDouble() ?? 0.0,
      lat: json['lat']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'medias': medias.map((media) => media.toJson()).toList(),
      'voucherCode': voucherCode.map((code) => code.toMap()).toList(),
      'reason': reason,
      'supplierName': supplierName,
      'status': status,
      'createDate': createDate, // Return as string
      'expireTime': expireTime, // Return as string
      'createBy': createBy,
      'updateDate': updateDate, // Return as string
      'updateBy': updateBy, // Return as string
      'voucherCodeId': voucherCodeId,
      'content': content,
      'lon': lon,
      'lat': lat,
    };
  }
}
