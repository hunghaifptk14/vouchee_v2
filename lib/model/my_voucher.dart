// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vouchee/model/voucher_code.dart';

class MyVoucher {
  final String id;
  final String title;
  final String image;
  final String isRating;

  final int voucherCodeCount;
  final String sellerId;
  final String sellerImage;
  final List<VoucherCode> voucherCodes;

  MyVoucher({
    required this.id,
    required this.title,
    required this.image,
    required this.isRating,
    required this.voucherCodeCount,
    required this.sellerId,
    required this.sellerImage,
    required this.voucherCodes,
  });

  // Factory constructor to create a Modal from JSON
  factory MyVoucher.fromJson(Map<String, dynamic> json) {
    var voucherCodesFromJson = json['voucherCodes'] as List;
    List<VoucherCode> voucherCodesList = voucherCodesFromJson
        .map((voucherCodeJson) => VoucherCode.fromJson(voucherCodeJson))
        .toList();

    return MyVoucher(
      id: json['id'],
      isRating: json['isRating'],
      title: json['title'],
      image: json['image'],
      voucherCodeCount: json['voucherCodeCount'],
      sellerId: json['sellerId'],
      sellerImage: json['sellerImage'],
      voucherCodes: voucherCodesList,
    );
  }

  // Method to convert the Modal to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isRating': isRating,
      'title': title,
      'image': image,
      'voucherCodeCount': voucherCodeCount,
      'sellerId': sellerId,
      'sellerImage': sellerImage,
      'voucherCodes': voucherCodes.map((voucher) => voucher.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Modal(id: $id, title: $title, image: $image, voucherCodeCount: $voucherCodeCount, sellerId: $sellerId, sellerImage: $sellerImage)';
  }
}
