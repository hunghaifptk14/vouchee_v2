// import 'package:flutter/material.dart';
// import 'package:vouchee/model/voucher.dart';

// class CartProvider with ChangeNotifier {
//   final Map<Voucher, int> _cartItems = {};

//   Map<Voucher, int> get cartItems => _cartItems;

//   // double get totalPrice => _cartItems.entries
//   //     .fold(0, (sum, entry) => sum + (entry.key.price * entry.value));

//   // Add Voucher to the cart or increase the quantity if it already exists
//   void addToCart(Voucher voucher) {
//     if (_cartItems.containsKey(Voucher)) {
//       _cartItems[voucher] = _cartItems[voucher]! + 1;
//     } else {
//       _cartItems[voucher] = 1;
//     }
//     notifyListeners();
//   }

//   // Decrease the Voucher quantity in the cart
//   void decreaseQuantity(Voucher voucher) {
//     if (_cartItems.containsKey(voucher) && _cartItems[voucher]! > 1) {
//       _cartItems[voucher] = _cartItems[voucher]! - 1;
//     }
//     notifyListeners();
//   }

//   // Remove a Voucher completely from the cart
//   void removeFromCart(Voucher voucher) {
//     _cartItems.remove(voucher);
//     notifyListeners();
//   }

//   int getQuantity(Voucher voucher) {
//     return _cartItems[voucher] ?? 0;
//   }
// }
