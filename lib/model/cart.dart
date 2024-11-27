import 'package:vouchee/model/seller.dart';

class Cart {
  final double totalQuantity;
  final double balance;
  final String buyerId;
  final double vPoint;
  final List<Seller> sellers;
  double totalPrice = 0;

  Cart({
    required this.totalQuantity,
    required this.balance,
    required this.buyerId,
    required this.vPoint,
    required this.sellers,
  });

  // Factory constructor to create a Cart instance from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      totalQuantity: (json['totalQuantity'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      buyerId: (json['buyerId'] ?? ''),
      vPoint: (json['vPoint'] ?? 0).toDouble(),
      sellers: (json['sellers'] as List)
          .map((sellerJson) => Seller.fromJson(sellerJson))
          .toList(),
    );
  }
}
