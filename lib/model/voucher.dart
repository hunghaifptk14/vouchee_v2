import 'package:vouchee/model/address.dart';
import 'package:vouchee/model/category.dart';
import 'package:vouchee/model/modal.dart';

class Voucher {
  final String id;
  final String title;
  final String description;
  final double rating;
  final String video;
  final double stock;
  final String createDate;
  final String sellerId;
  final double percentDiscount;
  final double originalPrice;
  final double sellPrice;
  final double salePrice;
  final String image;
  final String brandId;
  final String brandName;
  final String brandImage;
  final Category categories;
  final Address address;
  final List<Modal> modals; // Change 'modal' to 'modals'

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.video,
    required this.stock,
    required this.createDate,
    required this.sellerId,
    required this.percentDiscount,
    required this.originalPrice,
    required this.sellPrice,
    required this.salePrice,
    required this.image,
    required this.brandId,
    required this.brandName,
    required this.brandImage,
    required this.categories,
    required this.address,
    required this.modals, // Change 'modal' to 'modals'
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        rating: (json['rating'] ?? 0).toDouble(),
        video: json['video'] ?? '',
        stock: (json['stock'] ?? 0).toDouble(),
        createDate: json['createDate'] ?? '',
        sellerId: json['sellerId'] ?? '',
        percentDiscount: (json['percentDiscount'] ?? 0).toDouble(),
        originalPrice: (json['originalPrice'] ?? 0).toDouble(),
        sellPrice: (json['sellPrice'] ?? 0).toDouble(),
        salePrice: (json['salePrice'] ?? 0).toDouble(),
        image: json['image'] ?? '',
        brandId: json['brandId'] ?? '',
        brandName: json['brandName'] ?? '',
        brandImage: json['brandImage'] ?? '',
        categories: Category.fromJson(json),
        address: Address.fromJson(json),
        modals: (json['modals'] as List<dynamic>?)
                ?.map((modal) => Modal.fromJson(modal))
                .toList() ??
            []); // Parse modals from JSON
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'rating': rating,
      'video': video,
      'stock': stock,
      'createDate': createDate,
      'sellerId': sellerId,
      'percentDiscount': percentDiscount,
      'originalPrice': originalPrice,
      'sellPrice': sellPrice,
      'salePrice': salePrice,
      'image': image,
      'brandId': brandId,
      'brandName': brandName,
      'brandImage': brandImage,
      'categories': categories.toMap(),
      'address': address.toMap(),
      'modals':
          modals.map((modal) => modal.toMap()).toList(), // Map modals to JSON
    };
  }
}
