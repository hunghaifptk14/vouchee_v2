// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Modal {
  final String id;
  final String voucherId;
  final String brandId;
  final String brandName;
  final String brandImage;
  final String title;
  int quantity; // Can be nullable, default to 0
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
  final double averageRating;
  bool selected = false;
  final String? shopPromotionId;
  final List<ModalRating> modalRating;

  Modal({
    required this.id,
    required this.voucherId,
    required this.brandId,
    required this.brandName,
    required this.brandImage,
    required this.title,
    this.quantity = 0, // Default to 0 if null
    required this.stock,
    required this.originalPrice,
    this.sellPrice = 0.0, // Default to 0.0 if null
    this.shopDiscountMoney = 0.0, // Default to 0.0 if null
    this.shopDiscountPercent = 0.0, // Default to 0.0 if null
    this.discountPrice = 0.0, // Default to 0.0 if null
    this.salePrice = 0.0, // Default to 0.0 if null
    this.totalUnitPrice = 0.0, // Default to 0.0 if null
    this.totalDiscountPrice = 0.0, // Default to 0.0 if null
    this.totalFinalPrice = 0.0, // Default to 0.0 if null
    required this.status,
    required this.image,
    required this.startDate,
    required this.endDate,
    this.averageRating = 0.0, // Default to 0.0 if null
    this.shopPromotionId,
    required this.modalRating,
  });

  factory Modal.fromJson(Map<String, dynamic> json) {
    return Modal(
        id: json['id'] ?? '',
        voucherId: json['voucherId'] ?? '',
        brandId: json['brandId'] ?? '',
        brandName: json['brandName'] ?? '',
        brandImage: json['brandImage'] ?? '',
        title: json['title'] ?? '',
        quantity: json['quantity'] ?? 0, // Default to 0 if null
        stock: json['stock'] ?? 0, // Ensure stock is always an int
        originalPrice:
            (json['originalPrice'] ?? 0).toDouble(), // Default to 0.0 if null
        sellPrice:
            (json['sellPrice'] ?? 0).toDouble(), // Default to 0.0 if null
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
        averageRating: (json['averageRating'] ?? 0).toDouble(),
        shopPromotionId: json['shopPromotionId'],
        modalRating: (json['ratings'] as List<dynamic>?)
                ?.map((modalRating) => ModalRating.fromJson(modalRating))
                .toList() ??
            []);
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
      'averageRating': averageRating,
      'endDate': endDate,
      'shopPromotionId': shopPromotionId,
    };
  }

  String toJson() => json.encode(toMap());

  void toggleSelection() {
    selected = !selected;
  }

  @override
  String toString() {
    return 'Modal(id: $id, voucherId: $voucherId, brandId: $brandId, brandName: $brandName, brandImage: $brandImage, title: $title, quantity: $quantity, stock: $stock, originalPrice: $originalPrice, sellPrice: $sellPrice, shopDiscountMoney: $shopDiscountMoney, shopDiscountPercent: $shopDiscountPercent, discountPrice: $discountPrice, salePrice: $salePrice, totalUnitPrice: $totalUnitPrice, totalDiscountPrice: $totalDiscountPrice, totalFinalPrice: $totalFinalPrice, status: $status, image: $image, startDate: $startDate, endDate: $endDate, averageRating: $averageRating, selected: $selected, shopPromotionId: $shopPromotionId)';
  }
}

class ModalRating {
  final String id;
  final String orderId;
  final String modalId;
  final String modalName;
  final String modalImage;
  final String supplierId;
  final String supplierName;
  final String supplierImage;
  final String sellerId;
  final String sellerName;
  final String sellerImage;
  final String buyerId;
  final String buyerName;
  final String buyerImage;
  final num numberOfReport;
  final num totalStar;
  final num qualityStar;
  final num serviceStar;
  final num sellerStar;
  final String comment;
  final String rep;
  final String status;
  final DateTime createDate;

  ModalRating({
    required this.id,
    required this.orderId,
    required this.modalId,
    required this.modalName,
    required this.modalImage,
    required this.supplierId,
    required this.supplierName,
    required this.supplierImage,
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.buyerId,
    required this.buyerName,
    required this.buyerImage,
    required this.numberOfReport,
    required this.totalStar,
    required this.qualityStar,
    required this.serviceStar,
    required this.sellerStar,
    required this.comment,
    required this.rep,
    required this.status,
    required this.createDate,
  });

  // Factory constructor to create a Rating instance from JSON
  factory ModalRating.fromJson(Map<String, dynamic> json) {
    return ModalRating(
      id: json['id'] ?? "",
      orderId: json['orderId'] ?? "",
      modalId: json['modalId'] ?? "",
      modalName: json['modalName'] ?? "",
      modalImage: json['modalImage'] ?? "",
      supplierId: json['supplierId'] ?? "",
      supplierName: json['supplierName'] ?? "",
      supplierImage: json['supplierImage'] ?? "",
      sellerId: json['sellerId'] ?? "",
      sellerName: json['sellerName'] ?? "",
      sellerImage: json['sellerImage'] ?? "",
      buyerId: json['buyerId'] ?? "",
      buyerName: json['buyerName'] ?? "",
      buyerImage: json['buyerImage'] ?? "",
      numberOfReport: json['numberOfReport'] ?? 0,
      totalStar: json['totalStar'] ?? 0,
      qualityStar: json['qualityStar'] ?? 0,
      serviceStar: json['serviceStar'] ?? 0,
      sellerStar: json['sellerStar'] ?? 0,
      comment: json['comment'] ?? "",
      rep: json['rep'] ?? "",
      status: json['status'] ?? "",
      createDate: DateTime.parse(json['createDate']),
    );
  }

  // Convert a Rating instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'modalId': modalId,
      'modalName': modalName,
      'modalImage': modalImage,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'supplierImage': supplierImage,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerImage': sellerImage,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerImage': buyerImage,
      'numberOfReport': numberOfReport,
      'totalStar': totalStar,
      'qualityStar': qualityStar,
      'serviceStar': serviceStar,
      'sellerStar': sellerStar,
      'comment': comment,
      'rep': rep,
      'status': status,
      'createDate': createDate.toIso8601String(),
    };
  }
}

class Media {
  final String id;
  final String url;
  final int index;

  Media({
    required this.id,
    required this.url,
    required this.index,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      url: json['url'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'index': index,
    };
  }
}
