class VoucherCode {
  final String id;
  final String modalId;
  final String orderId;
  final String buyerId;
  final String status;
  final String? code; // code can be null
  final String? image;
  final String startDate;
  final String endDate;

  VoucherCode({
    required this.id,
    required this.modalId,
    required this.orderId,
    required this.buyerId,
    required this.status,
    this.code,
    required this.image,
    required this.startDate,
    required this.endDate,
  });

  // Factory constructor to create a VoucherCode from JSON
  factory VoucherCode.fromJson(Map<String, dynamic> json) {
    return VoucherCode(
      id: json['id'],
      modalId: json['modalId'],
      orderId: json['orderId'],
      buyerId: json['buyerId'],
      status: json['status'],
      code: json['code'] ?? '',
      image: json['image'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  // Method to convert the VoucherCode to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    return 'VoucherCode(id: $id, modalId: $modalId, orderId: $orderId, buyerId: $buyerId, status: $status, code: $code, image: $image, startDate: $startDate, endDate: $endDate)';
  }
}
