import 'package:vouchee/model/modal.dart';

class Checkout {
  final int totalPrice;
  final int shopDiscountPrice;
  final int useVPoint;
  final int useBalance;
  final int finalPrice;
  final int vPointUp;
  final String giftEmail;
  final String buyerId;
  final int balance;
  final int totalQuantity;
  final int vPoint;
  final List<Seller> sellers;

  Checkout({
    required this.totalPrice,
    required this.shopDiscountPrice,
    required this.useVPoint,
    required this.useBalance,
    required this.finalPrice,
    required this.vPointUp,
    required this.giftEmail,
    required this.buyerId,
    required this.balance,
    required this.totalQuantity,
    required this.vPoint,
    required this.sellers,
  });

  factory Checkout.fromJson(Map<String, dynamic> json) {
    var list = json['sellers'] as List;
    List<Seller> sellersList = list.map((i) => Seller.fromJson(i)).toList();
    return Checkout(
      totalPrice: json['totalPrice'],
      shopDiscountPrice: json['shopDiscountPrice'],
      useVPoint: json['useVPoint'],
      useBalance: json['useBalance'],
      finalPrice: json['finalPrice'],
      vPointUp: json['vPointUp'],
      giftEmail: json['giftEmail'],
      buyerId: json['buyerId'],
      balance: json['balance'],
      totalQuantity: json['totalQuantity'],
      vPoint: json['vPoint'],
      sellers: sellersList,
    );
  }
}

class Seller {
  final String sellerId;
  final String sellerName;
  final String sellerImage;
  final List<Modal> modals;

  Seller({
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.modals,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    var list = json['modals'] as List;
    List<Modal> modalsList = list.map((i) => Modal.fromJson(i)).toList();
    return Seller(
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      sellerImage: json['sellerImage'],
      modals: modalsList,
    );
  }
}
