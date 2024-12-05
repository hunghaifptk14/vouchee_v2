// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Modal {
  final String id;
  final String voucherId;
  final String brandId;
  final String brandName;
  final String brandImage;
  final String title;
  int quantity;
  final int stock;
  final double originalPrice;
  double sellPrice;
  final double shopDiscountMoney;
  final double shopDiscountPercent;
  final double discountPrice;
  final double salePrice;
  final double totalUnitPrice;
  final double totalDiscountPrice;
  final double totalFinalPrice;
  final String status;
  final String image;
  final String startDate;
  final String endDate;
  bool selected = false;
  final String? shopPromotionId;

  Modal(
      {required this.id,
      required this.voucherId,
      required this.brandId,
      required this.brandName,
      required this.brandImage,
      required this.title,
      required this.quantity,
      required this.stock,
      required this.originalPrice,
      required this.sellPrice,
      required this.shopDiscountMoney,
      required this.shopDiscountPercent,
      required this.discountPrice,
      required this.salePrice,
      required this.totalUnitPrice,
      required this.totalDiscountPrice,
      required this.totalFinalPrice,
      required this.status,
      required this.image,
      required this.startDate,
      required this.endDate,
      required this.shopPromotionId,
      this.selected = false});

  // Factory constructor to create a Modal instance from JSON
  factory Modal.fromJson(Map<String, dynamic> json) {
    return Modal(
      id: json['id'] ?? '',
      voucherId: json['voucherId'] ?? '',
      brandId: json['brandId'] ?? '',
      brandName: json['brandName'] ?? '',
      brandImage: json['brandImage'] ?? '',
      title: json['title'] ?? '',
      quantity: json['quantity'] ?? 0,
      stock: json['stock'],
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      sellPrice: (json['sellPrice'] ?? 0).toDouble(),
      shopDiscountMoney: (json['shopDiscountMoney'] ?? 0).toDouble(),
      shopDiscountPercent: (json['shopDiscountPercent'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      salePrice: (json['salePrice'] ?? 0).toDouble(),
      totalUnitPrice: (json['totalUnitPrice'] ?? 0).toDouble(),
      totalDiscountPrice: (json['totalDiscountPrice'] ?? 0).toDouble(),
      totalFinalPrice: (json['totalFinalPrice'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      shopPromotionId: json['shopPromotionId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'voucherId': voucherId,
      'brandId': brandId,
      'brandName': brandName,
      'brandImage': brandImage,
      'title': title,
      'quantity': quantity,
      'stock': stock,
      'originalPrice': originalPrice,
      'sellPrice': sellPrice,
      'shopDiscountMoney': shopDiscountMoney,
      'shopDiscountPercent': shopDiscountPercent,
      'discountPrice': discountPrice,
      'salePrice': salePrice,
      'totalUnitPrice': totalUnitPrice,
      'totalDiscountPrice': totalDiscountPrice,
      'totalFinalPrice': totalFinalPrice,
      'image': image,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  String toJson() => json.encode(toMap());
  void toggleSelection() {
    selected = !selected;
  }

  @override
  String toString() {
    return 'Modal(id: $id, voucherId: $voucherId, brandId: $brandId, brandName: $brandName, brandImage: $brandImage, title: $title, quantity: $quantity, stock: $stock, originalPrice: $originalPrice, sellPrice: $sellPrice, shopDiscountMoney: $shopDiscountMoney, shopDiscountPercent: $shopDiscountPercent, discountPrice: $discountPrice, salePrice: $salePrice, totalUnitPrice: $totalUnitPrice, totalDiscountPrice: $totalDiscountPrice, totalFinalPrice: $totalFinalPrice, status: $status, image: $image, startDate: $startDate, endDate: $endDate, selected: $selected, shopPromotionId: $shopPromotionId)';
  }
}
