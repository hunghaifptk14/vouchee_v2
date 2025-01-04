import 'package:vouchee/model/category.dart';
import 'package:vouchee/model/modal.dart';

class Voucher {
  final String id;
  final String title;
  final String description;
  final String? video; // Nullable field
  final num stock;
  final String createDate;
  final num? shopDiscount; // Nullable field
  final num originalPrice;
  final num sellPrice;
  final num? salePrice; // Nullable field
  final num totalQuantitySold;
  final num averageRating;
  final String image;
  final String brandId;
  final String brandName;
  final String brandImage;
  final String supplierId;
  final String supplierName;
  final String supplierImage;
  final String sellerId;
  final String sellerName;
  final String sellerImage;
  final String status;
  final bool isActive;
  final List<Category> categories;
  final List<Modal> modals;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    this.video,
    required this.stock,
    required this.createDate,
    this.shopDiscount,
    required this.originalPrice,
    required this.sellPrice,
    this.salePrice,
    required this.totalQuantitySold,
    required this.averageRating,
    required this.image,
    required this.brandId,
    required this.brandName,
    required this.brandImage,
    required this.supplierId,
    required this.supplierName,
    required this.supplierImage,
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.status,
    required this.isActive,
    required this.categories,
    required this.modals,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      video: json['video'], // It can be null
      stock: json['stock'] ?? 0,
      createDate: json['createDate'] ?? '',
      shopDiscount:
          json['shopDiscount'] != null ? (json['shopDiscount'] as int) : null,
      originalPrice:
          json['originalPrice'] != null ? (json['originalPrice'] as int) : 0,
      sellPrice: json['sellPrice'] != null ? (json['sellPrice'] as int) : 0,
      salePrice: json['salePrice'] != null ? (json['salePrice'] as int) : null,
      totalQuantitySold: json['totalQuantitySold'] ?? 0,
      averageRating:
          json['averageRating'] != null ? (json['averageRating'] as int) : 0,
      image: json['image'] ?? '',
      brandId: json['brandId'] ?? '',
      brandName: json['brandName'] ?? '',
      brandImage: json['brandImage'] ?? '',
      supplierId: json['supplierId'] ?? '',
      supplierName: json['supplierName'] ?? '',
      supplierImage: json['supplierImage'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerImage: json['sellerImage'] ?? '',
      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
      modals: (json['modals'] as List)
          .map((modal) => Modal.fromJson(modal))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'video': video,
      'stock': stock,
      'createDate': createDate,
      'shopDiscount': shopDiscount,
      'originalPrice': originalPrice,
      'sellPrice': sellPrice,
      'salePrice': salePrice,
      'totalQuantitySold': totalQuantitySold,
      'averageRating': averageRating,
      'image': image,
      'brandId': brandId,
      'brandName': brandName,
      'brandImage': brandImage,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'supplierImage': supplierImage,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerImage': sellerImage,
      'status': status,
      'isActive': isActive,
      'categories': categories.map((category) => category.toMap()).toList(),
      'modals': modals.map((modal) => modal.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Voucher(id: $id, title: $title, description: $description, video: $video, stock: $stock, createDate: $createDate, shopDiscount: $shopDiscount, originalPrice: $originalPrice, sellPrice: $sellPrice, salePrice: $salePrice, totalQuantitySold: $totalQuantitySold, averageRating: $averageRating, image: $image, brandId: $brandId, brandName: $brandName, brandImage: $brandImage, supplierId: $supplierId, supplierName: $supplierName, supplierImage: $supplierImage, sellerId: $sellerId, sellerName: $sellerName, sellerImage: $sellerImage, status: $status, isActive: $isActive, categories: $categories, modals: $modals)';
  }
}
