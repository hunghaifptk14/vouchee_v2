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
import 'package:vouchee/model/user.dart';
import 'package:vouchee/model/voucher.dart';
import 'package:vouchee/networking/api_request.dart';
import 'package:vouchee/presentation/pages/homePage/home_page.dart';
import 'package:vouchee/presentation/pages/wallet/wallet.dart';
import 'package:vouchee/presentation/widgets/snack_bar.dart';

class CheckoutPage extends StatefulWidget {
  final List<ItemBrief> selectedItems;
  const CheckoutPage({
    super.key,
    required this.selectedItems,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Future<Checkout?> futureCheckout;
  late Future<AppUser> futureGetUser;
  List<Checkout>? checkout;
  ApiServices apiServices = ApiServices();
  String? getOrderIDString;
  Map<int, bool> activeStates = {0: false, 1: false};
  bool isButtonActive = false;
  bool isLoading = false;
  String getEmail = '';
  int? getUseVpoint = 0;
  int? getUseBalance = 0;
  bool isOrderSuccess = false;
  TextEditingController vPointController = TextEditingController();
  @override
  void initState() {
    super.initState();
    futureGetUser = apiServices.getCurrentUser();
    futureCheckout = apiServices.checkoutCart(
      items: widget.selectedItems,
    );
  }

  void loadData() {
    futureCheckout = apiServices.checkoutCart(
      items: widget.selectedItems,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cancelTimer?.cancel();
    super.dispose();
  }

  String _currencyFormat(double amount) {
    String format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0, // No decimal digits
    ).format(amount);
    return format;
  }

  void toggleActiveState(int index) {
    setState(() {
      // Set all other options to false and toggle the selected one
      activeStates.updateAll((key, value) => false);
      activeStates[index] = !activeStates[index]!;

      // Update the button state: active if any option is true
      isButtonActive = activeStates.containsValue(true);
    });
  }

  String status = '';
  Timer? _timer;
  Timer? _cancelTimer;
  int _elapsedTime = 0;
  bool _timerStarted = false;

  void _orderStatusRequest() {
    if (_timerStarted) return; // Prevent multiple timer instances

    setState(() {
      _timerStarted = true;
    });

    // Set a timer to cancel the periodic timer after 2 minutes
    _cancelTimer = Timer(Duration(minutes: 5), () {
      if (_timer?.isActive == true) {
        _timer?.cancel();
        setState(() {
          _timerStarted = false; // Reset state
        });
        TopSnackbar.show(context, 'Hết thời gian giao dịch. vui lòng thử lại');
      }
    });

    // Start the periodic timer to check order status every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        final newStatus = await apiServices.getOrderStatus();

        setState(() {
          status = newStatus;
          _elapsedTime += 2; // Increment elapsed time
        });

        if (status == 'PAID') {
          _timer?.cancel();
          _cancelTimer?.cancel();

          TopSnackbar.show(context, 'Thanh toán thành công');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        _timer?.cancel();
        _cancelTimer?.cancel();

        TopSnackbar.show(context, 'không tạo được đơn hàng',
            backgroundColor: AppColor.warning);
      }
    });
  }

  Future<void> _orderRequest() async {
    setState(() {
      isLoading = true;
    });
    await apiServices.createOrder(
        items: widget.selectedItems,
        useBalance: getUseBalance,
        useVpoint: getUseVpoint,
        giftEmail: getEmail);
    String? getOrderID() {
      return getOrderIDString = apiServices.getOrderID();
    }

    getOrderID();
    if (getOrderIDString == null) {
      setState(() {
        isLoading = false;
        isOrderSuccess = false;
      });
      TopSnackbar.show(context, 'Tạo đơn hàng thất bại',
          backgroundColor: AppColor.warning);
    } else {
      setState(() {
        isLoading = false;
        isOrderSuccess = true;
      });
      TopSnackbar.show(context, 'Tạo đơn hàng thành công',
          backgroundColor: AppColor.success);
      // _orderStatusRequest();
    }
    print(getOrderIDString);
    print(widget.selectedItems);
    print(getUseBalance);
    print(getUseVpoint);
  }

  void handleUseBalance(int useBalance) {
    setState(() {
      getUseBalance = useBalance;
    });
  }

