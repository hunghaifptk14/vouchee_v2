// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppUser {
  final String name;
  final String email;
  final String? phoneNumber;
  final String role;
  final String? status;
  final String image;
  final String? bankName;
  final String? bankNumber;
  final String? bankAccount;

  AppUser({
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.status,
    required this.image,
    this.bankName,
    this.bankNumber,
    this.bankAccount,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      image: json['image'] ?? '',
      bankName: json['buyerWallet']['bankName'] ?? '',
      bankAccount: json['buyerWallet']['bankAccount'] ?? '',
      bankNumber: json['buyerWallet']['bankNumber'] ?? '',
    );
  }
}
