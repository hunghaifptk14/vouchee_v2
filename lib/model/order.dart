class Order {
  final String id;
  final String? promotionId;
  final String? paymentType;
  final double? discountValue;
  final double totalPrice;
  final double discountPrice;
  final double? pointDown;
  final double finalPrice;
  final double? pointUp;
  final String status;
  final List<OrderDetail> orderDetails;

  Order({
    required this.id,
    this.promotionId,
    this.paymentType,
    this.discountValue,
    required this.totalPrice,
    required this.discountPrice,
    this.pointDown,
    required this.finalPrice,
    this.pointUp,
    required this.status,
    required this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      promotionId: json['promotionId'],
      paymentType: json['paymentType'],
      discountValue: json['discountValue'],
      totalPrice: json['totalPrice'].toDouble(),
      discountPrice: json['discountPrice'].toDouble(),
      pointDown: json['pointDown'],
      finalPrice: json['finalPrice'].toDouble(),
      pointUp: json['pointUp'],
      status: json['status'],
      orderDetails: (json['orderDetails'] as List)
          .map((item) => OrderDetail.fromJson(item))
          .toList(),
    );
  }
}

class OrderDetail {
  final String orderId;
  final String modalId;
  final double unitPrice;
  final double? discountValue;
  final double totalPrice;
  final double discountPrice;
  final double finalPrice;
  final String status;
  final List<String> voucherCodes;
  final int quantity;

  OrderDetail({
    required this.orderId,
    required this.modalId,
    required this.unitPrice,
    this.discountValue,
    required this.totalPrice,
    required this.discountPrice,
    required this.finalPrice,
    required this.status,
    required this.voucherCodes,
    required this.quantity,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderId: json['orderId'],
      modalId: json['modalId'],
      unitPrice: json['unitPrice'].toDouble(),
      discountValue: json['discountValue'],
      totalPrice: json['totalPrice'].toDouble(),
      discountPrice: json['discountPrice'].toDouble(),
      finalPrice: json['finalPrice'].toDouble(),
      status: json['status'],
      voucherCodes: List<String>.from(json['voucherCodes']),
      quantity: json['quantity'],
    );
  }
}
