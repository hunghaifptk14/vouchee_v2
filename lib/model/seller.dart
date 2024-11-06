import 'package:vouchee/model/modal.dart';

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

  // Factory constructor to create a Seller instance from JSON
  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      sellerImage: json['sellerImage'],
      modals: (json['modals'] as List)
          .map((modalJson) => Modal.fromJson(modalJson))
          .toList(),
    );
  }
}
