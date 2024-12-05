// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';

import 'package:vouchee/model/category.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/voucher/voucher_detail.dart';

class CategoryDetail extends StatefulWidget {
  final Category category;
  const CategoryDetail({
    super.key,
    required this.category,
  });

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  final ApiServices apiService = ApiServices();
  late Future<Category> futureCate;
  @override
  void initState() {
    super.initState();
    futureCate = apiService.fetchCategoryById(widget.category.id);
  }

  Future<void> _loadCartData() async {
    await apiService.fetchCategoryById(widget.category.id);
  }

  String _currencyFormat(double amount) {
    String format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0, // No decimal digits
    ).format(amount);
    return format;
  }

  double _percentDiscount(double sellPrice, double salePrice) {
    double discount = (1 - (salePrice / sellPrice)) * 100;
    return discount.roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category.title,
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: RefreshIndicator(
            onRefresh: _loadCartData,
            child: FutureBuilder<Category>(
                future: futureCate,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No items in category'));
                  }
                  Category category = snapshot.data!;
                  return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 Vouchers per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            1, // Adjust the aspect ratio for the grid
                      ),
                      itemCount: category.voucher.length,
                      itemBuilder: (BuildContext context, int index) {
                        final voucher = category.voucher[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VoucherDetailPage(voucher: voucher),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColor.white,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        // width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          image: DecorationImage(
                                            image: NetworkImage(voucher.image),
                                            fit: BoxFit
                                                .cover, // Scale the image to fit the container
                                          ),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        voucher.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _currencyFormat(voucher.sellPrice),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.green),
                                          ),
                                          voucher.salePrice != 0
                                              ? Text(
                                                  '-${_percentDiscount(voucher.sellPrice, voucher.salePrice).toInt().toString()}%',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: AppColor.black,
                                                  ),
                                                )
                                              : Text(
                                                  '',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: AppColor.black,
                                                  ),
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                })));
  }
}
