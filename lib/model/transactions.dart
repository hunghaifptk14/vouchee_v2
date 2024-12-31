class BuyerWalletTransaction {
  String id;
  String? withdrawRequestId;
  String? topUpRequestId;
  String? orderId;
  String? refundRequestId;
  String? partnerTransactionId;
  String? sellerWalletId;
  String buyerWalletId;
  String? supplierWalletId;
  int beforeBalance;
  int afterBalance;
  String type;
  String? note;
  String? updateId;
  String status;
  DateTime createDate;
  String? createBy;
  DateTime? updateDate;
  String? updateBy;
  int amount;

  BuyerWalletTransaction({
    required this.id,
    this.withdrawRequestId,
    this.topUpRequestId,
    this.orderId,
    this.refundRequestId,
    this.partnerTransactionId,
    this.sellerWalletId,
    required this.buyerWalletId,
    this.supplierWalletId,
    required this.beforeBalance,
    required this.afterBalance,
    required this.type,
    this.note,
    this.updateId,
    required this.status,
    required this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
    required this.amount,
  });

  factory BuyerWalletTransaction.fromJson(Map<String, dynamic> json) {
    return BuyerWalletTransaction(
      id: json['id'] ?? 0, // Default to 0 if null
      withdrawRequestId: json['withdrawRequestId'] ?? '',
      topUpRequestId: json['topUpRequestId'] ?? '',
      orderId: json['orderId'] ?? '',
      refundRequestId: json['refundRequestId'] ?? '',
      partnerTransactionId: json['partnerTransactionId'] ?? '',
      sellerWalletId: json['sellerWalletId'] ?? '',
      buyerWalletId: json['buyerWalletId'] ?? '',
      supplierWalletId: json['supplierWalletId'] ?? '',
      beforeBalance: json['beforeBalance'] ?? 0.0, // Default to 0.0 if null
      afterBalance: json['afterBalance'] ?? 0.0, // Default to 0.0 if null
      type: json['type'] ?? '',
      note: json['note'] ?? '',
      updateId: json['updateId'] ?? '',
      status: json['status'] ?? '',
      createDate: json['createDate'] != null
          ? DateTime.parse(json['createDate'])
          : DateTime.now(), // Use current date as fallback
      createBy: json['createBy'] ?? '',
      updateDate: json['updateDate'] != null
          ? DateTime.parse(json['updateDate'])
          : null,
      updateBy: json['updateBy'] ?? '',
      amount: json['amount'] ?? 0.0, // Default to 0.0 if null
    );
  }
}