  void getEmailString(String query) {
    bool isValidEmail(String query) {
      // Regular expression for validating email format
      final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      return regex.hasMatch(query);
    }

    if (isValidEmail(query)) {
      setState(() {
        getEmail == query;
      });
    } else {
      TopSnackbar.show(context, 'message', backgroundColor: AppColor.warning);
    }
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
            Row(
              children: [
                Text(
                  'Email nhận voucher: ',
                  style: TextStyle(color: AppColor.lightGrey, fontSize: 12),
                ),
                Expanded(
                  child: _getUserMail(),
                )
              ],
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
                        return Center(child: Text('Chưa có đơn hàng'));
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
                                                                        .sellPrice
                                                                        .toDouble()),
                                                                _buildNumberRow(
                                                                    'Áp khuyễn mãi',
                                                                    '${modal.shopDiscountPercent.toInt()}%'),
                                                                _buildPriceRow(
                                                                    'Giảm giá',
                                                                    -modal
                                                                        .discountPrice
                                                                        .toDouble()),
                                                                _buildNumberRow(
                                                                    'Số lượng',
                                                                    modal
                                                                        .quantity
                                                                        .toString()),
                                                                _buildNumberRow(
                                                                    'Thưởng V-point ',
                                                                    check!
                                                                        .vPointUp
                                                                        .toString()),
                                                                Divider(),
                                                                _buildPriceRow(
                                                                  'Tổng số tiền 1 voucher',
                                                                  modal
                                                                      .totalFinalPrice
                                                                      .toDouble(),
                                                                  isBold: true,
                                                                ),
                                                              ],
                                                            ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'V-point: ',
                                                          style: TextStyle(
                                                            color: AppColor
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(check!.vPoint
                                                            .toString()),
                                                      ],
                                                    ),
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        minimumSize: Size.zero,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                "Nhập V-point bạn muốn dùng",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    vPointController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      null,
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // Parse the entered V-point
                                                                    int?
                                                                        enteredVPoint =
                                                                        int.tryParse(
                                                                            vPointController.text);

                                                                    // Check if the value is valid and not greater than 100
                                                                    if (enteredVPoint ==
                                                                            null ||
                                                                        enteredVPoint <=
                                                                            0) {
                                                                      TopSnackbar
                                                                          .show(
                                                                        context,
                                                                        'Vui lòng nhập số V-point hợp lệ.',
                                                                        backgroundColor:
                                                                            AppColor.warning,
                                                                      );
                                                                    } else if (enteredVPoint >
                                                                        (check.totalPrice *
                                                                            50 /
                                                                            100)) {
                                                                      TopSnackbar
                                                                          .show(
                                                                        context,
                                                                        'Số V-point không được vượt quá 50% tổng đơn hàng.',
                                                                        backgroundColor:
                                                                            AppColor.warning,
                                                                      );
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        getUseVpoint =
                                                                            enteredVPoint;
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      "Hoàn tất"),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Hủy"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }, // Trigger the dialog on press
                                                      child: Text(
                                                        getUseVpoint != 0
                                                            ? getUseVpoint
                                                                .toString()
                                                            : 'Sử dụng điểm', // Show selected V-point or default text
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
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
                                        InkWell(
                                          onTap: () {
                                            // _orderRequest();
                                            toggleActiveState(1);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: activeStates[1]!
                                                  ? AppColor.lightBlue
                                                  : AppColor.white,
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
                                                      activeStates[1]!
                                                          ? Icons
                                                              .radio_button_checked
                                                          : Icons
                                                              .radio_button_off,
                                                      color: activeStates[1]!
                                                          ? AppColor.primary
                                                          : AppColor.lightGrey,
                                                      size: 16,
                                                    )),
                                                Text('Thanh toán với ví')
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // _orderRequest();
                                            toggleActiveState(0);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: activeStates[0]!
                                                  ? AppColor.lightBlue
                                                  : AppColor.white,
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
                                                      activeStates[0]!
                                                          ? Icons
                                                              .radio_button_checked
                                                          : Icons
                                                              .radio_button_off,
                                                      color: activeStates[0]!
                                                          ? AppColor.primary
                                                          : AppColor.lightGrey,
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
                                isButtonActive
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          // performAction();

                                          if (activeStates[0] == true) {
                                            // Trigger the side-effect actions here
                                            await _orderRequest(); // Call the function

                                            // Show the dialog
                                            isOrderSuccess
                                                ? showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Center(
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 10),
                                                                SizedBox(
                                                                  height: 240,
                                                                  width: 240,
                                                                  child: Image
                                                                      .network(
                                                                    'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=${check.finalPrice}&des=ORD$getOrderIDString&template=TEMPLATE&download=DOWNLOAD',
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 8),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    final path =
                                                                        '${Directory.systemTemp.path}/QR-code.jpg';
                                                                    await Dio()
                                                                        .download(
                                                                      'https://qr.sepay.vn/img?acc=0000321753575&bank=MBBank&amount=${check.finalPrice}&des=ORD$getOrderIDString&template=TEMPLATE&download=DOWNLOAD',
                                                                      path,
                                                                    );
                                                                    await Gal
                                                                        .putImage(
                                                                            path);
                                                                    TopSnackbar.show(
                                                                        context,
                                                                        'Đã tải ảnh');
                                                                  },
                                                                  child:
                                                                      SizedBox(
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
                                                                          color:
                                                                              AppColor.white,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                8),
                                                                        Text(
                                                                          'Tải ảnh',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColor.white,
                                                                            fontSize:
                                                                                11,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      );
                                                    },
                                                  )
                                                : Container();
                                          } else if (activeStates[1] == true) {
                                            if (check.balance <
                                                check.totalPrice) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Center(
                                                    child: Container(
                                                      height: 120,
                                                      width: 350,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 4,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: [
                                                              Center(
                                                                child: Text(
                                                                  'Số dư ví không đủ vui lòng nạp thêm',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            AppColor.theme,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'Hủy')),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (BuildContext context) => const WalletPage()));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Nạp thêm',
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppColor.white),
                                                                      )),
                                                                ],
                                                              )
                                                            ]),
                                                      ), // Custom message for insufficient balance
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              handleUseBalance(
                                                  check.totalPrice.toInt());
                                              _orderRequest();
                                            }
                                          }
                                        }, // Disable button if no items are selected
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              Size(double.infinity, 50),
                                          backgroundColor: Colors.blueAccent,
                                        ),
                                        child: isLoading
                                            ? CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white))
                                            : Text(
                                                'Đặt voucher',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.white),
                                              ),
                                      )
                                    : ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              Size(double.infinity, 50),
                                          backgroundColor: Colors.blueAccent,
                                        ),
                                        child: Text(
                                          'Đặt voucher',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.white),
                                        ),
                                      )
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

  Widget _getUserMail() {
    return FutureBuilder<AppUser>(
        future: futureGetUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            AppUser user = snapshot.data!;
            getEmail = user.email;
            return Text(user.email.toString());
          }
        });
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
