import 'package:vouchee/model/order_detail.dart';

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
