// import 'package:vouchee/model/seller.dart';

// class Cart {
//   final double totalQuantity;
//   final double totalPrice;
//   final double discountPrice;
//   final double finalPrice;
//   final List<Seller> sellers;

//   Cart({
//     required this.totalQuantity,
//     required this.totalPrice,
//     required this.discountPrice,
//     required this.finalPrice,
//     required this.sellers,
//   });

//   factory Cart.fromJson(Map<String, dynamic> json) {
//     return Cart(
//         totalQuantity: (json['totalQuantity'] ?? 0).toDouble(),
//         totalPrice: (json['totalPrice'] ?? 0).toDouble(),
//         discountPrice: (json['discountPrice'] ?? 0).toDouble(),
//         finalPrice: (json['finalPrice'] ?? 0).toDouble(),
//         // sellers: (json['sellers'] as List<dynamic>)
//         //     .map((seller) => Seller.fromJson(seller as Map<String, dynamic>))
//         //     .toList(),
//         sellers: (json['sellers'] as List<dynamic>)
//             .map((seller) => Seller.fromJson(seller as Map<String, dynamic>))
//             .toList());
//   }
// }
// cart.dart
import 'package:vouchee/model/seller.dart';

class Cart {
  final double totalQuantity;
  final double totalPrice;
  final double discountPrice;
  final double finalPrice;
  final List<Seller> sellers;

  Cart({
    required this.totalQuantity,
    required this.totalPrice,
    required this.discountPrice,
    required this.finalPrice,
    required this.sellers,
  });

  // Factory constructor to create a Cart instance from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      totalQuantity: (json['totalQuantity'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      sellers: (json['sellers'] as List)
          .map((sellerJson) => Seller.fromJson(sellerJson))
          .toList(),
    );
  }
}
