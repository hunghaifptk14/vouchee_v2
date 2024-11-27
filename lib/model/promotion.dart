class Promotion {
  final String type;
  final String id;
  final String name;
  final String description;
  final int percentDiscount;
  final double? moneyDiscount;
  final int? requiredQuantity;
  final double? maxMoneyToDiscount;
  final double? minMoneyToApply;
  final DateTime? startDate;
  final DateTime? endDate;
  final int stock;
  final String image;
  final bool isActive;
  final String status;

  Promotion({
    required this.type,
    required this.id,
    required this.name,
    required this.description,
    required this.percentDiscount,
    this.moneyDiscount,
    this.requiredQuantity,
    this.maxMoneyToDiscount,
    this.minMoneyToApply,
    this.startDate,
    this.endDate,
    required this.stock,
    required this.image,
    required this.isActive,
    required this.status,
  });

  // Factory constructor to create a Promotion object from JSON
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      type: json['type'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      percentDiscount: json['percentDiscount'],
      moneyDiscount: json['moneyDiscount']?.toDouble(),
      requiredQuantity: json['requiredQuantity'],
      maxMoneyToDiscount: json['maxMoneyToDiscount']?.toDouble(),
      minMoneyToApply: json['minMoneyToApply']?.toDouble(),
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      stock: json['stock'],
      image: json['image'],
      isActive: json['isActive'],
      status: json['status'],
    );
  }

  // Method to convert a Promotion object to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'name': name,
      'description': description,
      'percentDiscount': percentDiscount,
      'moneyDiscount': moneyDiscount,
      'requiredQuantity': requiredQuantity,
      'maxMoneyToDiscount': maxMoneyToDiscount,
      'minMoneyToApply': minMoneyToApply,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'stock': stock,
      'image': image,
      'isActive': isActive,
      'status': status,
    };
  }
}
