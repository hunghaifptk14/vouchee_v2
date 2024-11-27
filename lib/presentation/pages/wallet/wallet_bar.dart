import 'package:flutter/material.dart';
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
  double? balance;
  bool isLoading = true;
  bool showBalance = true;
  final ApiServices getwallet = ApiServices();
  late Future<Wallet?> futureWallet;
  @override
  void initState() {
    super.initState();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    Wallet? wallet = await getwallet.fetchWallet();
    if (mounted) {
      setState(() {
        balance = wallet!.balance;
        isLoading = false;
      });
    }
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
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
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
                      SizedBox(width: 4),
                      isLoading
                          ? CircularProgressIndicator() // Loading indicator while fetching data
                          : balance != null
                              ? Text(
                                  showBalance
                                      ? "${balance!.toInt()}"
                                      : "**********",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                )
                              : Text(
                                  "bạn chưa có ví",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.red),
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
