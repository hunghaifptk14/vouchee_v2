import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/message.dart';
import 'package:vouchee/model/my_voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/purchased/rating.dart';
import 'package:vouchee/presentation/widgets/bottomNav/bottom_app_bar.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class PurchedVoucher extends StatefulWidget {
  const PurchedVoucher({super.key});

  @override
  _PurchedVoucherState createState() => _PurchedVoucherState();
}

class _PurchedVoucherState extends State<PurchedVoucher> {
  late Future<List<MyVoucher>?> futureMyVoucher;
  late Future<List<MyVoucher>?> futureMyUsedVoucher;
  late Future<List<MyVoucher>?> futureMyPendingVoucher;
  late Future<Message> message;

  ApiServices apiServices = ApiServices();
  bool isShowCode = false;
  @override
  void initState() {
    super.initState();
    futureMyVoucher = apiServices.fetchMyUnuseVoucher();
    futureMyUsedVoucher = apiServices.fetchMyUsedVoucher();
    futureMyPendingVoucher = apiServices.fetchMyPendingVoucher();
  }

  void _toggleCode() {
    setState(() {
      isShowCode = !isShowCode;
    });
  }

  // void updateCode(status) {
  //   final updateStatus = 'USED';
  //   setState(() {
  //     status == updateStatus;
  //   });
  // }

  bool compareDate(String targetDateString) {
    final now = DateTime.now();
    final targetDate = DateTime.parse(targetDateString);
    if (now.isAfter(targetDate)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            labelColor: AppColor.secondary,
            indicatorColor: AppColor.secondary,
            unselectedLabelColor: AppColor.lightGrey,
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
                  _LoadUnuseVoucher(),
                  _LoadUsedVoucher(),
                  _LoadPendingVoucher(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _LoadUnuseVoucher() {
    return FutureBuilder<List<MyVoucher>?>(
      future: futureMyVoucher,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Bạn chưa có voucher nào'));
        } else {
          List<MyVoucher> myVoucher = snapshot.data!;
          // List<MyVoucher> filteredVouchers = [];
          // for (var voucher in myVoucher) {
          //   var filteredVoucherCodes = voucher.voucherCodes
          //       .where((voucherCode) => voucherCode.status == status)
          //       .toList();

          //   if (filteredVoucherCodes.isNotEmpty) {
          //     filteredVouchers.add(voucher);
          //     print(filteredVoucherCodes);
          //   }
          // }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: myVoucher.length,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            thickness: 0.5,
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
                                              compareDate(voucherCodes
                                                          .endDate) ==
                                                      true
                                                  ? Text(
                                                      ' ${voucherCodes.endDate}',
                                                      style: TextStyle(
                                                          color:
                                                              AppColor.warning))
                                                  : Text(
                                                      ' ${voucherCodes.endDate}',
                                                      style: TextStyle(
                                                          color:
                                                              AppColor.success),
                                                    ),
                                            ],
                                          ),
                                          compareDate(voucherCodes.endDate) ==
                                                  false
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          16),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: AppColor
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                                height: 215,
                                                                // width: 300,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.warning_amber_rounded,
                                                                              color: AppColor.warning,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            Text(
                                                                              'Lưu ý quan trọng',
                                                                              style: TextStyle(color: AppColor.warning, fontSize: 16, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 16),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            RichText(
                                                                                text: TextSpan(style: TextStyle(fontSize: 14, color: Colors.black), children: [
                                                                              TextSpan(text: '- Sau khi lấy voucher code bạn có '),
                                                                              TextSpan(text: '10 phút ', style: TextStyle(color: Colors.green)),
                                                                              TextSpan(text: 'để quét mã.'),
                                                                            ])),
                                                                            SizedBox(
                                                                              height: 4,
                                                                            ),
                                                                            RichText(
                                                                                text: TextSpan(style: TextStyle(fontSize: 14, color: Colors.black), children: [
                                                                              TextSpan(text: '- Hết 10 phút voucher sẽ được cập nhật là "'),
                                                                              TextSpan(text: 'Đã sử dụng', style: TextStyle(color: Colors.green)),
                                                                              TextSpan(text: '" và không thể hoàn tác.'),
                                                                            ])),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Opacity(
                                                                              opacity: 0.5,
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                style: ElevatedButton.styleFrom(backgroundColor: AppColor.lightGrey),
                                                                                child: Text(
                                                                                  'Hủy',
                                                                                  style: TextStyle(color: AppColor.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Expanded(
                                                                              child: ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return Column(
                                                                                      children: [
                                                                                        Center(
                                                                                            child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                                                                          child: Container(height: 215, decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.all(Radius.circular(15))), child: Image.network(voucherCodes.image!)),
                                                                                          //Test
                                                                                          // child: Container(height: 215, decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.all(Radius.circular(15))), child: Image.network('https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg')),
                                                                                        )),
                                                                                        ElevatedButton(
                                                                                          onPressed: () async {
                                                                                            final path = '${Directory.systemTemp.path}/refund-image.jpg';
                                                                                            await Dio().download(
                                                                                              voucherCodes.image.toString(),
                                                                                              path,
                                                                                            );
                                                                                            //Test
                                                                                            // await Dio().download(
                                                                                            //   'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
                                                                                            //   path,
                                                                                            // );
                                                                                            await Gal.putImage(path);
                                                                                            TopSnackbar.show(context, 'Đã tải ảnh');
                                                                                          },
                                                                                          child: SizedBox(
                                                                                            width: 100,
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                    );
                                                                                  });
                                                                              // apiServices.updateVoucherCodeStatus(voucherCodes.id);
                                                                              // updateCode(voucherCodes.status);
                                                                              apiServices.getVoucherCodeById(voucherCodes.id);
                                                                            },
                                                                            child:
                                                                                Text('Lấy mã', style: TextStyle(color: AppColor.white)),
                                                                          )),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                    Future.delayed(
                                                        Duration(minutes: 1),
                                                        () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(); // Close the dialog after 5 minutes
                                                    });
                                                  },
                                                  child: Text(
                                                    'Sử dụng voucher',
                                                    style: TextStyle(
                                                        color: AppColor.white),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: null,
                                                  child: Text(
                                                    'Voucher hết hạn ',
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

  Widget _LoadUsedVoucher() {
    return FutureBuilder<List<MyVoucher>?>(
      future: futureMyUsedVoucher,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Bạn chưa có voucher nào'));
        } else {
          List<MyVoucher> myVoucher = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: myVoucher.length,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ...myvoucher.voucherCodes.map((voucherCodes) =>
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       'Hết hạn:',
                                      //       style: TextStyle(
                                      //           color: AppColor.lightGrey,
                                      //           fontSize: 12),
                                      //     ),
                                      //     Text(' ${voucherCodes.endDate}'),
                                      //   ],
                                      // ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          RatingVoucherPage(
                                                              orderId:
                                                                  voucherCodes
                                                                      .orderId,
                                                              modalId: myvoucher
                                                                  .id)));
                                        },
                                        child: Text(
                                          'Đánh giá voucher',
                                          style:
                                              TextStyle(color: AppColor.white),
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

  Widget _LoadPendingVoucher() {
    return FutureBuilder<List<MyVoucher>?>(
      future: futureMyPendingVoucher,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Bạn chưa có voucher nào'));
        } else {
          List<MyVoucher> myVoucher = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: myVoucher.length,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            thickness: 0.5,
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
