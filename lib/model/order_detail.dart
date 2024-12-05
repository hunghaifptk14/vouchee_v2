import 'package:vouchee/model/voucher_code.dart';

class OrderDetail {
  final String orderId;
  final String modalId;
  final String image;
  final String brandId;
  final String brandName;
  final String brandImage;
  final int unitPrice;
  final int shopDiscountPercent;
  final int shopDiscountMoney;
  final int totalPrice;
  final int discountPrice;
  final int finalPrice;
  final String status;
  final List<VoucherCode> voucherCodes;
  final int quantity;

  OrderDetail({
    required this.orderId,
    required this.modalId,
    required this.image,
    required this.brandId,
    required this.brandName,
    required this.brandImage,
    required this.unitPrice,
    required this.shopDiscountPercent,
    required this.shopDiscountMoney,
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
      image: json['image'],
      brandId: json['brandId'],
      brandName: json['brandName'],
      brandImage: json['brandImage'],
      unitPrice: json['unitPrice'],
      shopDiscountPercent: json['shopDiscountPercent'],
      shopDiscountMoney: json['shopDiscountMoney'],
      totalPrice: json['totalPrice'],
      discountPrice: json['discountPrice'],
      finalPrice: json['finalPrice'],
      status: json['status'],
      voucherCodes: (json['voucherCodes'] as List<dynamic>)
          .map((e) => VoucherCode.fromJson(e))
          .toList(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'modalId': modalId,
      'image': image,
      'brandId': brandId,
      'brandName': brandName,
      'brandImage': brandImage,
      'unitPrice': unitPrice,
      'shopDiscountPercent': shopDiscountPercent,
      'shopDiscountMoney': shopDiscountMoney,
      'totalPrice': totalPrice,
      'discountPrice': discountPrice,
      'finalPrice': finalPrice,
      'status': status,
      'voucherCodes': voucherCodes.map((e) => e.toJson()).toList(),
      'quantity': quantity,
    };
  }
}
