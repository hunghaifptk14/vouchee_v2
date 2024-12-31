import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/transactions.dart';
import 'package:vouchee/model/wallet.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  ApiServices apiServices = ApiServices();
  late Future<Wallet> futureWallet;
  late Future<List<BuyerWalletTransaction>> futureWalletTransactions;

  String? getTopUpIDString;
  String? getWithDrawIDString;
  int balance = 0;

  @override
  void initState() {
    super.initState();
    fetchWalletData();
    futureWalletTransactions = apiServices.fetchBuyerTransaction();
  }

  Future<void> fetchWalletData() async {
    Wallet wallet = await apiServices.fetchWallet();

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

  Future<void> _topUpRequest(amount) async {
    await apiServices.topUpRequest(amount: amount);
    String? getTopupID() {
      return getTopUpIDString = apiServices.getTopUpID();
    }

    getTopupID();
  }

  Future<void> _withDrawRequest(amount) async {
    await apiServices.withdrawRequest(amount: amount);
    String? getWithDrawID() {
      return getWithDrawIDString = apiServices.getDrawID();
    }

    getWithDrawID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ví của bạn'),
        // backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Wallet Balance Card
          _buildWalletBalance(),
          SizedBox(
            height: 16,
          ),
          // Transactions Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lịch sử giao dịch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    // Add functionality for "View All"
                  },
                  child: Text('Xem tất cả'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          SingleChildScrollView(
              child: Column(
            children: [
              _showtransactions(context),
            ],
          )), // Flexible takes available space
        ],
      ),
    );
  }

  Widget _buildWalletBalance() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColor.primary,
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [AppColor.middleBue, AppColor.primary],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  'Số dư',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                _currencyFormat(balance),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  'V point',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                '100',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _showTopUpDialog(context);
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Nạp tiền',
                  style: TextStyle(color: AppColor.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.3),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showWithdrawDialog(context);
                },
                icon: Icon(Icons.arrow_downward, color: Colors.white),
                label:
                    Text('Rút tiền', style: TextStyle(color: AppColor.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    final transactions = [
      {
        "title": "Starbucks Coffee",
        "amount": "-12.000 đ",
        "date": "Nov 18, 2024",
        "isExpense": true,
      },
      {
        "title": "Freelance Payment",
        "amount": "+300.000 đ",
        "date": "Nov 15, 2024",
        "isExpense": false,
      },
      {
        "title": "Amazon Purchase",
        "amount": "-40.000 đ",
        "date": "Nov 12, 2024",
        "isExpense": true,
      },
    ];

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          // leading: CircleAvatar(
          //   backgroundColor: transaction['isExpense'] == true
          //       ? Colors.redAccent
          //       : Colors.green,
          //   child: Icon(
          //     transaction['isExpense'] == true
          //         ? Icons.arrow_downward
          //         : Icons.arrow_upward,
          //     color: Colors.white,
          //   ),
          // ),
          title: Text(transaction['title'] as String),
          subtitle: Text(transaction['date'] as String),
          trailing: Text(
            transaction['amount'] as String,
            style: TextStyle(
              color:
                  transaction['isExpense'] == true ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  void _showTopUpDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: AlertDialog(
            title: Text('Nhập số tiền nạp'),
            content: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Nạp'),
                onPressed: () {
                  String amount = amountController.text;
                  _topUpRequest(amount);
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              SizedBox(
                                height: 240,
                                width: 240,
                                child: Image.network(
                                  'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=$amount&des=TOP$getTopUpIDString&template=TEMPLATE&download=DOWNLOAD',
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final path =
                                      '${Directory.systemTemp.path}/QR-code.jpg';
                                  await Dio().download(
                                    'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=$amount&des=TOP$getTopUpIDString&template=TEMPLATE&download=DOWNLOAD',
                                    path,
                                  );
                                  await Gal.putImage(path);
                                  TopSnackbar.show(context, 'Đã tải ảnh');
                                },
                                child: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.download_outlined,
                                        color: AppColor.white,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Tải ảnh',
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhập số tiền rút'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Rút tiền'),
              onPressed: () {
                String amount = amountController.text;
                _withDrawRequest(amount);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showtransactions(BuildContext context) {
    return FutureBuilder<List<BuyerWalletTransaction>>(
      future: futureWalletTransactions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No transactions found'));
        }

        List<BuyerWalletTransaction> transactions = snapshot.data ?? [];

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];

            return ListTile(
              title: Text(transaction.note.toString()),
              subtitle: Text(transaction.createDate.toString()),
              trailing: Text(
                transaction.amount.toString(),
                style: TextStyle(
                  color:
                      transaction.type == 'TOPUP' ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
