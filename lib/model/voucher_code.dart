// ignore_for_file: public_member_api_docs, sort_constructors_first
class VoucherCode {
  final String id;
  final String modalId;
  final String name;
  final String orderId;
  final String buyerId;
  final String status;
  final String? code; // code can be null
  final String? image;
  final String? newCode;
  final String startDate;
  final String endDate;

  VoucherCode({
    required this.id,
    required this.modalId,
    required this.name,
    required this.orderId,
    required this.buyerId,
    required this.status,
    this.code,
    required this.image,
    this.newCode,
    required this.startDate,
    required this.endDate,
  });

  // Factory constructor to create a VoucherCode from JSON
  factory VoucherCode.fromJson(Map<String, dynamic> json) {
    return VoucherCode(
      id: json['id'],
      name: json['name'],
      modalId: json['modalId'],
      orderId: json['orderId'],
      buyerId: json['buyerId'],
      status: json['status'],
      code: json['code'] ?? '',
      newCode: json['newCode'] ?? '',
      image: json['image'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  // Method to convert the VoucherCode to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'modalId': modalId,
      'orderId': orderId,
      'buyerId': buyerId,
      'status': status,
      'code': code,
      'image': image,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'modalId': modalId,
      'orderId': orderId,
      'buyerId': buyerId,
      'status': status,
      'code': code,
      'image': image,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  @override
  String toString() {
    return 'VoucherCode(id: $id, modalId: $modalId, name: $name, orderId: $orderId, buyerId: $buyerId, status: $status, code: $code, image: $image, newCode: $newCode, startDate: $startDate, endDate: $endDate)';
  }
}
