import 'package:vouchee/model/cart.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/model/wallet.dart';

class User {
  String id;
  String roleId;
  String email;
  Wallet buyerWallet;
  Wallet sellerWallet;
  String roleName;
  String status;
  String createDate;
  String createBy;
  String? updateDate;
  String? updateBy;
  List<Cart> carts;
  List<Voucher> vouchers;
  List<dynamic> orders;
  List<dynamic> notificationToUser;
  List<dynamic> notificationFromUser;
  String name;
  String? phoneNumber;
  String image;
  String? bankName;
  String? bankAccount;

  User({
    required this.id,
    required this.roleId,
    required this.email,
    required this.buyerWallet,
    required this.sellerWallet,
    required this.roleName,
    required this.status,
    required this.createDate,
    required this.createBy,
    this.updateDate,
    this.updateBy,
    required this.carts,
    required this.vouchers,
    required this.orders,
    required this.notificationToUser,
    required this.notificationFromUser,
    required this.name,
    this.phoneNumber,
    required this.image,
    this.bankName,
    this.bankAccount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      roleId: json['roleId'],
      email: json['email'],
      buyerWallet: Wallet.fromJson(json['buyerWallet']),
      sellerWallet: Wallet.fromJson(json['sellerWallet']),
      roleName: json['roleName'],
      status: json['status'],
      createDate: json['createDate'],
      createBy: json['createBy'],
      updateDate: json['updateDate'],
      updateBy: json['updateBy'],
      carts:
          (json['carts'] as List).map((cart) => Cart.fromJson(cart)).toList(),
      vouchers: json['vouchers'],
      orders: json['orders'],
      notificationToUser: json['notificationToUser'],
      notificationFromUser: json['notificationFromUser'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      image: json['image'],
      bankName: json['bankName'],
      bankAccount: json['bankAccount'],
    );
  }
}
