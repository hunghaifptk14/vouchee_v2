class Wallet {
  // List<dynamic> transactions;
  String id;
  double balance;
  String status;
  String createDate;
  String createBy;
  String? updateDate;
  String? updateBy;

  Wallet({
    // required this.transactions,
    required this.id,
    required this.balance,
    required this.status,
    required this.createDate,
    required this.createBy,
    this.updateDate,
    this.updateBy,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      // transactions: json['transactions'],
      id: json['id'],
      balance: (json['balance'] as num).toDouble(),
      status: json['status'],
      createDate: json['createDate'],
      createBy: json['createBy'],
      updateDate: json['updateDate'],
      updateBy: json['updateBy'],
    );
  }
}
