class CartCheckout {
  final String modalId;
  // final String promotionId;

  CartCheckout({
    required this.modalId,
    // required this.promotionId,
  });

  // To convert CartItem to a map for JSON encoding
  Map<String, dynamic> toJson() {
    return {
      "modalId": modalId,
      // "promotionId": promotionId,
    };
  }
}
