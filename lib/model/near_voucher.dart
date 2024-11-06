// ignore_for_file: public_member_api_docs, sort_constructors_first
// voucher_model.dart

import 'package:vouchee/model/address.dart';
import 'package:vouchee/model/category.dart';
import 'package:vouchee/model/voucher.dart';

class NearVoucher {
  final Voucher voucher;
  final Category categories;
  final Address addresses;

  NearVoucher({
    required this.voucher,
    required this.categories,
    required this.addresses,
  });

  factory NearVoucher.fromJson(Map<String, dynamic> json) {
    return NearVoucher(
      voucher: Voucher.fromJson(json),
      categories: Category.fromJson(json),
      addresses: Address.fromJson(json),
    );
  }
}
