import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/wallet.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/wallet/wallet.dart';

class WalletBar extends StatefulWidget {
  const WalletBar({super.key});

  @override
  State<WalletBar> createState() => _WalletBarState();
}

class _WalletBarState extends State<WalletBar> {
  int balance = 0;

  bool showBalance = true;
  final ApiServices getwallet = ApiServices();
  late Future<Wallet> futureWallet;
  @override
  void initState() {
    super.initState();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    Wallet wallet = await getwallet.fetchWallet();

    setState(() {
      balance = wallet.totalBalance;
    });
  }

  String _currencyFormat(int amount) {
    String format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0, // No decimal digits
    ).format(amount);
    return format;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalletPage(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Số dư: '),
                      balance != ''
                          ? Text(
                              showBalance
                                  ? _currencyFormat(balance)
                                  : "**********",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w600),
                            )
                          : Text(
                              "bạn chưa có ví",
                              style: TextStyle(fontSize: 11, color: Colors.red),
                            ),
                    ],
                  ),
                  IconButton(
                    iconSize: 16,
                    icon: Icon(
                        showBalance ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        showBalance = !showBalance; // Toggle balance visibility
                      });
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
