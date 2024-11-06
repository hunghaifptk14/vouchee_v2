class Category {
  final String id;
  final String voucherTypeId;
  final String title;
  final String voucherTypeTitle;
  final String image;

  Category(
      {required this.id,
      required this.voucherTypeId,
      required this.title,
      required this.voucherTypeTitle,
      required this.image});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      voucherTypeId: json['voucherTypeId'] ?? '',
      voucherTypeTitle: json['voucherTypeTitle'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'voucherTypeId': voucherTypeId,
      'title': title,
      'voucherTypeTitle': voucherTypeTitle,
      'image': image,
    };
  }
}
