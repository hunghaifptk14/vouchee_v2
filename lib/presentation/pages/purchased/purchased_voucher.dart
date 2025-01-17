// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/message.dart';
import 'package:vouchee/model/my_voucher.dart';
import 'package:vouchee/model/refund.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/purchased/rating.dart';
import 'package:vouchee/presentation/pages/purchased/show_code.dart';
import 'package:vouchee/presentation/pages/purchased/show_modal_detail.dart';
import 'package:vouchee/presentation/widgets/bottomNav/bottom_app_bar.dart';

class PurchedVoucher extends StatefulWidget {
  const PurchedVoucher({super.key});

  @override
  _PurchedVoucherState createState() => _PurchedVoucherState();
}

class _PurchedVoucherState extends State<PurchedVoucher> {
  late Future<List<MyVoucher>?> futureMyVoucher;
  late Future<List<MyVoucher>?> futureMyUsedVoucher;
  late Future<List<MyVoucher>?> futureMyPendingVoucher;
  late Future<List<Refund>?> futureRefundVoucher;
  String newCode = '';
  late Future<Message> message;

  ApiServices apiServices = ApiServices();
  bool isShowCode = false;
  @override
  void initState() {
    super.initState();
    futureMyVoucher = apiServices.fetchMyUnuseVoucher();
    futureMyUsedVoucher = apiServices.fetchMyUsedVoucher();
    futureMyPendingVoucher = apiServices.fetchMyPendingVoucher();
    futureRefundVoucher = apiServices.getRefundRequest();
  }

  Future<String> getVouchercode(String codeId) async {
    String code = await apiServices.getVoucherCodeById(codeId);
    setState(() {
      newCode = code;
    });
    return newCode;
  }

  String _DateTimeformat(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);

      String formattedDate =
          DateFormat('HH:mm - dd/MM/yyyy').format(parsedDate);

      return formattedDate;
    } catch (e) {
      // Handle parsing errors
      return "Lỗi thông tin";
    }
  }

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
              Tab(child: Text("Hoàn trả")),
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
          List<MyVoucher> filteredVouchers = myVoucher.where((voucher) {
            return voucher.voucherCodes.any((voucherCode) {
              return voucherCode.status == 'UNUSED';
            });
          }).toList();

          // Check if there are any filtered vouchers
          if (filteredVouchers.isEmpty) {
            return Center(child: Text('Bạn chưa có voucher nào'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredVouchers.length,
              itemBuilder: (context, index) {
                final myvoucher = filteredVouchers[index];

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
                            subtitle: Column(
                              children: [
                                if (myvoucher.voucherCodes.isNotEmpty)
                                  Row(
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () {
                                          print(myvoucher
                                              .voucherCodes[0].modalId);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ShowModalDetail(
                                                            modalId: myvoucher
                                                                .voucherCodes[0]
                                                                .modalId,
                                                          )));
                                        },
                                        child: Text('Xem chi tiết'),
                                      ),
                                    ],
                                  ),
                              ],
                            )),
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
                                  .map((voucherCodes) => Container(
                                        child: voucherCodes.status == 'UNUSED'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Hết hạn:',
                                                        style: TextStyle(
                                                            color: AppColor
                                                                .lightGrey,
                                                            fontSize: 12),
                                                      ),
                                                      compareDate(voucherCodes
                                                                  .endDate) ==
                                                              true
                                                          ? Text(
                                                              ' ${voucherCodes.endDate}',
                                                              style: TextStyle(
                                                                  color: AppColor
                                                                      .warning))
                                                          : Text(
                                                              ' ${voucherCodes.endDate}',
                                                              style: TextStyle(
                                                                  color: AppColor
                                                                      .success),
                                                            ),
                                                    ],
                                                  ),
                                                  compareDate(voucherCodes
                                                              .endDate) ==
                                                          false
                                                      ? ElevatedButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Center(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                AppColor.white,
                                                                            borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                        height:
                                                                            215,
                                                                        // width: 300,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              16.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: 0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                                                padding: EdgeInsets.symmetric(vertical: 16),
                                                                                child: Column(
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
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Opacity(
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
                                                                                    width: 8,
                                                                                  ),
                                                                                  Expanded(
                                                                                      child: ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (BuildContext context) => ShowCodePage(
                                                                                                    date: voucherCodes.endDate,
                                                                                                    title: voucherCodes.name,
                                                                                                    newCode: newCode,
                                                                                                    voucherCodeId: voucherCodes.id,
                                                                                                  )));
                                                                                      getVouchercode(voucherCodes.id);
                                                                                    },
                                                                                    child: Text('Lấy mã', style: TextStyle(color: AppColor.white)),
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
                                                            // Future.delayed(
                                                            //     Duration(
                                                            //         minutes: 5),
                                                            //     () {
                                                            //   Navigator.of(
                                                            //           context,
                                                            //           rootNavigator:
                                                            //               true)
                                                            //       .pop(); // Close the dialog after 5 minutes
                                                            // });
                                                          },
                                                          child: Text(
                                                            'Sử dụng voucher',
                                                            style: TextStyle(
                                                                color: AppColor
                                                                    .white),
                                                          ),
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: null,
                                                          child: Text(
                                                            'Voucher hết hạn',
                                                            style: TextStyle(
                                                                color: AppColor
                                                                    .white),
                                                          ),
                                                        ),
                                                ],
                                              )
                                            : Container(),
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
                              ...myvoucher.voucherCodes
                                  .map((voucherCodes) => Row(
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
                                          myvoucher.isRating != "Đã Rating"
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    print(myvoucher.isRating);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                RatingVoucherPage(
                                                                    orderId:
                                                                        voucherCodes
                                                                            .orderId,
                                                                    modalId:
                                                                        myvoucher
                                                                            .id)));
                                                  },
                                                  child: Text(
                                                    'Đánh giá voucher',
                                                    style: TextStyle(
                                                        color: AppColor.white),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: null,
                                                  child: Text(
                                                    'Đã đánh giá voucher',
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

  Widget _LoadPendingVoucher() {
    return FutureBuilder<List<Refund>?>(
      future: futureRefundVoucher,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Bạn chưa có voucher nào'));
        } else {
          List<Refund>? voucher = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: voucher.length,
              itemBuilder: (context, index) {
                final revoucher = voucher[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    color: AppColor.white,
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...revoucher.voucherCode.map((voucherCode) => Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: SizedBox(
                                          width: 100,
                                          child: Image.network(
                                            voucherCode.image.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(voucherCode.name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                          Text(
                                            voucherCode.modalname!,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Ngày tạo:',
                                              style: TextStyle(
                                                  color: AppColor.lightGrey,
                                                  fontSize: 11)),
                                          Text(
                                            _DateTimeformat(revoucher.createDate
                                                .toString()),
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Divider(
                                    height: 1,
                                    thickness: 0.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      revoucher.status == 'PENDING'
                                          ? Text(
                                              'Voucher của bạn đang được xử lí.',
                                              style: TextStyle(
                                                  color: AppColor.warning,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : Text(
                                              'Voucher của bạn đã được xử lí.',
                                              style: TextStyle(
                                                  color: AppColor.success,
                                                  fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ),
                              ],
                            ))
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
