import 'package:flutter/material.dart';
import 'package:vouchee/presentation/widgets/appBar/top_app_bar.dart';

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var cartProvider;
    return Scaffold(
      appBar: const TopAppBar(
        topTitle: Text('Thanh toán'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          cartProvider.items.isEmpty
              ? const Text('Chưa có sản phẩm')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: cartProvider.items.map((item) {
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text('Số lượng: ${item.quantity}'),
                      trailing: Text(
                        '${(item.product.price * item.quantity).toStringAsFixed(3)} đ',
                      ),
                    );
                  }).toList(),
                ),
        ]),
      ),
    );
  }
}
