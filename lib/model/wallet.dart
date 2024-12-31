// ignore_for_file: public_member_api_docs, sort_constructors_first
class Wallet {
  int totalBalance;
  String? bankAccount;
  String? bankName;
  Wallet({
    required this.totalBalance,
    this.bankAccount,
    this.bankName,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      totalBalance: json['totalBalance'],
      bankAccount: json['bankAccount'] ?? '',
      bankName: json['bankName'] ?? '',
    );
  }
}
