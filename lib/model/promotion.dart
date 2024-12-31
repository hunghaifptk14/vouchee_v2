class Promotion {
  final String id;
  final String name;
  final String description;

  final int percentDiscount;

  final int stock;

  final String status;

  Promotion({
    required this.id,
    required this.description,
    required this.name,
    required this.percentDiscount,
    required this.stock,
    required this.status,
  });

  // Factory constructor to create a Promotion object from JSON
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      percentDiscount: json['percentDiscount'],
      stock: json['stock'],
      status: json['status'],
    );
  }

  // Method to convert a Promotion object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'percentDiscount': percentDiscount,
      'stock': stock,
      'status': status,
    };
  }
}
