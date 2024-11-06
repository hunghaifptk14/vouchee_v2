// ignore_for_file: public_member_api_docs, sort_constructors_first

class VoucherCategory {
  final String icon;
  final String name;

  VoucherCategory({
    required this.icon,
    required this.name,
  });
}

final List<VoucherCategory> categories = [
  VoucherCategory(
      icon: 'https://cdn-icons-png.flaticon.com/512/1206/1206796.png',
      name: 'Giải trí'),
  VoucherCategory(
      icon: 'https://cdn-icons-png.flaticon.com/512/7599/7599467.png',
      name: 'Du lịch'),
  VoucherCategory(
      icon: 'https://cdn-icons-png.flaticon.com/512/12705/12705609.png',
      name: 'Ăn uống'),
  VoucherCategory(
      icon: 'https://cdn-icons-png.flaticon.com/512/1719/1719726.png',
      name: 'Sức khỏe'),
  VoucherCategory(
      icon: 'https://cdn-icons-png.flaticon.com/512/2995/2995600.png',
      name: 'Khóa học'),
  VoucherCategory(
      icon: 'https://cdn-icons-png.flaticon.com/512/1874/1874933.png',
      name: 'Phiếu giảm giá'),
  VoucherCategory(
      icon: 'https://cdn-icons-png.flaticon.com/512/3837/3837136.png',
      name: 'Voucher'),
  VoucherCategory(
      icon: 'https://cdn-icons-png.flaticon.com/512/2514/2514133.png',
      name: 'Golf booking'),
];
