import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Voucher>> _products;
  ApiServices api = ApiServices();
  List<String> imageUrls = [];
  @override
  void initState() {
    super.initState();
    _products = api.fetchVouchers(); // Lấy dữ liệu khi màn hình được xây dựng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: FutureBuilder<List<Voucher>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            List<Voucher> products = snapshot.data!;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Column(
                  children: [
                    // Slideshow for product images
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true, // Tự động chuyển slide
                        enlargeCenterPage: true, // Phóng to slide giữa
                        aspectRatio: 16 / 9, // Tỉ lệ khung hình
                        viewportFraction: 0.8, // Tỉ lệ màn hình
                      ),
                      items: [
                        Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        )
                      ],
                    ),

                    // Chi tiết sản phẩm
                    ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.title),
                      trailing: Icon(Icons.shopping_cart),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
