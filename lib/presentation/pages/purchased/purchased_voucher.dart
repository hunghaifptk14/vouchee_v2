import 'package:flutter/material.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/my_voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/widgets/bottomNav/bottom_app_bar.dart';

class PurchedVoucher extends StatefulWidget {
  const PurchedVoucher({super.key});

  @override
  _PurchedVoucherState createState() => _PurchedVoucherState();
}

class _PurchedVoucherState extends State<PurchedVoucher> {
  late Future<List<MyVoucher>?> futureMyVoucher;
  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    futureMyVoucher = apiServices.fetchMyVoucher();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text("Chưa sử dụng"),
              ),
              Tab(child: Text("Đã sử dụng")),
              Tab(child: Text("Đang xử lý")),
            ],
          ),
          title: Text('Voucher của bạn'),
        ),
        bottomNavigationBar: BottomAppBarcustom(),
        body: Column(
          children: [
            // TabBarView to display different tabs content
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab - Vouchers
                  _LoadData('UNUSED'),
                  // Second Tab - Placeholder (can be populated later)
                  _LoadData('USED'),
                  // Third Tab - Placeholder (can be populated later)
                  Icon(Icons.directions_bike),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _LoadData(String status) {
    return FutureBuilder<List<MyVoucher>?>(
      future: futureMyVoucher,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No vouchers available.'));
        } else {
          List<MyVoucher> myVoucher = snapshot.data!;
          List<MyVoucher> filteredVouchers = [];
          for (var voucher in myVoucher) {
            // Filter voucherCodes locally to include only "USED" status
            var filteredVoucherCodes = voucher.voucherCodes
                .where((voucherCode) => voucherCode.status == status)
                .toList();

            // If the voucher has "USED" codes, add it to the filtered list
            if (filteredVoucherCodes.isNotEmpty) {
              filteredVouchers.add(voucher);
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredVouchers.length,
              itemBuilder: (context, index) {
                final myvoucher = myVoucher[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    color: AppColor.white,
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              myvoucher.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(myvoucher.title),
                          subtitle: Row(
                            children: [
                              Text(
                                'Số lượng: ',
                                style: TextStyle(
                                    color: AppColor.lightGrey, fontSize: 12),
                              ),
                              Text('${myvoucher.voucherCodeCount}')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ...myvoucher.voucherCodes
                                  .map((voucherCodes) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Hết hạn:',
                                                style: TextStyle(
                                                    color: AppColor.lightGrey,
                                                    fontSize: 12),
                                              ),
                                              Text(' ${voucherCodes.endDate}'),
                                            ],
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Add functionality to use the voucher code
                                            },
                                            child: Text(
                                              'Sử dụng code',
                                              style: TextStyle(
                                                  color: AppColor.white),
                                            ),
                                          ),
                                        ],
                                      )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
