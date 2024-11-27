import 'package:vouchee/model/voucher.dart';

class Category {
  final String id;
  final String voucherTypeId;
  final String title;
  final String voucherTypeTitle;
  final String image;
  final List<Voucher> voucher;

  Category(
      {required this.id,
      required this.voucherTypeId,
      required this.title,
      required this.voucherTypeTitle,
      required this.image,
      required this.voucher});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        voucherTypeId: json['voucherTypeId'] ?? '',
        voucherTypeTitle: json['voucherTypeTitle'] ?? '',
        image: json['image'] ?? '',
        voucher: (json['vouchers'] as List<dynamic>?)
                ?.map((voucher) => Voucher.fromJson(voucher))
                .toList() ??
            []);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'voucherTypeId': voucherTypeId,
      'title': title,
      'voucherTypeTitle': voucherTypeTitle,
      'image': image,
      'voucher': voucher.map((voucher) => voucher.toMap()).toList(),
    };
  }
}
