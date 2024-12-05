// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart';

import 'package:vouchee/core/configs/theme/app_color.dart';
import 'package:vouchee/model/checkout.dart';
import 'package:vouchee/model/item_brief.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class CheckoutPageTest extends StatefulWidget {
  final List<ItemBrief> selectedItems;
  final int useVpoint;
  final int useBalance;
  final String giftEmail;

  const CheckoutPageTest({
    super.key,
    required this.selectedItems,
    required this.useVpoint,
    required this.useBalance,
    required this.giftEmail,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPageTest> {
  late Future<Checkout?> futureCheckout;
  List<Checkout>? checkout;
  ApiServices apiServices = ApiServices();
  String? getOrderIDString;
  String? getOrderID() {
    return getOrderIDString = apiServices.getOrderID();
  }

  @override
  void initState() {
    super.initState();
    futureCheckout = apiServices.checkoutCart(
        items: widget.selectedItems,
        useBalance: widget.useBalance,
        useVpoint: widget.useVpoint,
        giftEmail: widget.giftEmail);
  }

  void loadData() {
    futureCheckout = apiServices.checkoutCart(
        items: widget.selectedItems,
        useBalance: widget.useBalance,
        useVpoint: widget.useVpoint,
        giftEmail: widget.giftEmail);
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel(); // Cancel the timer when the widget is disposed
    }
    if (_cancelTimer.isActive) _cancelTimer.cancel(); // Cancel the cancel timer
    super.dispose();
  }

  String status = '';
  late Timer _timer;
  late Timer _cancelTimer;
  int _elapsedTime = 0;
  bool _timerStarted = false;
  String _orderStatusRequest() {
    setState(() {
      _timerStarted = true;
    });
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      status = await apiServices.getOrderStatus();
      _elapsedTime += 2; // Increment elapsed time by 2 seconds

      if (status == 'PAID') {
        _timer.cancel();
        _cancelTimer.cancel();
        TopSnackbar.show(context, 'Thanh toán thành công');
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      } else {
        _cancelTimer = Timer(Duration(minutes: 2), () {
          _timer.cancel(); // Cancel the periodic timer after 2 minutes
        });
      }
    });

    return status;
  }

  Future<void> _orderRequest() async {
    await apiServices.createOrder(
        items: widget.selectedItems,
        useBalance: widget.useBalance,
        useVpoint: widget.useVpoint,
        giftEmail: widget.giftEmail);
    String? getOrderID() {
      return getOrderIDString = apiServices.getOrderID();
    }

    getOrderID();
  }

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
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi tiết đơn hàng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
                child: FutureBuilder<Checkout?>(
                    future: futureCheckout,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text('No items'));
                      } else {
                        Checkout? check = snapshot.data;
                        // final checkoutList = check ?? [];

                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: check?.sellers.length,
                                itemBuilder: (context, index) {
                                  final seller = check?.sellers[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    ...seller!.modals
                                                        .map((modal) => Column(
                                                              children: [
                                                                _buildTextRow(
                                                                    'Tên voucher',
                                                                    modal
                                                                        .title),
                                                                _buildTextRow(
                                                                    'Thương hiệu',
                                                                    modal
                                                                        .brandName),
                                                                // _buildTextRow(
                                                                //     'Hạn sử dụng',
                                                                //     modal
                                                                //         .endDate),
                                                                _buildPriceRow(
                                                                    'Giá',
                                                                    modal
                                                                        .sellPrice),
                                                                _buildNumberRow(
                                                                    'Áp khuyễn mãi',
                                                                    '${modal.shopDiscountPercent.toInt()}%'),
                                                                _buildPriceRow(
                                                                    'Giảm giá',
                                                                    modal
                                                                        .discountPrice),
                                                                _buildNumberRow(
                                                                    'Số lượng',
                                                                    modal
                                                                        .quantity
                                                                        .toString()),
                                                                // _buildPromotionRow(
                                                                //     'Mã giảm giá', widget.modal.),
                                                                Divider(),
                                                                _buildPriceRow(
                                                                  'Tổng số tiền 1 voucher',
                                                                  modal
                                                                      .totalFinalPrice,
                                                                  isBold: true,
                                                                ),
                                                              ],
                                                            ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Container(
                                child: Column(
                              children: [
                                Text(
                                  'Phương thức thanh toán',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: BoxConstraints(),
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.radio_button_off,
                                                  color: AppColor.lightGrey,
                                                  size: 16,
                                                )),
                                            Text('Sử dụng số dư ví')
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _orderRequest();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.lightBlue,
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        BoxConstraints(),
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons
                                                          .radio_button_checked,
                                                      color: AppColor.primary,
                                                      size: 16,
                                                    )),
                                                Text(
                                                    'Chuyển khoản bằng QR code')
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Text(
                                      'Tổng thanh toán:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      // _currencyFormat(),
                                      check!.finalPrice.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    _orderStatusRequest();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 10),
                                                SizedBox(
                                                  height: 240,
                                                  width: 240,
                                                  child: Image.network(
                                                    'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=${check.finalPrice}&des=ORD$getOrderIDString&template=TEMPLATE&download=DOWNLOAD',
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
                                                      'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=${check.finalPrice}&des=ORD$getOrderIDString&template=TEMPLATE&download=DOWNLOAD',
                                                      path,
                                                    );
                                                    await Gal.putImage(path);
                                                    TopSnackbar.show(
                                                        context, 'Đã tải ảnh');
                                                  },
                                                  child: SizedBox(
                                                    width: 100,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .download_outlined,
                                                          color: AppColor.white,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          'Tải ảnh',
                                                          style: TextStyle(
                                                            color:
                                                                AppColor.white,
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
                                  }, // Disable button if no items are selected
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  child: Text(
                                    'Đặt voucher',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        );
                      }
                    })),
          ],
        ),
      ),
    );
  }

  // Helper method to build each row in the pricing summary
  Widget _buildPromotionRow(String label, String? content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 11,
            ),
          ),
          content == null
              ? Text(
                  content.toString(),
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 11,
                  ),
                )
              : Text(
                  'Chưa có khuyến mãi',
                  style: TextStyle(color: AppColor.lightGrey, fontSize: 11),
                )
        ],
      ),
    );
  }

  Widget _buildNumberRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 11,
            ),
          ),
          Text(
            content.toString(),
            style: TextStyle(
              color: AppColor.black,
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 11,
            ),
          ),
          Text(
            content,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            _currencyFormat(amount),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.teal : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
