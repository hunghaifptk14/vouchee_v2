import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/assets/app_image.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/voucher/voucher_detail.dart';

class VoucherList extends StatefulWidget {
  const VoucherList({
    super.key,
  });

  @override
  State<VoucherList> createState() => _VoucherListState();
}

class _VoucherListState extends State<VoucherList> {
  late Future<List<Voucher>> futureVouchers;
  final ApiServices apiService = ApiServices();

  @override
  void initState() {
    super.initState();
    futureVouchers = apiService.fetchVouchers();
  }

  double _percentDiscount(double sellPrice, double salePrice) {
    double discount = (1 - (salePrice / sellPrice)) * 100;
    return discount.roundToDouble();
  }

  String _currencyFormat(double amount) {
    String format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0, // No decimal digits
    ).format(amount);
    return format;
  }

  Future<void> _loadCartData() async {
    futureVouchers = apiService.fetchVouchers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadCartData,
      child: FutureBuilder<List<Voucher>>(
          future: futureVouchers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No vouchers found'));
            } else {
              List<Voucher> vouchers = snapshot.data!;

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 Vouchers per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      0.86, // Adjust the aspect ratio for the grid
                ),
                itemCount: vouchers.length, // Limit to 8 Vouchers
                itemBuilder: (context, index) {
                  // final Voucher = VouchersToShow[index];
                  final voucher = vouchers[index];
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
                          voucher.image != ''
                              ? Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: double.infinity,
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
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                          image: AssetImage(AppImage.man),
                                          fit: BoxFit
                                              .contain, // Scale the image to fit the container
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 8.0, right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  voucher.brandName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _currencyFormat(voucher.sellPrice),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.green),
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
                },
              );
            }
          }),
    );
  }
}
