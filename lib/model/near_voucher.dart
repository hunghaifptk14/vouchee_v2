// ignore_for_file: public_member_api_docs, sort_constructors_first
// voucher_model.dart

import 'package:vouchee/model/address.dart';
import 'package:vouchee/model/category.dart';
import 'package:vouchee/model/voucher.dart';

class NearVoucher {
  final Voucher voucher;
  final Category categories;
  final List<Address> addresses;

  NearVoucher({
    required this.voucher,
    required this.categories,
    required this.addresses,
  });

  factory NearVoucher.fromJson(Map<String, dynamic> json) {
    var list = json['addresses'] as List;
    List<Address> addressList = list.map((i) => Address.fromJson(i)).toList();
    return NearVoucher(
      voucher: Voucher.fromJson(json),
      categories: Category.fromJson(json),
      addresses: addressList,
    );
  }
}
