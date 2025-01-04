// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vouchee/model/modal.dart';

class Seller {
  final String sellerId;
  final String sellerName;
  final String sellerImage;
  final String? appliedPromotion;
  final List<Modal> modals;
  String? selectedPromotionId;
  num totalPriceAfterDiscount = 0;
  Seller({
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.appliedPromotion,
    required this.modals,
    // required this.promotion,
  });

  // Factory constructor to create a Seller instance from JSON
  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerImage: json['sellerImage'] ?? '',
      modals: (json['modals'] as List)
          .map((modalJson) => Modal.fromJson(modalJson))
          .toList(),
      appliedPromotion: json['appliedPromotion'] ?? '',
      // promotion: json['promotion'] ?? '',
    );
  }
}
