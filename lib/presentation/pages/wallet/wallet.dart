import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String _currencyFormat(double amount) {
    String format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0, // No decimal digits
    ).format(amount);
    return format;
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
          // Transaction List
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Add functionality for adding money
      //   },
      //   label: Text('Nạp tiền'),
      //   icon: Icon(Icons.add),
      //   backgroundColor: Colors.blueAccent,
      // ),
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
                _currencyFormat(5250000),
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
                  // Add functionality for "Add Money"
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
                  // Add functionality for "Withdraw"
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
}
