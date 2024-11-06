// cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vouchee/core/configs/assets/app_vector.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/cart.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/cart/cart_detail.dart';
import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/widgets/buttons/cart_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartPage> {
  late Future<Cart> cartFuture;

  @override
  void initState() {
    super.initState();
    cartFuture = GetCartItem.fetchCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage()));
            },
            icon: SvgPicture.asset(
              AppVector.homeIcon,
              height: 22,
              fit: BoxFit.cover,
              colorFilter:
                  const ColorFilter.mode(AppColor.black, BlendMode.srcIn),
            ),
            iconSize: 22,
          )
        ],
      ),
      body: FutureBuilder<Cart>(
        future: cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Cart is empty'));
          }

          final cart = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Text('Total Quantity: ${cart.totalQuantity}'),
              Text('Total Price: ${cart.totalPrice}'),
              Text('Discount Price: ${cart.discountPrice}'),
              Text('Final Price: ${cart.finalPrice}'),
              SizedBox(height: 20),
              ...cart.sellers.map((seller) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(seller.sellerName,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      ...seller.modals.map((modal) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartDetail(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Text(modal.title),
                                Text(
                                    'Price: ${modal.sellPrice} - Discount: ${modal.percentDiscount}%'),

                                // Image.network(
                                //   modal.imageUrl,
                                //   width: 50,
                                //   height: 50,
                                // ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: AppColor.secondary,
                                            width: 2),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.remove),
                                        iconSize: 10,
                                        onPressed: () {},
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      width: 25,
                                      alignment: Alignment.center,
                                      child: Text(
                                        modal.quantity.toInt().toString(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: AppColor.secondary,
                                            width: 2),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        iconSize: 10,
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      ...seller.modals.map((modal) => Row(
                            children: [
                              // Image.network(modal.imageUrl),
                              Text(modal.title),
                              Text(modal.quantity.toInt().toString())
                            ],
                          )),
                      Divider(),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }
}

Widget bottom_app_bar() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        ElevatedButton(
            onPressed: () {},
            child: Text(
              'button',
              style: TextStyle(color: AppColor.white),
            ))
      ],
    ),
  );
}
