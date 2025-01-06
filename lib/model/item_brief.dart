// ignore_for_file: public_member_api_docs, sort_constructors_first
class ItemBrief {
  final List<String> modalId;
  final String? promotionId;
  final String sellerId;

  ItemBrief({
    required this.modalId,
    required this.promotionId,
    required this.sellerId,
  });

  // To convert CartItem to a map for JSON encoding
  Map<String, dynamic> toJson() {
    return {
      "modalId": modalId,
      "promotionId": promotionId,
      // "sellerId": sellerId,
    };
  }

  @override
  String toString() =>
      'ItemBrief(modalId: $modalId, promotionId: $promotionId, sellerId: $sellerId)';
}
